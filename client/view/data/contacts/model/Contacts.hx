package view.data.contacts.model;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import view.table.Table.DataColumn;
import view.table.Table.DataState;
import view.shared.FormElement;

/**
 * @author axel@cunity.me
 */

class Contacts
{
	public static var dataAccess:DataAccess = [
		'edit' => {
			source:[
				"contacts" => [
					"fields" => 'user_name,change_pass_required,password']
				],
			view:[
				'first_name'=>{label:'Vorname'},
				'last_name'=>{label:'Name'},
				'email'=>{label:'Email'},
				'phone_number'=>{label:'Telefon'},		
				'company_name'=>{label: 'Firmenname'},				
				'creation_date'=>{label: 'Hinzugefügt', type:DateTimeInput, readonly: true, 
					//displayFormat: function () return {format:"dd.MM.yyyy H:MM", readonly:true}},
					displayFormat: function() return "dd.MM.yyyy H:MM"}, 
				//'date_of_birth'=>{label: 'Geburtsdatum', type:DatePicker, displayFormat: function () return {format:"DD.MM.YYYY"}},
				'date_of_birth'=>{label: 'Geburtsdatum', type:DateInput, displayFormat:  function() return "DD.MM.YYYY"},
				'id' => {type:Hidden},
				'edited_by' => {type:Hidden}
			]
		}
	];

	public static var listColumns:Map<String,DataColumn> = [
		'first_name'=>{label:'Vorname', flexGrow:0},
		'last_name'=>{label:'Name', flexGrow:0},
		'email'=>{label:'Email'},
		'phone_number'=>{label:'Telefon'},		
		'company_name'=>{label: 'Firmenname', flexGrow:1},
		'state' => {label:'Aktiv', className: 'tCenter',
			cellFormat:function(v:String) 
			{
				var uState = (v=='active'?'user':'user-slash');
				//trace(uState);
				return jsx('<span className="fa fa-$uState"></span>');
			}},
		'id' => {show:false}
	];

	public static var dataDisplay:Map<String,DataState> = [
		'contactList' => {columns:listColumns}
	];	
}