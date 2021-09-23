package model.data;
import php.NativeArray;
import haxe.Unserializer;
import Model;

class DirectDebits extends Model
{
	public function new(?param:Map<String,String>) 
	{
		super(param);
		go();
	}

	function go():Void {
		trace(action);
		switch(action){
			case 'getHistory':
				getHistory();/**/
			case _:
				run();
		}		
	}	

	function getHistory() {
		var sqlBf:StringBuf = new StringBuf();
		//trace(param.get('dataSource'));
		//parseTable();
		dataSource = param.get('dataSource');
		trace(dataSource);
  		queryFields = param.get('fields');
		
		for (table=>tRel in dataSource.keyValueIterator())
		{
			//var tRel:Map<String,Dynamic> = dataSource.get(table);
			queryFields = tRel['fields'].split(',').map(function(f:String) {
				return '${tRel["alias"]}.$f';
			}).join(',');
		}
		for (table=>tRel in dataSource.keyValueIterator())
		{		
			queryFields = tRel['fields'];
			if(sqlBf.length==0){
				sqlBf.add('
				SELECT * FROM
				(SELECT $queryFields FROM ${table}  ');
			}
			else{
				sqlBf.add('UNION SELECT $queryFields FROM ${table} )hun ');
			}
		}

		if(param.exists('filter')&&param.get('filter')!=''){
			filterSql += buildCond(param.get('filter'));
			sqlBf.add(filterSql);
		}		
		var groupParam:String = param.get('group');
		if (groupParam != null)
			buildGroup(groupParam, sqlBf);
		//TODO:HAVING
		var order:String = param.get('order');
		if(order == null)
		{
			order = 'id';
		}
		if (order != null)
			buildOrder(order, sqlBf);
		if(limit.int>0)
			buildLimit(sqlBf);
		if(offset.int>0)
			buildOffset(sqlBf);
		trace(sqlBf.toString());
		var rows:NativeArray = execute(sqlBf.toString());
		sendRows(rows);	
		//sendRows(execute(sqlBf.toString()));	
		
		//return execute(sqlBf.toString());	
		
	}
	
}