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

	/*public static var listColumns:Map<String,DataColumn> = [
		'id'=>{
			cellFormat:function(v) {
				return Std.parseInt(v);
			},
			show:false,
			useAsIndex: true
		},
		'dealId'=>{label:'VertragsID', flexGrow:0, className: 'tRight'},
		//"baID":"baID 800426553","iban":"DE48150505001233003557","sepaCode":"AC04","mID":"11021389T1","amount":"-65.50"
		'sepaCode'=>{label:'Sepa Code', flexGrow:0, className: 'tRight'},
		'iban'=>{label:'Iban'},				
		'baID'=>{label: 'Buchungsanforderung ID', flexGrow:1},		
		'amount'=>{label: 'Betrag', className: 'euro', headerClassName: 'tRight'}
	];*/
	public static var listColumns:Map<String,DataColumn> = [
		/*'id'=>{
			cellFormat:function(v) {
				return Std.parseInt(v);
			},
			show:false,
			useAsIndex: true
		},*/
		'id'=>{label:'VertragsID', flexGrow:0, className: 'tRight'},
		//"baID":"baID 800426553","iban":"DE48150505001233003557","sepaCode":"AC04","mID":"11021389T1","amount":"-65.50"
		'reason'=>{label:'Sepa Code', flexGrow:0, className: 'tRight'},
		'iban'=>{label:'Iban'},				
		'ba_id'=>{label: 'Buchungsanforderung ID', flexGrow:1},		
		'amount'=>{label: 'Betrag', className: 'euro', headerClassName: 'tRight'},
		'processed'=>{label: 'Verarbeited'}
	];	

	public static var dataDisplay:Map<String,DataState> = [
		'rDebitList' => {columns:listColumns}
	];	
	//public static var propertyNames = 'reason,iban,ba_id,amount,mandator,last_modified,processed'.split(',');

}