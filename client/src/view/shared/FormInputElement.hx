package view.shared;

@:enum
abstract FormInputElement(String)
{
	var button;
	var Hidden;
	var DatePicker;
	var DateTimePicker;	
	var Input;
	var Password;
	var Checkbox;
	var Radio;
	var Select;
	var TextArea;
}