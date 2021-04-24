package model.accounting;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import view.table.Table.DataColumn;
import view.table.Table.DataState;
import view.shared.FormInputElement;

/**
 * @author axel@cunity.me
 */

class ReturnDebitModel
{
	public static var dataAccess:DataAccess = [
		'open' => {
			source:[
				"debit_return_statements" => [
					"filter" => 'id'
					]
				],
			view:[
				'id' => {type:Hidden},
				'edited_by' => {type:Hidden},				
				'mandator'=>{type:Hidden},
				'merged'=>{type:Hidden},
			]
		}
	];

	public static var gridColumns:Map<String,view.grid.Grid.DataColumn> = [
		'id'=>{label:'ContactID', flexGrow:0, className: 'tLeft tableNums'},
		'sepa_code'=>{label:'Sepa Code' },
		'iban'=>{label:'Iban', className: 'tableNums', flexGrow:1, headerClassName: 'tRight'},						
		'deal_id'=>{label: 'SpendenID', flexGrow:0},		
		'ba_id'=>{label: 'Buchungsanforderung ID', flexGrow:0},		
		'amount'=>{label: 'Betrag', className: 'euro', headerClassName: 'tRight'},
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