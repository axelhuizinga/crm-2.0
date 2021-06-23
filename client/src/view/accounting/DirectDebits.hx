package view.accounting;

import view.shared.MItem;
import model.accounting.DebitModel;
import loader.AjaxLoader;
import action.async.UserAccess;
import haxe.Serializer;
import haxe.ds.StringMap;
import state.AppState;
import react.ReactComponent.ReactFragment;
import react.ReactComponent;
import shared.DbData;

import loader.BinaryLoader;
import data.DataState;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import react.ReactType;
import redux.Redux.Dispatch;
import view.accounting.directdebit.Edit;
import view.accounting.directdebit.List;
import view.shared.io.DataFormProps;
import view.shared.io.FormApi;
import state.FormState;
import view.shared.Menu;
import view.shared.MenuProps;
using Lambda;
/**
 * ...
 * @author axel@cunity.me
 */

@:connect
class DirectDebits extends ReactComponentOf<DataFormProps,FormState>
{			
	static var _instance:DirectDebits;
	var _trace:Bool;

	var dataDisplay:Map<String,DataState>;
	var formApi:FormApi;
	var fieldNames:Array<String>;
	var dbData: shared.DbData;
	var dbMetaData:shared.DBMetaData;

	public function new(?props:DataFormProps) 
	{
		super(props);
		//dataDisplay = RolesFormModel.dataDisplay;	
		if(props.match.params.section==null)
		{
			//SET DEFAULT SECTION
			var baseUrl:String = props.match.path.split(':section')[0];			
			trace('pushing2: ${baseUrl}Edit');
			props.history.push('${baseUrl}Edit');
			}		
		state =  App.initEState({
			loading:false,
			sideMenu:FormApi.initSideMenuMulti( this,
				[	
					{
						dataClassPath:'data.DirectDebits',
						label:'Gesamtliste',
						section: 'List',
						items:List.menuItems
					},
					{
						dataClassPath:'data.DirectDebits',
						hasFindForm:false,
						label:'Bearbeiten',
						section: 'Edit',
						items: Edit.menuItems
					}
				],				
				{	
					section: props.match.params.section==null? 'Edit':props.match.params.section, 
					sameWidth: true
				})
		},this);	
		
		trace(Reflect.fields(props));
	}
	
	static function mapStateToProps(aState:AppState) {
		return function(aState:AppState) 
		{
			var uState = aState.userState;
			//trace(uState);		
			return {
				userState:uState
			};
		};
	}	
	
	override public function componentDidMount():Void 
	{	
		trace(props.match.params.action);
		state.formApi.doAction();
	}	
	
	override public function render() 
		{
			trace(props.match.params.section);
			//trace(state.sideMenu); sideMenu=${state.sideMenu}
			return switch(props.match.params.section)
			{
				case "Edit":
					jsx('
						<$Edit ${...props} fullWidth={true} parentComponent=${this}/>
					');					
				case "List":
					jsx('
						<$List ${...props}  limit=${100} fullWidth={true} sideMenu=${state.sideMenu}/>
					');				
				default:
					null;				
			}
		}
	
}