import react.ReactHooks;
import react.ReactMacro.jsx;

class ReactHooksExample {
	static public function main() {
		var body = js.Browser.document.querySelector('main');
		react.ReactDOM.render(jsx('<TestHooks defaultText=${'Abc123'} />'), body);
	}

	static public function TestHooks(props:{defaultText:String}):react.ReactComponent.ReactElement {
		//----------------------------------------------
		// State ReactHooks
		
    	var text = ReactHooks.useState(props.defaultText);
		var num = ReactHooks.useState(222);

		//----------------------------------------------
		// Ref ReactHooks

		// We must use ref for render counter - it can't be held in state, because updating a state counter
		// would cause another render, causing an inifite loop
		var renderCountRef = ReactHooks.useRef(1);

		var inputRef = ReactHooks.useRef();

		//---------------------------------------
		// Effect ReactHooks

		ReactHooks.useEffect(() -> {
			trace('run on each render');
			renderCountRef.current++; // increase counter on each render
		});

		/*ReactHooks.useEffect(() -> {
			trace('run when num is changed, but not when text is changed');
		}, [num.value]);
*/
		//------------------------------------------------
		// Render
		return jsx('<div>
			<h3>Haxe, React, Functional components, ReactHooks</h3>
			<div>text: <input key="input" ref=${inputRef} value=${text.value} onChange=${e -> text.value = e.target.value} />	</div>
			<div>
				<button onClick=${e -> num.value +=1}>Inc num</button>
				<button onClick=${e -> num.value -=1}>Dec num</button>
				<span>num: ${num.value}</span>
			</div>
			<p>Render count: ${renderCountRef.current} </p>
			<button onClick=${e -> inputRef.current.focus()}>Set input field focus</button>
		</div>');
	}
}