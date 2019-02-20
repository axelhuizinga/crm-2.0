package model;
import react.router.RouterMatch;
import history.History;
import history.Location;

/**
 * ...
 * @author axel@cunity.me
 */
typedef LocationState =
{
	history:History,
	location:Location,
	?date:Date
}