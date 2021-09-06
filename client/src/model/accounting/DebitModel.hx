package model.accounting;

import haxe.ds.StringMap;
import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import data.DataState.DataColumn;
import data.DataState;
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
					"filter" => 'id'
					]
				],
			view:[
				'id' => {type:Hidden},
				'edited_by' => {type:Hidden},				
				'mandator'=>{type:Hidden},
				'zahlpfl_name'=>{type:Text},
			]
		}
	];

	public static var gridColumns:Map<String,DataColumn> = [
		'zahlpfl_name'=>{className: 'tLeft', label: 'Name', flexGrow:1},
		'vwz1'=>{label:'SpenderIn', flexGrow:0, className: 'tableNums'},
		'betrag'=>{label: 'Betrag', cellFormat: function(v=0) {
			return App.sprintf('%01.2f €',v).replace('.',',');
		},className: 'tableNums'},
		'cycle'=>{label: 'Turnus',cellFormat:function(v:String){
			var options:Map<String,String> = [
			'once'=>'Einmal','monthly'=>'Monatlich','quarterly'=>'Vierteljährlich',
			'semiannual'=>'Halbjährlich', 'annual'=>'Jährlich'];
			return options[v];
		}},
		'zahlpfl_name_kto_or_iban'=>{label:'Iban',className: 'tableNums'},				
		'id'=>{label: 'Buchungsanforderung ID', show:false},		
		//'processed'=>{label: 'Verarbeitet'},headerClassName: 'tRight'}
	];	

	public static var historyColumns:Map<String,DataColumn> = [
		'termin'=>{label:'Datum',cellFormat:function(v:String){
			if(v==null)
				return null;
			 return DateTools.format(Date.fromString(v), "%d.%m.%Y");
			}},
		'amount'=>{label: 'Betrag', cellFormat: function(v=0) {
			return App.sprintf('%01.2f €',v).replace('.',',');
		},className: 'tableNums'},
		'info'=>{label: 'Info',cellFormat: function(v='') {
			if(v=='')
				return '';
			return v;
		}}
	];	
	public static var dataGridDisplay:Map<String,data.DataState> = [
		'rDebitList' => {columns:gridColumns},
		'historyList' => {columns:historyColumns}
	];
}