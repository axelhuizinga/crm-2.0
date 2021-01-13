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
				'amount'=>{label:'Betrag', type:NFormat},
				'produkt'=>{label:'Produkt',type:Select,options:['1'=>'Kinderhilfe','2'=>'Tierhilfe']},
				//'agent'=>{label:'Agent'},
				//'end_reason'=>{label:'Kündigungsgrund',type:DatePicker, displayFormat: "d.m.Y"},
				'end_date'=>{label:'Beendet zum',type:DatePicker, displayFormat: "d.m.Y"},				
				//'repeat_date'=>{label:'Zahlun',type:DatePicker, displayFormat: "d.m.Y"},				
				//'cycle_start_date'=>{label:'Start',type:DatePicker, displayFormat: "d.m.Y"},
				'id' => {type:Hidden},
				'edited_by' => {type:Hidden},				
				'mandator' => {type:Hidden}				
			]
		}
	];

	public static var listColumns:Map<String,DataColumn> = [
		'id'=>{label:'ID',show:false},				
		'start_date'=>{label:'Seit'},	
		'end_date'=>{label:'Bis'},	
		'active' => {label:'Aktiv', className: 'tCenter',
			cellFormat:function(v:Bool) 
			{
				var className = (v?'active fas fa-heart':'passive far fa-heart');
				trace('>>>$v<<<');
				return jsx('<span className=${className}></span>');
			}},
		'cycle' => {label: 'Turnus'},
		'amount' => {label: 'Betrag'},
		
	];

	public static var dataDisplay:Map<String,DataState> = [
		'dealsList' => {columns:listColumns}
	];	
}