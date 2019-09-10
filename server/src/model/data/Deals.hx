package model.data;

class Deals extends Model
{
	public function new(?param:Map<String,String>) 
	{
		//table = 'contacts';
		super(param);
	}
	
	public static function _create(param:Map<String,String>):Contacts
	{
		trace(param);
		var self:Contacts = new Contacts(param);		

		if(action==null)
		{
			return self;
		}
		//trace(param);
		Reflect.callMethod(self, Reflect.field(self,action), [param]);
		return self;
	}
	
}