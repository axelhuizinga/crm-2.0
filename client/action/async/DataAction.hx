package action.async;


import shared.DbData;

/**
 * ...
 * @author axel@cunity.me
 */

enum  DataAction
{
	Delete(data:DbData);
	Load(data:DbData);
	Update(data:DbData);
}
