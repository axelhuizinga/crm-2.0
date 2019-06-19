package view.shared;

@:enum
abstract FormElement(String)
{
	var Button = 'Button';
	var DatePicker = 'DatePicker';
	var Hidden = 'Hidden';
	var Input = 'Input';
	var Password = 'Password';
	var Checkbox = 'Checkbox';
	var Radio = 'Radio';
	var Select = 'Select';
	var TextArea = 'TextArea';
}