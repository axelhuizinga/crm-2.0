package shared;

//import haxe.ds.Either;

enum abstract DateFormatResult(String)
{
	var OK;
	var PartMisMatch;
	var DayFormatRange;
	var DayFormatSize;
	var MonthFormatRange;
	var MonthFormatSize;
	var YearFormatRange;
	var YearFormatSize;
}

typedef DateFormatted = 
{
	?date:Date,
	result:DateFormatResult
}

class DateFormat {

	public static function parseDE(dS:String):DateFormatted
	{
		var dP:Array<String> = dS.split('.');
		
		if(dP.length!=3)
		{
			//VERIFY PARTS COUNT
			return {result:PartMisMatch};
		}
		if(dP[0].length !=2)
		{
			if(Std.parseInt(dP[0])==null)
			return {result:DayFormatSize};
		}
		if(dP[1].length !=2)
		{
			//VERIFY MONTH FORMAT MM
			return {result:MonthFormatSize};
		}
		if(dP[2].length !=4)
		{
			//VERIFY YEAR FORMAT YYYY
			return {result:YearFormatSize};
		}		
		var day:String = App.sprintf('%02d',Std.parseInt(dP[0]));
		var month:String = App.sprintf('%02d',Std.parseInt(dP[1]));
		var year:String = App.sprintf('%d',Std.parseInt(dP[2]));
		return {date:Date.fromString('$year-$month-$day'),result:OK};
	}
	
}