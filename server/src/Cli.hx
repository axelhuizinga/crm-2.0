package;

import php.Lib;

class Cli {
	public static function parse():Map<String,Dynamic> {
		var args:Array<String> = Sys.args();
		var map = new Map<String,Dynamic>();
		var i:Int = 0;
		while(i < args.length-1){
			if(args[i].substr(0,1)!='-'){
				trace(i+':'+args[i]);
				return null;
			}
			if(args[i+1].substr(0,1)=='-'){
				// FLAG assumed to be true 
				map[args[i++].substr(1)] = true;
			}
			else{
				map[args[i].substr(1)] = args[i+1];
				i += 2;
			}				
		}
		//trace(map.toString());
		return map;
	}
}