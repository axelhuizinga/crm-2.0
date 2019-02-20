package bulma_components;

import react.ReactComponent;
import react.ReactPropTypes;

/**
 * ...
 * @author axel@cunity.me
 */

@:jsRequire('reactbulma', 'Tabs')
extern class Tabs extends ReactComponentOfProps<TabsProps>
{
}
typedef TabsProps = {
	?className:String,
	?right:Bool,		
	?centered:Bool,		
	?boxed:Bool,		
	?fullwidth:Bool,		
	?small:Bool,		
	?medium:Bool,		
	?large:Bool,		
	?toggle:Bool
}