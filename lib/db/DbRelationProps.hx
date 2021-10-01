package db;

typedef DbRelationProps = {
	?alias:String,
	?fields:String,	
	?jCond:String,
	?jType:JoinType,
	?filter:Dynamic,	
	?table:String,
	?version:String
}