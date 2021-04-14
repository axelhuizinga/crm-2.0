package model.accounting;

import haxe.ds.StringMap;
import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import view.table.Table.DataColumn;
import view.table.Table.DataState;
import view.shared.FormInputElement;

/**
 * @author axel@cunity.me
 */

class DebitModel
{
	public static var dataAccess:DataAccess = [
		'open' => {
			source:[
				"booking_requests" => [
					"filter" => 'ba_id'
					]
				],
			view:[
				'id' => {type:Hidden},
				'edited_by' => {type:Hidden},				
				'mandator'=>{type:Hidden},
				'zahlpfl_name'=>{type:Input},
			]
		}
	];

	public static var gridColumns:Map<String,view.grid.Grid.DataColumn> = [
		'zahlpfl_name'=>{label: 'Name', flexGrow:1},
		'vwz1'=>{label:'SpenderIn', flexGrow:0, className: 'tRight tableNums'},
		'betrag'=>{label: 'Betrag', cellFormat: function(v=0) {
			return App.sprintf('%01.2f €',v).replace('.',',');
		},className: 'tRight tableNums', headerClassName: 'tRight'},
		'cycle'=>{label: 'Turnus',cellFormat:function(v:String){
			var options:Map<String,String> = [
			'once'=>'Einmal','monthly'=>'Monatlich','quarterly'=>'Vierteljährlich',
			'semiannual'=>'Halbjährlich', 'annual'=>'Jährlich'];
			return options[v];
		},headerClassName: 'tRight'},
		'iban'=>{label:'Iban'},				
		'ba_id'=>{label: 'Buchungsanforderung ID'},		
		//'processed'=>{label: 'Verarbeitet'}
	];	

	public static var listColumns:Map<String,DataColumn> = [
		'id'=>{label:'VertragsID', flexGrow:0, className: 'tRight tableNums'},
		'sepa_code'=>{label:'Sepa Code', flexGrow:0, className: 'tRight'},
		'iban'=>{label:'Iban'},				
		'ba_id'=>{label: 'Buchungsanforderung ID', flexGrow:1},		
		'amount'=>{label: 'Betrag', className: 'euro', headerClassName: 'tRight'},
		//'processed'=>{label: 'Verarbeitet'}
	];	

	public static var dataDisplay:Map<String,DataState> = [
		'rDebitList' => {columns:listColumns}
	];	
	
	public static var dataGridDisplay:Map<String,view.grid.Grid.DataState> = [
		'rDebitList' => {columns:gridColumns}
	];
}