package state;
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
	?lastModified:Date,
	?redirectAfterLogin:String
}