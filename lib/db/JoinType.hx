package db;
@:enum
abstract JoinType(String)
{
	var INNER = 'INNER';	
	var LEFT = 'LEFT';	
	var RIGHT = 'RIGHT';	
}