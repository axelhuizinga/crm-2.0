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

		if(param.get('action')==null)
		{
			return self;
		}
		//trace(param);
		Reflect.callMethod(self, Reflect.field(self,param.get('action')), [param]);
		return self;
	}
	
}