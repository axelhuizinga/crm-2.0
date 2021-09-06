package model.accounting;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import data.DataState.DataColumn;
import data.DataState;
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
				'account_holder'=>{label:'Kontoinhaber',type:Text},
				'creation_date'=>{label:'Erstellt',type:Hidden, displayFormat: "d.m.Y", disabled:true},
				'sign_date'=>{label:'Erteilt',type:DatePicker, displayFormat: "d.m.Y"},
				'bank_name'=>{label:'Bank',type:Text},
				'iban'=>{label:'IBAN',type:Text,className: 'tableNums'},
				'status'=>{label:'Status', type:Select,options: ['active'=>'Aktiv','passive'=>'Passiv','new'=>'Neu']},
				'id' => {type:Hidden},
				'edited_by' => {type:Hidden},				
				'mandator' => {type:Hidden}				
			]
		}
	];

	public static var gridColumns:Map<String,DataColumn> = [
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
		'contact'=>{label:'ID',className: 'tableNums'},	
		'sign_date'=>{label:'Erteilt',cellFormat:function(v:String) return v!=null? DateTools.format(Date.fromString(v), "%d.%m.%Y"):''},
		'iban'=>{label:'IBAN',className: 'tableNums'},	
		'status' => {label:'Status', className: 'tCenter',
			cellFormat:function(v:String) 
			{
				var className = (v=='active'?'active fas fa-user':'passive far fa-user');
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
				var className = (v=='active'?'active fas fa-user':'passive far fa-user');
				//trace(uState);
				return jsx('<span className=${className}></span>');
			}}
		
	];

	public static var dataDisplay:Map<String,DataState> = [
		'accountsList' => {columns:listColumns}
	];	

	public static var dataGridDisplay:Map<String,data.DataState> = [
		'accountsList' => {columns:gridColumns}
	];	
}