package action;
import view.shared.FormState;
enum FormAction
{
	ArrayInsert;
	ArrayMove;
	ArrayPop;
	ArrayPush;
	ArrayRemove;
	ArrayRemoveAll;
	ArrayShift;
	ArraySplice;
	ArraySwap;
	ArrayUnshift;
	Autofill;
	Blur;
	Change;
	ClearSubmitErrors;
	ClearFields;
	Destroy;
	Focus;
	FormChange(cfp:String, state:FormState);
	Initialize;
	RegisterField;
	Reset;
	ResetSection;
	SetSubmitFailed;
	SetSubmitSucceeded;
	StartAsyncValidation;
	StartSubmit;
	StopAsyncValidation;
	StopSubmit;
	Submit;
	Touch;
	UnregisterField;
	Untouch;
}