package view.dashboard.model;

/**
 * ...
 * @author axel@cunity.me
 */

import view.table.Table.DataColumn;
import view.table.Table.DataState;

class DBSyncModel 
{
	public static var formatBool = function(v:Dynamic) {return (v?'Y':'N'); }
	public static var formatElementSelection = function(v:Dynamic) {return (v?'Y':'N'); }
    static var formatPhone = function(p:Dynamic){trace(p);return (p?p.login:'');};
	public static var clientListColumns:Map<String,DataColumn> =  [
		'client_id'=>{label: 'ID', show:true},
		'first_name'=>{label:'Vorname',editable:true},
		'last_name'=>{label:'Name',editable:true},
		'phone'=>{label: 'Telefon'}
	];
	public static var userListColumns:Map<String,DataColumn> =  [
		'user_id'=>{label: 'ID', show:true},
		'user'=>{label:'User',editable:false},
		'full_name'=>{label:'Name',editable:true, flexGrow:1},
		//'phone_data'=>{label:'Nebenstelle', editable: true, cellFormat:formatPhone, className: 'tRight'},
		'phone_login'=>{label:'Nebenstelle', editable: true, className: 'tRight'},
        'user_group'=>{label:'Gruppe', editable: true}
		//'any'=>{label:'Eigenschaften', flexGrow:1},
	];
	
	//public static function dataDisplay(?parentForm:DataAccessForm):StringMap<DataState> 
	public static var dataDisplay:Map<String,DataState> =
	[
		'userList' => {altGroupPos:0,columns:userListColumns},
		'clientList' => {altGroupPos:0,columns:clientListColumns}
	];
	
}
