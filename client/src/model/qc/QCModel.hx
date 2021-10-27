package model.qc;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import data.DataState.DataColumn;
import data.DataState;
import view.shared.FormInputElement;

/**
 * @author axel@cunity.me
 */

class QCModel
{
	public static var dataAccess:DataAccess = [
		'open' => {
			source:[
				"contacts" => [
					"filter" => 'id'
					]
				],
			view:[
				'anrede'=>{label:'Anrede',type:Select,options:[
						''=>'?',
						'Herr'=>'Herr',
						'Frau'=>'Frau',
						'Familie'=>'Familie',
						'Firma'=>'Firma'
					]},'phone_number'=>{label:'Telefon'},
				
				'title'=>{label:'Titel'},'mobile'=>{label:'Mobil'},
				
				'first_name'=>{label:'Vorname'},'company_name'=>{label:'Firmenname'},				

				'last_name'=>{label:'Name'},'co_field'=>{label: 'C/O'},
				'address1'=>{label:'Straße'},'email'=>{label:'Email'},
				'address2'=>{label:'Hausnummer'},'geburts_datum'=>{label: 'Geburtsdatum', type:DatePicker, displayFormat: "d.m.Y"},
				'postal_code'=>{label:'PLZ'},
				
				//'use_email'=>{label:'Post per Email',type: Checkbox},'Adresszusatz'
				//'phone_code'=>{label:'Landesvorwahl'},		
				
				//'fax'=>{label:'Fax'},
				
				
				//'state'=>{label:'Status',type:Select,options:['active'=>'Aktiv','passive'=>'Passiv','blocked'=>'Gesperrt']},				
				'country_code'=>{type:Hidden, disabled: true, label:'Land'},
				'creation_date'=>{label: 'Hinzugefügt', type:Hidden, disabled: true, 
					displayFormat: "d.m.Y H:i:S"}, 
				
				/*'gender'=>{label:'Geschlecht',type:Select,options:[
						''=>'?',
						'M'=>'Männlich',
						'F'=>'Weiblich'
					]
				},*/
				'owner' =>{label:'Agent', cellFormat: function(v):String {
						trace('App.pbxUserData ${App.pbxUserData!=null}');
						if(App.pbxUserData!=null)
						trace(' && exists($v): ${App.pbxUserData.exists(v)}');
						if(App.pbxUserData!=null && App.pbxUserData.exists(v))
							return App.pbxUserData.get(v)['full_name'];
						return v;
					},
					disabled: false, type:Select,
					options:[
						''=>'?'
					],
				},
				'city'=>{label:'Ort'},
				'comments'=>{className:'big_comment',label:'Kommentar', type:TextArea},
				'period'=>{label:'Zahlweise',type:Radio,options:[
					'Monatlich' => 'Mtl.', 
					'Vierteljährlich' => 'Vtl.',
					'Halbjährlich' => 'Halbj.', 
					'Jährlich' => 'Jährl.',
					'Einmalspende' => '1x'
				]},	
				'mailing'=>{label:'Info',type: Radio,options: [
					'info_brief' => 'Brief',
					'info_mail' => 'EMail',
					'no_info' => 'Keine'
				]},
				'start_monat'=>{label:'Ab', type:Select,options:[
					'Januar' => 'Januar',
					'Februar' => 'Februar',
					'März' => 'März',
					'April' => 'April',
					'Mai' => 'Mai',
					'Juni' => 'Juni',

						'Juli' => 'Juli',
					'August' => 'August',
					'September' => 'September',
					'Oktober' => 'Oktober',
					'November' => 'November',
					'Dezember' => 'Dezember'
				]},
				'buchungs_tag'=>{label:'Buchungstag'},
				'buchungs_zeitpunkt'=>{label:'Buchung zum 1. oder 15. ',type:Radio,options:[
					'1'=>'Monatsanfang',
					'15'=>'Monatsmitte'
				]},
				'account'=>{label:'Kontonummer'},
				'spenden_hoehe'=>{label:'Betrag'},
				'blz'=>{label:'Bankleitzahl (BLZ)'},
				'entry_date'=>{label: 'Verkauf', type:DatePicker, displayFormat: "d.m.Y"/*cellFormat: function(v:String) {
					//trace(v);
					return v!=null? DateTools.format(Date.fromString(v), "%d.%m.%Y"):'';
					//return v;
					}*/
				},				
				'iban'=>{label:'IBAN'},
				'18_l'=>{type:Box},
				'bank_name'=>{label:'Bankinstitut'},

				'edited_by' => {type:Hidden},				
				'id' => {type:Hidden},
				'mandator'=>{type:Hidden},
				'merged'=>{type:Hidden},
			]
		}
	];//lead_id|period|anrede|account|blz|iban|bank_name|spenden_hoehe|start_monat|buchungs_tag|buchungs_zeitpunkt|mailing|client_status
	
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
		'last_local_call_time'=>{label: 'Datum',cellFormat: function(v:String) {
				trace(v);
				return v!=null? DateTools.format(Date.fromString(v), "%d.%m.%Y"):'';
			}
		},
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
				trace(v);
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