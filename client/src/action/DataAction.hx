package action;

import haxe.Constraints.Function;
import haxe.ds.IntMap;
import react.router.RouterMatch;
import shared.DbData;
import action.async.DBAccess;
import action.async.DBAccessProps;
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
	?callBack:Function,
	?selectType:SelectType
}

enum  DataAction
{
	Execute(dataAccess:DBAccessProps);
	Done(data:DbData);
	Error(data:DbData);
	ContactsLoaded(data:DbData);
	SelectAccounts(sData:IntMap<Map<String,Dynamic>>);
	SelectActContacts(sData:IntMap<Map<String,Dynamic>>);
	SelectContacts(sData:IntMap<Map<String,Dynamic>>);
	SelectDeals(sData:IntMap<Map<String,Dynamic>>);
	Sync(dataAccess:DBAccessProps);
	Unselect(id:Int);
}
