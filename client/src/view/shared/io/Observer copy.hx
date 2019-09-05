package view.shared.io;
import js.lib.Proxy;
import js.lib.Object;

class Observer{

	static var handler:ProxyHandler<Dynamic>;

	public static function run(obj:Dynamic, cb:Dynamic->Void):Dynamic{
		handler = {
			set: function (target, property:String, value, receiver:Dynamic):Bool{
				try{
					trace(target);
					trace(receiver);
					//target=receiver;
					Reflect.setField(target,property,value);
					cb(target);
					return true;
				} catch(e:Dynamic){
					trace(e);
					return false;
				}
			}
		};
		return cast new Proxy(obj,handler);
	}		
}