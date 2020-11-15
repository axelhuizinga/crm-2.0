package shared;

import haxe.DynamicAccess;
import comments.CommentString.*;
import php.db.PDOStatement;
import php.NativeAssocArray;
import php.Global;
import haxe.Json;
import php.SuperGlobal;
import sys.io.File;
import php.Web;

class Upload {
	public static function go() {
		var rData = Web.getMultipart(10*1024*1024);
		var rKes:Array<String>=[];
		for(k in rData.keys()){
			if(k.indexOf('File')>-1)
				rKes.push(k);
		}
		trace(rKes.join(',')); 
		trace(SuperGlobal._FILES);
		switch(rData.get('action')){
			case 'returnDebitFile':
			if(rData.exists('returnDebitFile')){
				var rDF:NativeAssocArray<String> =  SuperGlobal._FILES['returnDebitFile'];
				var name = "/var/www/vhosts/pitverwaltung.de/files/" + rDF['name'];
				Global.move_uploaded_file(rDF['tmp_name'],name);
				var result:String = Global.file_get_contents('https://${SuperGlobal._SERVER["HTTP_HOST"]}/extlib/rla.php?file=$name');
				trace('https://${SuperGlobal._SERVER["HTTP_HOST"]}/extlib/rla.php?file=$name');
				trace(result);
				dbStore(rData.get('action'), result);
				Global.unlink('/var/www/vhosts/pitverwaltung.de/files/*');
				S.send(result,true);
			}
			S.send(Json.stringify({error:'No File uploaded'}),true);
		}

		S.send(Json.stringify({got:SuperGlobal._FILES}),true);
	}

	static function dbStore(action:String, data:Dynamic):String {
		switch(action){
			case 'returnDebitFile':
				var dRows:Array<Dynamic> = Json.parse(data).rlData;
				var sql =  comment(unindent, format) /*
				INSERT INTO debit_return_statements (id,reason,iban,ba_id,amount,mandator) 
				VALUES(:id,:sepa_code,:iban,:baID,:amount,:mandator)
				ON CONFLICT DO NOTHING
				*/;
				trace(sql);
				var dKeys:Array<String> = 'id,sepa_code,iban,baID,amount'.split(',');
				var bindVals:Array<String> = new Array();
				for(r in dRows)
				{
					var stmt:PDOStatement = S.dbh.prepare(sql);
					if (untyped stmt == false)
					{
						trace(S.dbh.errorInfo());
						S.send(Json.stringify(['error'=>S.dbh.errorInfo()]),true);
						return 'ooops';
					}	
					for(k in dKeys){
						stmt.bindValue(':$k', Reflect.field(r, k));
					}
					stmt.bindValue(':mandator', SuperGlobal._POST['mandator']);
					if(!stmt.execute()){
						S.send(Json.stringify(['error'=>S.dbh.errorInfo()]),true);
						return 'ooops';
					}										
				}
				return 'OK';
			default:
				return 'Nothing2do for $action';
				
		}
	}
}

