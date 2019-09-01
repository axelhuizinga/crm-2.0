package view;

import react.ReactComponent;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;


import Webpack.*;
 
//@:expose('default')
@:connect
class Statistics extends ReactComponent {

   /* static var STYLES = require('./Foo.css');
	* 
}onSubmit={submitForm}
return jsx('<Form onSubmit={formSubmit} render={formRender}/>');
    static var IMG = require('./bug.png');*/
    static var CONFIG = require('../config.json');
	
	/*function formRender(formApi: FormApi) {
		return jsx('');
	}*/
	
    override function render() {
        return jsx('
            <div className="">
				<h1>Statistics</h1>
            </div>
        ');
    }
}
