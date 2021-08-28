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
	?lastModified:Date,
	?location:Location,
	?page:Int,
	?redirectAfterLogin:String
}