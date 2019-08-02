package store;

import redux.FormAction;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;

typedef ContactFormState = 
{
	firstName:String,
	lastName:String,
	email:String
}

typedef AppState =
{
	form:ContactFormState
}

class FormStore 
	implements IReducer<FormAction, ContactFormState> 
	//implements IMiddleware<FormAction, ContactFormState> 
{
	public var initState:ContactFormState;
		
	public var store:StoreMethods<ContactFormState>;

	public function reduce(state:ContactFormState, action:FormAction):ContactFormState
	{
		return switch(action)
		{
			default:
			trace(action);
			state;
		}
	}
	public function new() 
	{
		initState =
		{
			firstName: '',
			lastName: '',
			email: ''
		}
	}
}