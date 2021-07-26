package state;
import haxe.ds.IntMap;
import shared.DbData;
import state.UserState;

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
	?contactData:IntMap<Map<String,Dynamic>>,
	?dealActData:IntMap<Map<String,Dynamic>>,
	?dealData:IntMap<Map<String,Dynamic>>,
	?accountActData:IntMap<Map<String,Dynamic>>,
	?accountsDbData:DbData,
	?accountData:IntMap<Map<String,Dynamic>>,	
	?qcActData:IntMap<Map<String,Dynamic>>,
	?qcData:IntMap<Map<String,Dynamic>>,	
	?returnDebitsData:IntMap<Map<String,Dynamic>>,	
	?dealsDbData:DbData,
    ?source:DBsource,
    ?waiting:Bool
}
