package model.deals;

import tink.CoreApi.Callback;
import react.ReactMacro.jsx;

import view.table.Table.DataColumn;
import view.table.Table.DataState;

/**
 * @author axel@cunity.me
 */

class DealsModel
{
	/**
	 * 	?id:Int,
	?contact:Int,
	?creation_date:String,
	?account:Int,
	?target_account:Int,
	?start_day:String,
	?start_date:String,
	?cycle:String,
	?amount:String,
	?product:Int,
	?agent:Int,
	?project:Int,
	?status:String,
	?pay_method:String,
	?end_date:String,
	?end_reason:Int,
	?repeat_date:String,
	?edited_by:Int,
	?mandator:Int,
	?old_active:Bool,
	?cycle_start_date:String,
	?last_locktime:String
	 */
	public static var listColumns:Map<String,DataColumn> = [
		'contact'=>{label:'Kontakt',show:true, useAsIndex: true},		
		'start_date'=>{label:'Seit'},		
		'status' => {label:'Aktiv', className: 'tCenter',
			cellFormat:function(v:String) 
			{
				var className = (v=='active'?'active fas fa-heart':'passive far fa-heart');
				//trace(uState);
				return jsx('<span className=${className}></span>');
			}},
		'cycle' => {label: 'Turnus'},
		'amount' => {label: 'Betrag'},
		'id' => {show:false},
		
	];

	public static var dataDisplay:Map<String,DataState> = [
		'dealsList' => {columns:listColumns}
	];	
}