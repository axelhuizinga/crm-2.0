package view.shared;
import haxe.Constraints.Function;
import view.shared.RouteTabProps;

typedef  DataProps = 
{
	>RouteTabProps,
	redirect:Function
}