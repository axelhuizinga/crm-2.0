package me.cunity.php.db;
#if php
import php.NativeArray;
#elseif neko
import neko.NativeArray;
#end
import me.cunity.php.db.MySQLi;

/**
 * ...
 * @author axel@cunity.me
 */
@:native('mysqli_result')
extern class MySQLi_Result
{

	public var num_rows:Int;
	
	public function new():Void;
	
	public function data_seek(offset:Int):Bool;
	
	public function free():Void;
	
	public function fetch_all(resulttype:Int = 2):NativeArray;
	
	public function fetch_array(resulttype:Int = 3):NativeArray;
	
	
	
}