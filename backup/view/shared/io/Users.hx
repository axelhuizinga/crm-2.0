package view.shared.io;

import js.html.Event;
import react.ReactMacro.jsx;
import react.ReactComponent;

import view.shared.io.DataFormProps;
import view.shared.SMItem;
import view.table.Table;
import view.table.Table.DataState;

class Users extends ReactComponentOf<DataFormProps,FormState>
{
    public static var menuItems:Array<SMItem> = [
		{label:'Liste',action:'show'},
		{label:'Neu',action:'create'},
		{label:'Bearbeiten',action:'edit'},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'}
	];
    	
	var dataDisplay:Map<String,DataState>;
	var dataAccess:DataAccess;

    public function new(props:DataFormProps)
	{
		super(props);
       /* _menuItems = menuItems.map(function (mI:SMItem){
			var h:Event->Void = Reflect.field(this, mI.action);
			trace(h);
			mI.handler = h;
			switch(mI.action)
			{
				case 'editTableFields':
					mI.disabled = state.selectedRows.length==0;
				case 'save':
					mI.disabled = state.clean;
				default:

			}
			return mI;

		});*/
		//this.state = state;
		//super(props, state);
		//trace(props);
		trace(this.props);
	}
	
	override function render()
	{
		return jsx('<div />');
	}

	function renderResults()
	{
		if (state.dataTable != null)
		return switch(props.match.params.action)
		{
			case "userList":
				jsx('
					<$Table id="userList" data=${state.dataTable == null? null:state.dataTable}
					${...props} dataState = ${dataDisplay["userList"]} 
					className = "is-striped is-hoverable" fullWidth={true}/>				
				');	
			default:
				null;
		}
		return null;
	}
}
