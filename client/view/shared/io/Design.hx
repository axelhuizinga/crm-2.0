package view.shared.io;

import js.html.Event;
import haxe.ds.StringMap;
import model.AjaxLoader;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import view.shared.FormState;
import view.shared.SMenu;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess.DataSource;

/**
 * ...
 * @author axel@cunity.me
 */



class Design extends ReactComponentOf<DataFormProps,FormState>
{
	
	public static var menuItems:Array<SMItem> = [
		{label:'Neu',action:'create'},
		{label:'Bearbeiten',action:'edit'},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'}
	];
	
	public function edit(ev:ReactEvent):Void
	{
		trace('hi :)');
		props.formApi.requests.push(AjaxLoader.load(	
			'${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
				className:'auth.User',
				action:'edit',
				filter:'user_name|${props.user.user_name}',
				//dataSource:Serializer.run(view.shared.io.User.userModel)
			},
			function(data:Dynamic )
			{
				if (data.rows == null)
					return;
				trace(data.rows.length);
				var dataRows:Array<Dynamic> = data.rows;
				trace(Reflect.fields(dataRows[0]));
				trace(dataRows[0].active);
				setState({data:['accountData'=>dataRows], loading:false});					
			}
		));
		setState({dataClassPath:"auth.User.edit"});
	}
	
	public function new(props:DataFormProps)
	{
		super(props);		
		//menuItems = [{handler:edit, label:'Bearbeiten', section:'edit'}];
		//sideMenu.menuBlocks['bookmarks'].items = function() return _menuItems;
		//trace(sideMenu.menuBlocks['bookmarks'].items());
		state = {
			clean:true,
			hasError:false,
			mounted:false,
			loading:true,
			sideMenu:{}, 
		};
		/*_menuItems = menuItems.map(function (mI:SMItem){
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
	
}