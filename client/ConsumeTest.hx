import com.Foo;
import react.ReactMacro.jsx;
import react.ReactComponent;

typedef RootState = {
    route: String,
    ?component: react.React.CreateElementType
}

class ConsumeTest extends react.ReactComponent {

    public function new() {
        super();
		App.edump(props);
		App.edump(state);
        //state = { route:'' };
    }

    override function componentDidMount() {
		
	}
	
	function realRender(state):Dynamic
	{
		trace(state);
		return jsx('
			<div style={{color:state.themeColor}}>
				I AM aware of the toplevel state :)
			</div>
		');
	}

    override function render() {
    //trace(state);
        return jsx('
				<App.AppContext.Consumer>
				{function(value) return realRender(value)}
				</App.AppContext.Consumer>
        ');
    }

}
