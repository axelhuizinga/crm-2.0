package me.cunity.php;
import php.Const;
import php.Global;
import haxe.PosInfos;
import php.Syntax;
import php.Web;
import sys.io.File;
import sys.io.FileOutput;

@:keep
class Debug
{
	public static var logFile:String;
	
	public static function dump(message:Dynamic , stackPos:UInt=0):Void
	{
		Syntax.code("edump({0},{1})",message, stackPos);
	};	
	
	public static function _trace(v : Dynamic, ?i : PosInfos)
	{
		var info:String = if( i != null ) i.fileName+":"+i.methodName +":"+i.lineNumber+":" else "";		
		//untyped __call__('edump',  info + ':' + v);
		#if php
		//Global.error_log(info + '>>>:' + v + "\n");
		Global.file_put_contents(logFile, info + ':' + ( Std.is(v, String) || Std.is(v, Int) || Std.is(v, Float)  ? Std.string(v) + "\n" : 
		Syntax.code("print_r({0},{1})", v, 1)+"\n"), Const.FILE_APPEND
			);
		#end
		/*var out:FileOutput = File.append( logFile);
		out.writeString(
			info + ':' + ( Std.is(v, String) || Std.is(v, Int) || Std.is(v, Float)  ? Std.string(v) + "\n" : 
				Syntax.code("print_r({0},{1})", v, 1)));
		//untyped __call__('trace', v, info);*/
	}
	
}