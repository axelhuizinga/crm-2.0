package state;
import haxe.ds.IntMap;
import shared.DbData;
import state.UserState;

typedef DataSource =
{
    ?dataBase:String,
    ?dbTable:String,
    ?host:String,
    ?port:Int,
    ?url:String,
    ?user:String,
    ?pass:String,
}

typedef DataAccessState = 
{
	?dbData:DbData,
	?contactData:IntMap<Map<String,Dynamic>>,
	?dealData:IntMap<Map<String,Dynamic>>,
	?accountData:IntMap<Map<String,Dynamic>>,
    ?source:DataSource,
    ?waiting:Bool
}
