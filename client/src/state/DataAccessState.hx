package state;
import db.DBAccessProps;
import haxe.ds.IntMap;
import shared.DbData;
//import state.UserState;

typedef DBsource =
{
    ?dataBase:String,
    ?dbTable:String,
    ?host:String,
    ?port:Int,
    ?url:String,
    ?userState:String,
    ?password:String, 
}

typedef DataAccessState =  
{
	?contactsDbData:DbData,
	?contactActData:IntMap<Map<String,Dynamic>>,
	?contactsData:IntMap<Map<String,Dynamic>>,
	?contactsListParam:DBAccessProps,
	?dealActData:IntMap<Map<String,Dynamic>>,
	?dealData:IntMap<Map<String,Dynamic>>,
	?accountActData:IntMap<Map<String,Dynamic>>,
	?accountsDbData:DbData,
	?accountData:IntMap<Map<String,Dynamic>>,	
	?qcActData:IntMap<Map<String,Dynamic>>,
	?qcData:IntMap<Map<String,Dynamic>>,	
	?returnDebitsData:IntMap<Map<String,Dynamic>>,	
	?dealsDbData:DbData,
	?page:Int,
    ?source:DBsource,
    ?waiting:Bool
}
