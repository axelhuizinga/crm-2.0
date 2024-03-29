package model.stats;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import data.DataState.DataColumn;
import data.DataState;
import view.shared.FormInputElement;

/**
 * @author axel@cunity.me
 */

class HistoryModel
{
	public static var dataAccess:DataAccess = [
		'update' => {
			source:[
				"contacts" => [
					"filter" => 'id'
					]
				],
			view:[
				'title'=>{label:'Anrede',type:Select,options:[
						''=>'?',
						'Herr'=>'Herr',
						'Frau'=>'Frau',
						'Familie'=>'Familie',
						'Firma'=>'Firma'
					]},
				'title_pro'=>{label:'Titel'},
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
				'postal_code'=>{label:'PLZ'},
				'city'=>{label:'Ort'},
				'state'=>{label:'Status',type:Select,options:['active'=>'Aktiv','passive'=>'Passiv','blocked'=>'Gesperrt']},
				'country_code'=>{label:'Land'},
				'care_of'=>{label: 'c/o'},
				'creation_date'=>{label: 'Hinzugefügt', type:DateTimePicker, disabled: true, 
					displayFormat: "d.m.Y H:i:S"}, 
				'date_of_birth'=>{label: 'Geburtsdatum', type:DatePicker, displayFormat: "d.m.Y"},
				'gender'=>{label:'Geschlecht',type:Select,options:[
						''=>'?',
						'M'=>'Männlich',
						'F'=>'Weiblich'
					]
				},
				'comments'=>{label:'Kommentar'},
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
		'address'=>{label: 'Straße'},		
		'address_2'=>{label: 'Hausnummer'},		
		'care_of'=>{label: 'c/o', flexGrow:1},
		'postal_code'=>{label: 'PLZ'},
		'city'=>{label: 'Ort'},
		'state' => {label:'Status', className: 'tCenter',
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