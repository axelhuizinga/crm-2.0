package js.jq;


/**
 * ...
 * @author axel@cunity.me
 */
extern class Template implements js.jquery.Plugin
//@:keep class Template
{

	public function tmpl(data:Dynamic):js.jquery.JQuery;
	/*{
		trace(data);
		return untyped this.tmpl(data);
	}*/
	
	public function template(name:String):js.jquery.JQuery;
	/*{
		return untyped this.template(name);
	}*/
	
	
	public function tmplItem():js.jquery.JQuery;
	/*{
		return untyped this.templItem();
	}*/
	
	public function update():js.jquery.JQuery;
	/*{
		return untyped this.update();
	}*/
	
	static public function template(name:String, template: String):JQuery
	//static public function template(name:String, template: EitherType<String,JQuery>):JQuery
	{
		return untyped this.template(name, template);
	}
	
	static public function tmpl(compiledName:String, data:Dynamic):JQuery
	{
		return untyped this.tmpl(compiledName, data);
		//return untyped Browser.window.$.tmpl(compiledName, data);
	}
}