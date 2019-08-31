package action.thunk;

import state.State;

import action.Thunk;
import action.IntlAction;

import react.native.module.DeviceInfo;

import js.Browser.console;

class IntlThunk {

    static public function init(cb : Void -> Void) : Thunk {
        return function initThunk(dispatch, getState) {
            dispatch(initDefaultLang(cb));
        }
    }

    static public function initDefaultLang(cb : Void -> Void) : Thunk {
        return function initDefaultLangThunk(dispatch, getState) {
            if (getState().intl.locale==null) {
                var a : ReduxAction = new IntlReduxAction(ReceiveLocale(DeviceInfo.getDeviceLocale()));
                dispatch(a);
            }
            cb();
        }
    }
}
