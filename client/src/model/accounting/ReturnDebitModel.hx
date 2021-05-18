package model.accounting;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import data.DataState.DataColumn;
import data.DataState;
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

	/**
	 * Array<Map TableName => Map<String,DataColumn>>
	 */
	 static var joins:Array<DataJoin> = [{
		alias: 'br',
		columns: [
			'ag_name'=>{label:'Name', flexGrow:0, className: 'tLeft'},
			//'id'=>{label:'KontaktID', flexGrow:0, className: 'tLeft tableNums'},
			'value_date'=>{label: 'Wertstellung',cellFormat:function(v:Dynamic){
				if(v==null)
					return null;
				trace(v);
				return DateTools.format(Date.fromString(v), "%d.%m.%Y");
			}},
			'sepa_code'=>{label:'Sepa Code' },
			/*'ag_konto_or_iban'=>{
				alias:'iban', label:'Iban', className: 'tableNums', flexGrow:1, headerClassName: 'tRight'
			},*/						
			'deal_id'=>{label: 'SpendenID', className: 'tableNums'},		
			'ba_id'=>{label: 'Buchungsanforderung ID', className: 'tableNums'},		
			'amount'=>{label: 'Betrag', className: 'euro', headerClassName: 'tRight'},
			//'processed'=>{label: 'Verarbeitet'}		
		],	 
		table: 'booking_requests'
	 }];

	public static var base:Map<String,DataColumn> = [
		'ag_name'=>{label:'Name', flexGrow:0, className: 'tLeft'},
		//'id'=>{label:'KontaktID', flexGrow:0, className: 'tLeft tableNums'},
		'value_date'=>{label: 'Wertstellung',cellFormat:function(v:Dynamic){
			if(v==null)
				return null;
			trace(v);
			 return DateTools.format(Date.fromString(v), "%d.%m.%Y");
		}},
		'sepa_code'=>{label:'Sepa Code' },
		'iban'=>{label:'Iban', className: 'tableNums', flexGrow:1, headerClassName: 'tRight'},						
		'deal_id'=>{label: 'SpendenID', className: 'tableNums'},		
		'ba_id'=>{label: 'Buchungsanforderung ID', className: 'tableNums'},		
		'amount'=>{label: 'Betrag', className: 'euro', headerClassName: 'tRight'},
		//'processed'=>{label: 'Verarbeitet'}
	];

	public static var gridColumns:Map<String,DataColumn> = [
		'ag_name'=>{label:'Name', flexGrow:0, className: 'tLeft'},
		//'id'=>{label:'KontaktID', flexGrow:0, className: 'tLeft tableNums'},
		'value_date'=>{label: 'Wertstellung',cellFormat:function(v:Dynamic){
			if(v==null)
				return null;
			trace(v);
			 return DateTools.format(Date.fromString(v), "%d.%m.%Y");
		}},
		'sepa_code'=>{label:'Sepa Code' },
		'iban'=>{label:'Iban', className: 'tableNums', flexGrow:1, headerClassName: 'tRight'},						
		'deal_id'=>{label: 'SpendenID', className: 'tableNums'},		
		'ba_id'=>{label: 'Buchungsanforderung ID', className: 'tableNums'},		
		'amount'=>{label: 'Betrag', className: 'euro', headerClassName: 'tRight'},
		//'processed'=>{label: 'Verarbeitet'}
	];	

	public static var listColumns:Map<String,DataColumn> = [
		'id'=>{label:'VertragsID', flexGrow:0, className: 'tRight tableNums'},
		'value_date'=>{label: 'Wertstellung',cellFormat:function(v:String){
			if(v==null)
				return null;
			 return DateTools.format(Date.fromString(v), "%d.%m.%Y");
			}},
		'sepa_code'=>{label:'Sepa Code', flexGrow:0, className: 'tRight'},
		'iban'=>{label:'Iban'},				
		'ba_id'=>{label: 'Buchungsanforderung ID', flexGrow:1},		
		'amount'=>{label: 'Betrag', className: 'euro', headerClassName: 'tRight'},
		//'processed'=>{label: 'Verarbeitet'}
	];	

	public static var dataDisplay:Map<String,DataState> = [
		'rDebitList' => {columns:listColumns}
	];	
	
	public static var dataGridDisplay:Map<String,DataState> = [
		'rDebitList' => {columns:gridColumns},
		'rDebitData' => {
			columns:base, 
			joins:joins,
			table:'debit_return_statements',
			tableAlias:'drs'
		}
	];
}