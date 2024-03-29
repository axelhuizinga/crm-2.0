package view.shared;
import db.DbRelation;
import haxe.Constraints.Function;
import view.shared.MItem;

typedef MenuBlock =
{
	?alias:String,	
	?dataClassPath:String,	
	?dbRelations:Array<DbRelation>,
	?dbTableJoins:Map<String,String>,
	?dbTableName:String,
	?disabled:Bool,
	?className:String,
	?hasFindForm:Bool,
	?img:String,
	?info:String,
	?isActive:Bool,
	?items:Array<MItem>,
	?label:String,	
	?onActivate:Function,
	?section:String,
	//?tableName:String,
}