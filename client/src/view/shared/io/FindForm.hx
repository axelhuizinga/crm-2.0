package view.shared.io;

class FindForm //extends ReactComponentOf<DataFormProps,FormState>
{
	
	public static var menuItems:Array<MItem> = [
		{label:'Neu',action:'insert'},
		{label:'Bearbeiten',action:'update'},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'}
	];

	public function new(props:DataFormProps)
	{
		//super(props);		

		/*state = {
			clean:true,
			hasError:false,
			mounted:false,
			loading:true,
			sideMenu:{}, 
		};

		trace(this.props);*/
	}
	
	function render()
	{
		//return jsx('<div />');
	}
		
	
}