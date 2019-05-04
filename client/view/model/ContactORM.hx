package view.model;

import react.ReactMacro.jsx;

import view.table.Table.DataColumn;
import view.table.Table.DataState;

/**
 * @author axel@cunity.me
 */


class ContactORM
{
	public static var contactListColumns:Map<String,DataColumn> = [
		'first_name'=>{label:'Vorname', flexGrow:0},
		'last_name'=>{label:'Name', flexGrow:0},
		'email'=>{label:'Email'},
		'phone_number'=>{label:'Telefon', flexGrow:1},		
		'state' => {label:'Aktiv', className: 'tCenter',
			cellFormat:function(v:String) 
			{
				var uState = (v=='active'?'user':'user-slash');
				//trace(uState);
				return jsx('<span className="fa fa-$uState"></span>');
			}},
		'id' => {show:false}
	];
	/*dataDisplay = [
			'contactList' => {columns:[
				'first_name'=>{label:'Vorname', flexGrow:0},
				'last_name'=>{label:'Name', flexGrow:0},
				'email'=>{label:'Email'},
				'phone_number'=>{label:'Telefon', flexGrow:1},		
				'state' => {label:'Aktiv', className:'cRight', 
					cellFormat:function(v:String) return (v=='active'?'J':'N')},
				'id' => {show:false}
			]},
			'dealList' => {columns: [
				'user_group' => {label:'UserGroup', flexGrow:0},
				'group_name'=>{label:'Beschreibung', flexGrow:1},
				'allowed_campaigns'=>{label:'Kampagnen',flexGrow:1}
			]}
		];*/
	public static var dataDisplay:Map<String,DataState> = [
		'contactList' => {columns:contactListColumns},
		'dealList' => {columns: [
			'user_group' => {label:'UserGroup', flexGrow:0},
			'group_name'=>{label:'Beschreibung', flexGrow:1},
			'allowed_campaigns'=>{label:'Kampagnen',flexGrow:1}
		]}
	];	
}