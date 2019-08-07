package state;
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
	dbData:DbData,
	user:UserState,
    ?source:DataSource,
    ?waiting:Bool
}
