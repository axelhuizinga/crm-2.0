package view.contacts.components;
import react.ReactComponent;
import react.ReactMacro.jsx;
import view.model.Contacts;

/*
 * GNU Affero General Public License
 *
 * Copyright (c) 2019 ParadiseProjects.de
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation::,\n either version 3 of the License:, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


/**
 * 
 */

class ContactForm extends ReactComponent
{
    static var initialContact:Contacts =
    {
        id:0,
        mandator: 0,
        edited_by: App._app.state.appWare.user.user_name
    };

    override function render() 
	{	
		//trace(this.state);
		//trace(props.history.location.pathname);
		//trace(props.user);
		if (state.hasError)
			return jsx('<h1>Fehler in ${Type.getClassName(Type.getClass(this))}.</h1>');
		trace(Reflect.fields(props));
		trace(Reflect.fields(state));
		return jsx('');
    }

}