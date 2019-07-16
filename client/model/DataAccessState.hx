package model;
import shared.DbData;
import model.UserState;

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
	?hasError:Bool,
	user:UserState,
    ?source:DataSource,
    waiting:Bool
}
