package action;

import action.ReduxAction;

typedef Dispatch = haxe.extern.EitherType<ReduxAction,Thunk> -> Void;

typedef Thunk = Dispatch -> (Void -> state.State) -> Void;
