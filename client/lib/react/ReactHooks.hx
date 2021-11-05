package react;

// All credits to Juraj Kirchheim
// https://community.haxe.org/t/haxe-react-functional-components-and-hooks/2867

@:native('React')
@:jsRequire('react')
extern class ReactHooks {
	static function useRef<T>(?value:T):{current:T};
	static function useState<T>(init:T):HookState<T>;
	static function useEffect(fx:() -> Dynamic, ?dependencies:Array<Dynamic>):Dynamic;
}

// Abstract to replace react js useState destructured array...
abstract HookState<T>(Array<Dynamic>) from Array<Dynamic> {
	public var value(get, set):T;

	function get_value():T
		return this[0];

	function set_value(param:T):T {
		this[0] = param; // may not be necessary, but in concurrent mode this should lead to more consistent state - that's why JS react users are compelled to use setState(prev => prev + 1)
		this[1](param);
		return param;
	}
}

// Attempt to handle reducers...
abstract HookReduce<T, K>(Array<Dynamic>) from Array<Dynamic> {
	public var value(get, never):T;

	function get_value():T
		return this[0];

	public function dispatch(action:K):Void
		this[0] = this[1](action);
}
