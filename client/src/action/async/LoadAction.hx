package action.async;
import db.DBAccessProps;
import haxe.ds.IntMap;

enum LoadAction
{
	LoadData(component:String,sData:IntMap<Map<String,Dynamic>>);
	LoadList(param:DBAccessProps);

}