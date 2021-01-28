package model.accounting;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import view.table.Table.DataColumn;
import view.table.Table.DataState;
import view.shared.FormInputElement;

/**
 * @author axel@cunity.me
 */

class AccountsModel
{
	public static var dataAccess:DataAccess = [
		'open' => {
			source:[
				"accounts" => [
					"filter" => 'id',
				//"joins" => []//Array of join parameters
					],
				],
			view:[				
				'creation_date'=>{label:'Erstellt',type:DatePicker, displayFormat: "d.m.Y", disabled:true},
				'sign_date'=>{label:'Erteilt',type:DatePicker, displayFormat: "d.m.Y"},
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

	public static var gridColumns:Map<String,view.grid.Grid.DataColumn> = [
		'id'=>{label:'ID',show:false, useAsIndex: true},				
		'account_holder'=>{
			flexGrow:1,
			label:'Inhaber',cellFormat:function(v:String) 
			{
				var n = v.split(',');
				n.reverse();
				return n.join(' ');
			}
		},	
		'sign_date'=>{label:'Erteilt',cellFormat:function(v:String) return DateTools.format(Date.fromString(v), "%d.%m.%Y")},	
		'contact'=>{label:'Kontakt',show:false, useAsIndex: false},				
		'iban'=>{label:'IBAN'},	
		'status' => {label:'Status', className: 'tCenter',
			cellFormat:function(v:String) 
			{
				var className = (v=='active'?'active fas fa-heart':'passive far fa-heart');
				//trace(uState);
				return jsx('<span className=${className}></span>');
			}}
	];

	public static var listColumns:Map<String,DataColumn> = [
		'id'=>{label:'ID',show:false, useAsIndex: true},				
		'contact'=>{label:'Kontakt',show:false, useAsIndex: false},				
		'bank_name'=>{label:'Bankname'},	
		'iban'=>{label:'IBAN'},	
		'status' => {label:'Aktiv', className: 'tCenter',
			cellFormat:function(v:String) 
			{
				var className = (v=='active'?'active fas fa-heart':'passive far fa-heart');
				//trace(uState);
				return jsx('<span className=${className}></span>');
			}}
		
	];

	public static var dataDisplay:Map<String,DataState> = [
		'accountsList' => {columns:listColumns}
	];	

	public static var dataGridDisplay:Map<String,view.grid.Grid.DataState> = [
		'accountsList' => {columns:gridColumns}
	];	
}