package model.contacts;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import data.DataState.DataColumn;
import data.DataState;
import view.shared.FormInputElement;

/**
 * @author axel@cunity.me
 */

class ContactsModel
{
	public static var dataAccess:DataAccess = [
		'open' => {
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
				'address'=>{label:'Straße'},
				'address_2'=>{label:'Hausnummer'},
				'postal_code'=>{label:'PLZ'},
				'city'=>{label:'Ort'},
				'state'=>{label:'Status',type:Select,options:['active'=>'Aktiv','passive'=>'Passiv','blocked'=>'Gesperrt']},
				'country_code'=>{label:'Land'},
				'care_of'=>{label: 'Adresszusatz'},
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
				'merged'=>{type:Hidden},
			]
		}
	];
	
	public static var qcColumns:Map<String,DataColumn> = [
		'first_name'=>{label:'Vorname', flexGrow:0},
		'last_name'=>{label:'Name', flexGrow:0},
		//'email'=>{label:'Email'},
		'phone_number'=>{label:'Telefon'},				
		'address1'=>{label: 'Straße', showSearch:false},		
		'address2'=>{label: 'Nr.', showSearch:false},		
		//'care_of'=>{label: 'Adresszusatz', flexGrow:1, showSearch:false},
		'postal_code'=>{label: 'PLZ'},
		'city'=>{label: 'Ort'},
		'id' => {label:'Kontakt ID',show:false},
		'list_id' => {show:false},
		'entry_list_id' => {show:false},
		'lead_id' => {show:false},
		'last_local_call_time'=>{label: 'Datum',cellFormat: function(v:String) return v!=null? DateTools.format(Date.fromString(v), "%d.%m.%Y"):''},
	];

	public static var gridColumns:Map<String,DataColumn> = [
		'first_name'=>{label:'Vorname', flexGrow:0},
		'last_name'=>{label:'Name', flexGrow:0},
		//'email'=>{label:'Email'},
		'phone_number'=>{label:'Telefon'},				
		'address'=>{label: 'Straße', showSearch:false},		
		'address_2'=>{label: 'Nr.', showSearch:false},		
		'care_of'=>{label: 'Adresszusatz', flexGrow:1, showSearch:false},
		'postal_code'=>{label: 'PLZ'},
		'city'=>{label: 'Ort'},
		'status' => {label:'Status', className: 'tCenter',
			cellFormat:function(v:String) 
			{
				var uState = (v=='active'?'user':'user-slash');
				//trace(uState);
				return jsx('<span className="fa fa-$uState"></span>');
			}},
		'id' => {label:'Kontakt ID',show:true}
	];
	
	public static var listColumns:Map<String,DataColumn> = [
		'first_name'=>{label:'Vorname', flexGrow:0},
		'last_name'=>{label:'Name', flexGrow:0},
		//'email'=>{label:'Email'},
		'phone_number'=>{label:'Telefon'},				
		'address'=>{label: 'Straße'},		
		'address_2'=>{label: 'Hausnummer'},		
		'care_of'=>{label: 'Adresszusatz', flexGrow:1},
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

	public static var dataGridDisplay:Map<String,DataState> = [
		'contactList' => {columns:gridColumns}
	];	

	public static var qcListDisplay:Map<String,DataState> = [
		'contactList' => {columns:qcColumns}
	];	
}