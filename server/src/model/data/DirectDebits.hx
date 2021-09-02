package model.data;
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

		sqlBf.add('SELECT $queryFields FROM ');
		if (tableNames.length>1)
		{
			sqlBf.add(joinSql);
		}		
		else
		{
			sqlBf.add('${tableNames[0]} ');
		}
		if (filterSql != null)
		{
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
		sendRows(execute(sqlBf.toString()));	
		//return execute(sqlBf.toString());	
		
	}
	
}