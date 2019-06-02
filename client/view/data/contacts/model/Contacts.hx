package view.data.contacts.model;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import view.table.Table.DataColumn;
import view.table.Table.DataState;

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