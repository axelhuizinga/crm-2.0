package model.data;
import Model;

class DirectDebits extends Model
{
	public function new(?param:Map<String,String>) 
	{
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