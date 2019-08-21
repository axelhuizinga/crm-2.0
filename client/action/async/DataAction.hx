package action.async;

import haxe.ds.IntMap;
import react.router.RouterMatch;
import shared.DbData;
import shared.DBAccess;

/**
 * ...
 * @author axel@cunity.me
 */

enum abstract SelectType(String) {
	var All;	
	var One;
	var Unselect;
	var UnselectAll;
}
typedef LiveDataProps = 
{
	id:Dynamic,
	data: IntMap<Map<String,Dynamic>>,
	match:RouterMatch,
	?selectType:SelectType
}

enum  DataAction
{
	Execute(dataAccess:DBAccessProps);
	//Delete(data:DbData);
	Done(data:DbData);
	Error(data:DbData);
	Load(data:DbData);
	//CreateSelect(id:Int,data:Map<String,Dynamic>,match:RouterMatch);
	Select(sData:IntMap<Map<String,Dynamic>>);
	Unselect(id:Int);
	//Update(data:DBAccessProps);
}
