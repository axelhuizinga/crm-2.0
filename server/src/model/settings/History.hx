package model.settings;



/**
 * ...
 * @author axel@bi4.me
 */
class History extends Model 
{

	public static function _create() 
	{
		var self:History = new History(param);	
		Reflect.callMethod(self, Reflect.field(self, action), [param]);
	}
	
}