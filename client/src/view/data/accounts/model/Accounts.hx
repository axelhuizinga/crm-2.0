package view.data.accounts.model;

import react.ReactMacro.jsx;

import data.DataState.DataColumn;
import data.DataState;

/**
 * @author axel@cunity.me
 */

class Accounts
{
	public static var listColumns:Map<String,DataColumn> = [
		'contact'=>{label:'Kontakt',show:false},
		'account_holder'=>{label:'Kontoinhaber', flexGrow:1},
		'bank_name'=>{label:'Bankname', flexGrow:1},
		'blz'=>{label:'BLZ'},		
		'iban'=>{label:'IBAN'},				
		'sign_date' => {label:'Erteilt am', className: 'tCenter'},
		'status' => {label:'Aktiv', className: 'tCenter',		
			cellFormat:function(v:String) 
			{
				var aState = (v=='active'?'fa-user':'passive fa-user');
				//trace(uState);
				return jsx('<span className="fa $aState"></span>');
			}},
		'id' => {show:false}
	];

	public static var dataDisplay:Map<String,DataState> = [
		'accountsList' => {columns:listColumns}
	];	
}