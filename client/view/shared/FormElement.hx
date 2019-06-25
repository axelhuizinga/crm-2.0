package view.shared;

@:enum
abstract FormElement(String)
{
	var Button = 'Button';
	var Hidden = 'Hidden';
	var Date = 'date';
	var DatePicker = 'DatePicker';
	var DateTime = 'datetime-local';
	var Input = 'Input';
	var Password = 'Password';
	var Checkbox = 'Checkbox';
	var Radio = 'Radio';
	var Select = 'Select';
	var TextArea = 'TextArea';
}