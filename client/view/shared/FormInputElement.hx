package view.shared;

@:enum
abstract FormInputElement(String)
{
	var Button = 'Button';
	var Hidden = 'Hidden';
	var DateControl = 'DateControl';
	var DateTimeControl = 'DateTimeControl';	
	var Input = 'Input';
	var Password = 'Password';
	var Checkbox = 'Checkbox';
	var Radio = 'Radio';
	var Select = 'Select';
	var TextArea = 'TextArea';
}