package db;
@:enum
abstract RelationType(String)
{
	var INNER = 'INNER';	
	var LEFT = 'LEFT';	
	var RIGHT = 'RIGHT';	
	var UNION = 'UNION';
}