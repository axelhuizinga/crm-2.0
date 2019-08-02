package view.shared;

@:enum
abstract FormInputElement(String)
{
	var Button = 'Button';
	var Hidden = 'Hidden';
	var DatePicker = 'DatePicker';
	var DateTimePicker = 'DateTimePicker';	
	var Input = 'Input';
	var Password = 'Password';
	var Checkbox = 'Checkbox';
	var Radio = 'Radio';
	var Select = 'Select';
	var TextArea = 'TextArea';
}