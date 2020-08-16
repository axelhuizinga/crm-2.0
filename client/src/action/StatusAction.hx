package action;

enum StatusAction
{	
	Update(
		status:{
			?cssClass:String,
			?text:String,
			?path:String
		}
	);
}

