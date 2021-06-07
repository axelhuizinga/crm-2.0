package view.shared.io;

import js.html.Event;
import haxe.ds.StringMap;
import loader.AjaxLoader;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import state.FormState;
import view.shared.Menu;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess.DataSource;

/**
 * ...
 * @author axel@cunity.me
 */

class Design extends ReactComponentOf<DataFormProps,FormState>
{
	
	public static var menuItems:Array<MItem> = [
		{label:'Neu',action:'insert'},
		{label:'Bearbeiten',action:'update'},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'}
	];
	
	public function edit(ev:ReactEvent):Void
	{
		trace('hi :)');
		props.formApi.requests.push(AjaxLoader.load(	
			'${App.config.api}', 
			{
				id:props.userState.dbUser.id,
				jwt:props.userState.dbUser.jwt,
				classPath:'auth.User',
				action:'update',
				filter:'id|${props.userState.dbUser.id}',
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

		state = {
			clean:true,
			hasError:false,
			mounted:false,
			loading:true,
			sideMenu:{}, 
		};

		trace(this.props);
	}
	
	override function render()
	{
		return jsx('<div />');
	}
	
}