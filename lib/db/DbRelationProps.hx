package db;

typedef DbRelationProps = {
	?alias:String,
	?fields:Array<String>,
	?jCond:String,
	?filter:Dynamic,	
	?table:String,
	?version:String
}