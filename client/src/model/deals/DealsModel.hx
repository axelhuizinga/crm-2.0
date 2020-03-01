package model.deals;

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
		'contact'=>{show:false, usAsIndex: true},		
		'first_name'=>{show: false, useInTooltip: 0},
		'last_name'=>{show: false, useInTooltip: 1},
		'start_date'=>{label:'Seit'},		
		'state' => {label:'Aktiv', className: 'tCenter',
			cellFormat:function(v:String) 
			{
				var uState = (v=='active'?'thumbs-up':'thumbs-down');
				//trace(uState);
				return jsx('<span className="far fa-$uState"></span>');
			}},
		'id' => {show:false},
		
	];

	public static var dataDisplay:Map<String,DataState> = [
		'dealsList' => {columns:listColumns}
	];	
}