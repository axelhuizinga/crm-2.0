package model.deals;

import react.ReactMacro.jsx;
import view.shared.io.DataAccess;
import data.DataState.DataColumn;
import data.DataState;
import view.shared.FormInputElement;

using StringTools;
/**
 * @author axel@cunity.me
 */

class DealsModel
{
	static var _initialized:Bool = false;

	public static var dataAccess:DataAccess = [
		'open' => {
			gridCSSClass:'sub_grid_box',
			source:[
				"deals" => [
					"filter" => 'id',
					"title" => 'id'
					],
				],
			view:[				
				'creation_date'=>{label:'Erstellt',type:DatePicker, displayFormat: "d.m.Y", disabled:true},
				'start_date'=>{label:'Start',type:DatePicker, displayFormat: "d.m.Y"},
				'booking_run'=>{label:'Buchungslauf',type: Radio,options: ['start'=>'Monatsanfang','middle'=>'Monatsmitte']},
				'cycle'=>{label:'Turnus',type:Radio,options:[
					'once'=>'Einmal','monthly'=>'Mtl.','quarterly'=>'Vtl.',
					'semiannual'=>'Halbj.', 'annual'=>'Jährl.'
				]},					
				'amount'=>{label:'Betrag', type:NFormat,
					className:'euro',
					/*cellFormat: function(v) {
						trace(v);
						return App.sprintf('%01.2f €',v).replace('.',',');
					}*/
				},
				//'amount'=>{label:'Betrag', className:'euro',
				/*cellFormat: function(v) {
					trace(v);
					return App.sprintf('%01.2f €',v).replace('.',',');
				},*/
				//type:Text},
				'product'=>{label:'Produkt',type:Select,options:['2'=>'Kinderhilfe','3'=>'Tierhilfe']},
				//'agent'=>{label:'Agent'},
				//'sepa_code'=>{label:'Kündigungsgrund',type:DatePicker, displayFormat: "d.m.Y"},
				'end_date'=>{label:'Beendet zum',type:DatePicker, displayFormat: "d.m.Y"},				
				//'repeat_date'=>{label:'Zahlun',type:DatePicker, displayFormat: "d.m.Y"},				
				'cycle_start_date'=>{label:'Turnus Startdatum',type:DatePicker, displayFormat: "d.m.Y"},
				'end_reason'=>{className:'max50', label: 'Rückgabegrund',type: Select,options: [
					'0'=>'',
					'3'=>'Finanzen',
					'5'=>'Widerruf',
					'10'=>'VF/Verkaufsfehler',
					'13'=>'NIXI-Pool/BB',
					'14'=>'kein Interesse',
					'15'=>'unzufrieden',
					'18'=>'Rüla/Rücklastschr.',
					'26'=>'Sonstiges',
					'27'=>'bereits Mitglied',
					'31'=>'Aufleger',
					'32'=>'endgül. NE',
					'36'=>'BV falsch',
					'40'=>'Einmalspende',
					'42'=>'Künd. Verwandschaft',
					'43'=>'Senil, zu alt, etc.',
					'44'=>'ohne Grundangabe',
					'45'=>'Verstorben',
					'46'=>'Künd. Betreuer',
					'47'=>'Voice unbrauchbar',
					'49'=>'Lastschriftwiderspruch',
					'50'=>'Wiederholung gescheitert',
					'51'=>'Wiederholungsbuchung',
					'52'=>'Negativliste',
					'53'=>'Konto aufgelöst'
				]},
				'id' => {type:Hidden},
				'edited_by' => {type:Hidden},				
				'mandator' => {type:Hidden}				
			]
		}
	]; 

	public static var gridColumns:Map<String,DataColumn> = [
	//public static var shortListColumns:Map<String,DataColumn> = [
		'id'=>{label:'ID',show:false},				
		'start_date'=>{label:'Seit',cellFormat:function(v:String) return DateTools.format(Date.fromString(v), "%d.%m.%Y"), className: 'tableNums'},	
		'end_date'=>{label:'Bis',cellFormat:function(v:String){
			if(v==null)
				return null;
			 return DateTools.format(Date.fromString(v), "%d.%m.%Y");
			}},	
		'product' => {label: 'Produkt',flexGrow:1, cellFormat:function(v:Int){			
			 return switch(v){
				case 2:
					'Kinderhilfe';
				case 3:
					'Tierhilfe';	
				default:
					'Kinderhilfe';				
			 };
			}},
		'cycle' => {label: 'Turnus'},
		'amount' => {label: 'Betrag', cellFormat: function(v) {
			return App.sprintf('%01.2f €',v).replace('.',',');
		},className: 'tRight tableNums'},
		'active' => {label:'Status', className: 'tCenter',
			cellFormat:function(v:Bool) 
			{
				var className = (v?'active fas fa-user':'passive far fa-user');
				//trace('>>>$v<<<');
				return jsx('<span className=${className}></span>');
			}},		
	];

	public static var listColumns:Map<String,DataColumn> = [
		'id'=>{label:'ID',show:false},				
		'start_date'=>{label:'Seit',cellFormat:function(v:String) return DateTools.format(Date.fromString(v), "%d.%m.%Y")},	
		'end_date'=>{label:'Bis',cellFormat:function(v:String) return DateTools.format(Date.fromString(v), "%d.%m.%Y")},	
		'active' => {label:'Aktiv', className: 'tCenter',
			cellFormat:function(v:Bool) 
			{
				var className = (v?'active fas fa-user':'passive far fa-user');
				//trace('>>>$v<<<');
				return jsx('<span className=${className}></span>');
			}},
		'cycle' => {label: 'Turnus'},
		'amount' => {label: 'Betrag',cellFormat: function(v) {
			return App.sprintf('%01.2f €',v).replace('.',',');
		},className: 'tRight'},
		
	];

	public static var dataDisplay:Map<String,DataState> = [
		'dealsFull' => {columns:listColumns}
	];	

	public static var dataGridDisplay:Map<String,data.DataState> = [
		'dealsList' => {columns:gridColumns}
	];	

	public static function getDataAccess() {
		if(!_initialized){

		}
	}
}