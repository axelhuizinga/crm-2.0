package model;
import model.UserState;
import view.shared.io.User;
import haxe.Json;
import haxe.ds.StringMap;
import history.History;
import history.Location;
import shared.DbData;

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
	//compState:StringMap<CompState>,
	config:Dynamic,
	?hasError:Bool,
	user:UserState,
    ?source:DataSource,
    waiting:Bool
}
