package model.imports;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import view.table.Table.DataColumn;
import view.table.Table.DataState;
import view.shared.FormInputElement;

/**
 * @author axel@cunity.me
 */

class ReDebitModel
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
				'co_field'=>{label: 'Adresszusatz'},
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

	public static var listColumns:Map<String,DataColumn> = [
		//"baID":"baID 800426553","iban":"DE48150505001233003557","sepaCode":"AC04","mID":"11021389T1","amount":"-65.50"
		'id'=>{label:'VertragsID', flexGrow:0},
		'sepaCode'=>{label:'Sepa Code', flexGrow:0},
		'iban'=>{label:'Iban'},				
		'baID'=>{label: 'Buchungsanforderung ID', flexGrow:1},		
		'amount'=>{label: 'Betrag'}
	];

	public static var dataDisplay:Map<String,DataState> = [
		'rDebitList' => {columns:listColumns}
	];	
}