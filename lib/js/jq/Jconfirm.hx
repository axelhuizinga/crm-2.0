package js.jq;


/**
 * ...
 * @author axel@cunity.me
 */
@:native('$')
extern class Jconfirm
{
	public var contentDiv:JQuery;
	public static function alert(options:Dynamic):Jconfirm;
	public static function confirm(options:Dynamic):Jconfirm;
	public static function dialog(options:Dynamic):Jconfirm;
	@:selfCall 
	public function new(msg:Dynamic, ?options:Dynamic):Void;	
	
	 public function close():Void;
	
	public function isClosed():Bool;
	public function setContent(text:String):Void;
	public function setDialogCenter():Void;
	public function pauseCountDown():Void;
	public function restartCountDown():Void;
	
}