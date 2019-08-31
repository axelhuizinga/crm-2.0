package action;

enum StatusAction
{
	Tick(date:Date);	
	Status(status:String);
}

abstract StatusReduxAction(ReduxAction) from ReduxAction to ReduxAction {
    public function new(v : StatusAction) {
        this = { type: Status,  value: v };
    }
}
