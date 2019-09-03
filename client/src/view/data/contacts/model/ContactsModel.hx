package view.data.contacts.model;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import view.table.Table.DataColumn;
import view.table.Table.DataState;
import view.shared.FormInputElement;

/**
 * @author axel@cunity.me
 */

class ContactsModel
{
	public static var dataAccess:DataAccess = [
		'edit' => {
			source:[
				"contacts" => [
					"filter" => 'id'
					]
				],
			view:[
				'title'=>{label:'Anrede'},
				'title_2'=>{label:'Titel'},
				'first_name'=>{label:'Vorname'},
				'last_name'=>{label:'Name'},
				'email'=>{label:'Email'},
				'phone_code'=>{label:'Landesvorwahl'},
				'phone_number'=>{label:'Telefon'},		
				'mobile'=>{label:'Mobil'},
				'fax'=>{label:'Fax'},
				'company_name'=>{label:'Firmenname'},	
				'address'=>{label:'Strasse'},
				'address_2'=>{label:'Hausnummer'},
				'plz'=>{label:'PLZ'},
				'city'=>{label:'Ort'},
				'state'=>{label:'Status',type:Select,options:['active'=>'Aktiv','passive'=>'Passiv','blocked'=>'Gesperrt']},
				'country_code'=>{label:'Land'},
				'c/o'=>{label: 'c/o'},
				'creation_date'=>{label: 'Hinzugefügt', type:DateTimePicker, disabled: true, 
					displayFormat: function() return "d.m.Y H:i:S"}, 
				'date_of_birth'=>{label: 'Geburtsdatum', type:DatePicker, displayFormat:  function() return "d.m.Y"},
				'gender'=>{label:'Geschlecht',type:Select,options:[
						'U'=>'Unbekannt',
						'M'=>'Männlich',
						'F'=>'Weiblich'
					]
				},
				'comment'=>{label:'Kommentar'},
				'use_email'=>{label:'Post per Email',type: Checkbox},
				'id' => {type:Hidden},
				'edited_by' => {type:Hidden},
				'mandator'=>{type:Hidden},
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