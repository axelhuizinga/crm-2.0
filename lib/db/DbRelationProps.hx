package db;

typedef DbRelationProps = {
	?alias:String,
	?fields:String,	
	?jCond:String,
	?jType:RelationType,
	?filter:Dynamic,	
	?table:String,
	?version:String
}