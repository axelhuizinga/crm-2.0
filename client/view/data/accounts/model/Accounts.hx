package view.data.accounts.model;

import react.ReactMacro.jsx;

import view.table.Table.DataColumn;
import view.table.Table.DataState;

/**
 * @author axel@cunity.me
 */

class Accounts
{
	public static var listColumns:Map<String,DataColumn> = [
		'first_name'=>{label:'Vorname', flexGrow:0},
		'last_name'=>{label:'Name', flexGrow:0},
		'email'=>{label:'Email'},
		'phone_number'=>{label:'Telefon', flexGrow:1},		
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
		'show' => {columns:listColumns}
	];	
}