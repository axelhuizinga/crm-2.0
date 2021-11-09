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
				'status'=>{label:'Status',type:Select,options:[
					'active'=>'Aktiv','passive'=>'Passiv','blocked'=>'Gesperrt']},
				
				'title_pro'=>{label:'Titel'},
				'phone_number'=>{label:'Telefon'},		
				'first_name'=>{label:'Vorname'},
				'mobile'=>{label:'Mobil'},
				'last_name'=>{label:'Name'},
				'company_name'=>{label:'Firmenname'},	
				'address1'=>{label:'Straße'},
				'care_of'=>{label: 'C/O'},
				'address2'=>{label:'Hausnummer'},
				'email'=>{label:'Email'},
				//'phone_code'=>{label:'Landesvorwahl', type:Hidden},
				//'fax'=>{label:'Fax', type:Hidden},
				'postal_code'=>{label:'PLZ'},
				'date_of_birth'=>{label: 'Geburtsdatum', type:DatePicker, displayFormat: "d.m.Y"},
				'city'=>{label:'Ort'},
				//'country_code'=>{label:'Land'},
				'creation_date'=>{label: 'Hinzugefügt', type:DateTimePicker, disabled: true, 
					displayFormat: "d.m.Y H:i:S"}, 
				/*'gender'=>{label:'Geschlecht',type:Select,options:[
						''=>'?',
						'M'=>'Männlich',
						'F'=>'Weiblich'
					]
				},*/
				'use_email'=>{label:'Post per Email',type: Checkbox},
				'11r'=>{type:Box},
				'comments'=>{className:'big_comment',label:'Kommentar', type:TextArea},
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
		//'care_of'=>{label: 'c/o', flexGrow:1, showSearch:false},
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
		'address1'=>{label: 'Straße', showSearch:false},		
		'address2'=>{label: 'Nr.', showSearch:false},		
		'care_of'=>{label: 'c/o', flexGrow:1, showSearch:false},
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
		'address1'=>{label: 'Straße'},		
		'address2'=>{label: 'Hausnummer'},		
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

	public static var dataGridDisplay:Map<String,DataState> = [
		'contactList' => {columns:gridColumns}
	];	

	public static var qcListDisplay:Map<String,DataState> = [
		'qcList' => {columns:qcColumns}
	];	
}