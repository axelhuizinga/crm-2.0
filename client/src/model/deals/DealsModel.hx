package model.deals;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import view.table.Table.DataColumn;
import view.table.Table.DataState;
import view.shared.FormInputElement;

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
	public static var dataAccess:DataAccess = [
		'open' => {
			source:[
				"deals" => [
					"filter" => 'id',
				//"joins" => []//Array of join parameters
					],
				],
			view:[
				
				'creation_date'=>{label:'Erstellt',type:DatePicker, displayFormat: "d.m.Y", disabled:true},
				'start_date'=>{label:'Start',type:DatePicker, displayFormat: "d.m.Y"},
				'booking_run'=>{label:'Buchungslauf',type: Radio,options: ['start'=>'Monatsanfang','middle'=>'Monatsmitte']},
				'cycle'=>{label:'Turnus',type:Radio,options:[
					'once'=>'Einmal','monthly'=>'Monatlich','quarterly'=>'Vierteljährlich',
					'semiannual'=>'Halbjährlich', 'annual'=>'Jährlich']},
				'amount'=>{label:'Betrag'},
				'produkt'=>{label:'Produkt',type:Select,options:['1'=>'Kinderhilfe','2'=>'Tierhilfe']},
				//'agent'=>{label:'Agent'},
				//'end_reason'=>{label:'Kündigungsgrund',type:DatePicker, displayFormat: "d.m.Y"},
				'end_date'=>{label:'Start',type:DatePicker, displayFormat: "d.m.Y"},				
				'repeat_date'=>{label:'Start',type:DatePicker, displayFormat: "d.m.Y"},				
				//'cycle_start_date'=>{label:'Start',type:DatePicker, displayFormat: "d.m.Y"},
				'id' => {type:Hidden},
				'edited_by' => {type:Hidden},				
				'mandator' => {type:Hidden}				
			]
		}
	];

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