package view.shared;
import react.ReactType;
import model.UserState;
import react.router.Route.RouteComponentProps;
import redux.Redux.Dispatch;

/**
 * ...
 * @author axel@cunity.me
 */
typedef RouteTabProps =
{
	>RouteComponentProps,
	?appConfig:Dynamic,
	//?dispatch:Dispatch,
	user: UserState,
}