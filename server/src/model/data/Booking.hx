package model.data;
import Model;

class Accounts extends Model
{
	public function new(?param:Map<String,String>) 
	{
		//table = 'contacts';
		super(param);
		go();
	}

	function go():Void {
		trace(action);
		switch(action){
			case _:
				run();
		}		
	}	
	
}