package shared;

import haxe.Exception;
import haxe.Serializer;
import php.NativeArray;
import php.Syntax;
import db.DBAccessProps;
import haxe.Utf8;
import db.DbQuery;
import model.data.DebitReturnStatements;
import php.Lib;
import haxe.DynamicAccess;
import comments.CommentString.*;
import php.db.PDOStatement;
import php.NativeAssocArray;
import php.Global;
import haxe.Json;
import php.SuperGlobal;
import sys.io.File;
import php.Web;
import php.extlib.CAMTbox;

class Upload {
	public static function go() {		
		//var rData = Web.getMultipart(10*1024*1024);
		var rData = Lib.hashOfAssociativeArray(SuperGlobal._FILES);
		var keys:String = [for(k in rData.keys())k].map(function (v) return '\'$v\'').join(',');
		trace(keys);
		trace(rData.toString()); 
		trace(SuperGlobal._FILES);
		switch(SuperGlobal._POST['action']){
			case 'returnDebitFile':
			if(rData.exists('returnDebitFile')){
				Global.require_once ('extlib/CAMTbox.php');
				var rDF:NativeAssocArray<String> =  SuperGlobal._FILES['returnDebitFile'];
				var name = '/var/www/${SuperGlobal._SERVER["HTTP_HOST"]}/files/' + rDF['name'];
				Global.move_uploaded_file(rDF['tmp_name'],name);
				trace(name+':' + (Global.file_exists(name)?'Y':'N'));
				try{
					var result:String = CAMTbox.processDebitReturns(name);
					trace(result.substr(0,250));
					if(result.length==0)
					S.send(Json.stringify({error:'No File uploaded'}),true);
					var ids:Array<Int> = dbStore(SuperGlobal._POST['action'], result);
					trace(ids);
					//Syntax.code('array_walk(glob("{0}/files/*"), "unlink")',SuperGlobal._SERVER["HTTP_HOST"]);
					var files:Array<Dynamic> = Lib.toHaxeArray(Syntax.code("glob({0}.'/files/*')",SuperGlobal._SERVER["HOME"]));
					for(file in files){
						Syntax.code("unlink({0})",file);
					}
					//Global.array_walk(Global.glob('/var/www/${SuperGlobal._SERVER["HTTP_HOST"]}/files/*');
					var dbAccProps:DBAccessProps = {
						action:'getStati', 
						classPath:'data.DebitReturnStatements',					
						dbUser:S.dbQuery.dbUser,
						table:'deals',
						filter:{contact:'IN|${ids.join(',')}'}
					};
					//var sQuery:DbQuery = new DbQuery(dbAccProps);
					//Model.dispatch(sQuery);
					/*var ipost:Map<String,Dynamic> = Lib.hashOfAssociativeArray(SuperGlobal._POST);
					ipost.set();
					var rlData:Array<Dynamic> = Json.parse(result).rlData;

					ipost.set('data', [
						for(row in rlData)
							Lib.hashOfAssociativeArray(Lib.associativeArrayOfObject(row))
					]);
					//ipost.set('data', );
					//ipost.set('table', 'debit_return_statements');
					trace(ipost);*/
					var dRS:DebitReturnStatements = new DebitReturnStatements(
						['action'=>'insert','data' => Serializer.run(Json.parse(result).rlData),'table'=> 'debit_return_statements']);
					//trace(dRS.getStati(ids,ipost.get('mandator')));
					trace(result);
					S.send(result,true);
				}
				catch(e:Exception){
					trace(e.details);
					S.send(Json.stringify({error:e.details}),true);
				}

			}
			S.send(Json.stringify({error:'No File uploaded'}),true);
		}

		S.send(Json.stringify({got:SuperGlobal._FILES}),true);
	}

	static function dbStore(action:String, data:Dynamic):Array<Int> {
		var ids:Array<Int> = new Array();
		switch(action){
			case 'returnDebitFile':
				var dRows:Array<Dynamic> = Json.parse(data).rlData;
				var sql =  comment(unindent, format) /*
				INSERT INTO debit_return_statements (id,sepa_code,iban,ba_id,amount,mandator) 
				VALUES(:id,:sepa_code,:iban,:ba_id,:amount,:mandator)
				ON CONFLICT DO NOTHING RETURNING id
				*/;
				trace(sql);
				trace(Global.count(dRows));
				/// TODO: UNIFY FIELDS + COLUMN NAMES
				var dKeys:Array<String> = 'id,sepa_code,iban,ba_id,amount'.split(',');
				var bindVals:Array<String> = new Array();
				for(r in dRows)
				{
					if(r.sepa_code==null || r.sepa_code==''){
						S.send(Json.stringify(['error'=>Std.string(r)]),true);
					}
					var stmt:PDOStatement = S.dbh.prepare(sql);
					if (untyped stmt == false)
					{
						trace(S.dbh.errorInfo());
						S.send(Json.stringify(['error'=>S.dbh.errorInfo()]),true);
					}	
					for(k in dKeys){						
						trace(':$k ' );
						trace(Reflect.field(r, k));
						//trace(':$k ' + Reflect.field(r, k));
						stmt.bindValue(':$k', Reflect.field(r, k));
					}
					stmt.bindValue(':mandator', SuperGlobal._POST['mandator']);
					trace(':mandator' + SuperGlobal._POST['mandator']);
					if(!stmt.execute()){
						trace(stmt.debugDumpParams());
						S.send(Json.stringify(['error'=>S.dbh.errorInfo()]),true);
					}					
					trace(r.id +':'+stmt.fetchColumn());
					ids.push(r.id);
				}
				
			//default:
			//	return [0,'Nothing2do for $action'];
				
		}
		return ids;
	}
}

