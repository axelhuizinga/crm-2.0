package model;

typedef StatementProps = {
	?a:Int,
	?b:Int,
	?c:String,
	?d:String,
	?e:String,
	?f:String,
	?g:Int,
	?h:String,
	?i:String,
	?j:String,
	?k:String,
	?l:String,
	?m:String,
	?n:String,
	?o:String,
	?p:String,
	?q:String,
	?r:String,
	?s:String,
	?t:String,
	?u:String,
	?v:String,
	?w:String,
	?x:String,
	?y:String,
	?z:String,
	?aa:Int,
	?processed:Int,
	?id:Int,
	?edited_by:Int,
	?mandator:Int
};

class Statement extends ORM
{
	public static var varNames:String = 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,aa,processed,id,edited_by,mandator';
		public function new(props:StatementProps) {
		super(props);
		for(f in Reflect.fields(props))
		{
			Reflect.setField(this, f, Reflect.field(props, f));
		}
	}

	//{"type":"bigint","default":"null","attnum":"1"}
	@:isVar public var a(get,set):Int;
	var initial_a:Int;
	
	function get_a():Int{
		return a;
	}

	function set_a(x:Int):Int{

		modified('a');
		a = x;
		if(initial_a == null)
			initial_a = a; 
		return a;
	}

	public function reset_a():Int{
		return initial_a;
	}

	public function clear_a():Int{
		a = null;
		return a;
	}

	//{"type":"bigint","default":"null","attnum":"2"}
	@:isVar public var b(get,set):Int;
	var initial_b:Int;
	
	function get_b():Int{
		return b;
	}

	function set_b(x:Int):Int{

		modified('b');
		b = x;
		if(initial_b == null)
			initial_b = b; 
		return b;
	}

	public function reset_b():Int{
		return initial_b;
	}

	public function clear_b():Int{
		b = null;
		return b;
	}

	//{"type":"date","default":"'null'","attnum":"3"}
	@:isVar public var c(get,set):String;
	var initial_c:String;
	
	function get_c():String{
			return c;
	}

	function set_c(x:String):String{

		modified('c');
		c = x;
		if(initial_c == null)
			initial_c = c; 
		return c;
	}

	public function reset_c():String{
		return initial_c;
	}

	public function clear_c():String{
		c = 'null';
		return c;
	}

	//{"type":"date","default":"'null'","attnum":"4"}
	@:isVar public var d(get,set):String;
	var initial_d:String;
	
	function get_d():String{
			return d;
	}

	function set_d(x:String):String{

		modified('d');
		d = x;
		if(initial_d == null)
			initial_d = d; 
		return d;
	}

	public function reset_d():String{
		return initial_d;
	}

	public function clear_d():String{
		d = 'null';
		return d;
	}

	//{"type":"double precision","default":"''","attnum":"5"}
	@:isVar public var e(get,set):String;
	var initial_e:String;
	
	function get_e():String{
			return e;
	}

	function set_e(x:String):String{

		modified('e');
		e = x;
		if(initial_e == null)
			initial_e = e; 
		return e;
	}

	public function reset_e():String{
		return initial_e;
	}

	public function clear_e():String{
		e = '';
		return e;
	}

	//{"type":"character varying(3)","default":"''","attnum":"6"}
	@:isVar public var f(get,set):String;
	var initial_f:String;
	
	function get_f():String{
		return f;
	}

	function set_f(x:String):String{

		modified('f');
		f = x;
		if(initial_f == null)
			initial_f = f; 
		return f;
	}

	public function reset_f():String{
		return initial_f;
	}

	public function clear_f():String{
		f = '';
		return f;
	}

	//{"type":"bigint","default":"null","attnum":"7"}
	@:isVar public var g(get,set):Int;
	var initial_g:Int;
	
	function get_g():Int{
		return g;
	}

	function set_g(x:Int):Int{

		modified('g');
		g = x;
		if(initial_g == null)
			initial_g = g; 
		return g;
	}

	public function reset_g():Int{
		return initial_g;
	}

	public function clear_g():Int{
		g = null;
		return g;
	}

	//{"type":"character varying(160)","default":"''","attnum":"8"}
	@:isVar public var h(get,set):String;
	var initial_h:String;
	
	function get_h():String{
		return h;
	}

	function set_h(x:String):String{

		modified('h');
		h = x;
		if(initial_h == null)
			initial_h = h; 
		return h;
	}

	public function reset_h():String{
		return initial_h;
	}

	public function clear_h():String{
		h = '';
		return h;
	}

	//{"type":"character varying(160)","default":"''","attnum":"9"}
	@:isVar public var i(get,set):String;
	var initial_i:String;
	
	function get_i():String{
		return i;
	}

	function set_i(x:String):String{

		modified('i');
		i = x;
		if(initial_i == null)
			initial_i = i; 
		return i;
	}

	public function reset_i():String{
		return initial_i;
	}

	public function clear_i():String{
		i = '';
		return i;
	}

	//{"type":"character varying(160)","default":"''","attnum":"10"}
	@:isVar public var j(get,set):String;
	var initial_j:String;
	
	function get_j():String{
		return j;
	}

	function set_j(x:String):String{

		modified('j');
		j = x;
		if(initial_j == null)
			initial_j = j; 
		return j;
	}

	public function reset_j():String{
		return initial_j;
	}

	public function clear_j():String{
		j = '';
		return j;
	}

	//{"type":"character varying(160)","default":"''","attnum":"11"}
	@:isVar public var k(get,set):String;
	var initial_k:String;
	
	function get_k():String{
		return k;
	}

	function set_k(x:String):String{

		modified('k');
		k = x;
		if(initial_k == null)
			initial_k = k; 
		return k;
	}

	public function reset_k():String{
		return initial_k;
	}

	public function clear_k():String{
		k = '';
		return k;
	}

	//{"type":"character varying(160)","default":"''","attnum":"12"}
	@:isVar public var l(get,set):String;
	var initial_l:String;
	
	function get_l():String{
		return l;
	}

	function set_l(x:String):String{

		modified('l');
		l = x;
		if(initial_l == null)
			initial_l = l; 
		return l;
	}

	public function reset_l():String{
		return initial_l;
	}

	public function clear_l():String{
		l = '';
		return l;
	}

	//{"type":"character varying(160)","default":"''","attnum":"13"}
	@:isVar public var m(get,set):String;
	var initial_m:String;
	
	function get_m():String{
		return m;
	}

	function set_m(x:String):String{

		modified('m');
		m = x;
		if(initial_m == null)
			initial_m = m; 
		return m;
	}

	public function reset_m():String{
		return initial_m;
	}

	public function clear_m():String{
		m = '';
		return m;
	}

	//{"type":"character varying(32)","default":"''","attnum":"14"}
	@:isVar public var n(get,set):String;
	var initial_n:String;
	
	function get_n():String{
		return n;
	}

	function set_n(x:String):String{

		modified('n');
		n = x;
		if(initial_n == null)
			initial_n = n; 
		return n;
	}

	public function reset_n():String{
		return initial_n;
	}

	public function clear_n():String{
		n = '';
		return n;
	}

	//{"type":"character varying(32)","default":"''","attnum":"15"}
	@:isVar public var o(get,set):String;
	var initial_o:String;
	
	function get_o():String{
		return o;
	}

	function set_o(x:String):String{

		modified('o');
		o = x;
		if(initial_o == null)
			initial_o = o; 
		return o;
	}

	public function reset_o():String{
		return initial_o;
	}

	public function clear_o():String{
		o = '';
		return o;
	}

	//{"type":"character varying(32)","default":"''","attnum":"16"}
	@:isVar public var p(get,set):String;
	var initial_p:String;
	
	function get_p():String{
		return p;
	}

	function set_p(x:String):String{

		modified('p');
		p = x;
		if(initial_p == null)
			initial_p = p; 
		return p;
	}

	public function reset_p():String{
		return initial_p;
	}

	public function clear_p():String{
		p = '';
		return p;
	}

	//{"type":"character varying(64)","default":"''","attnum":"17"}
	@:isVar public var q(get,set):String;
	var initial_q:String;
	
	function get_q():String{
		return q;
	}

	function set_q(x:String):String{

		modified('q');
		q = x;
		if(initial_q == null)
			initial_q = q; 
		return q;
	}

	public function reset_q():String{
		return initial_q;
	}

	public function clear_q():String{
		q = '';
		return q;
	}

	//{"type":"character varying(32)","default":"''","attnum":"18"}
	@:isVar public var r(get,set):String;
	var initial_r:String;
	
	function get_r():String{
		return r;
	}

	function set_r(x:String):String{

		modified('r');
		r = x;
		if(initial_r == null)
			initial_r = r; 
		return r;
	}

	public function reset_r():String{
		return initial_r;
	}

	public function clear_r():String{
		r = '';
		return r;
	}

	//{"type":"character varying(32)","default":"''","attnum":"19"}
	@:isVar public var s(get,set):String;
	var initial_s:String;
	
	function get_s():String{
		return s;
	}

	function set_s(x:String):String{

		modified('s');
		s = x;
		if(initial_s == null)
			initial_s = s; 
		return s;
	}

	public function reset_s():String{
		return initial_s;
	}

	public function clear_s():String{
		s = '';
		return s;
	}

	//{"type":"character varying(32)","default":"''","attnum":"20"}
	@:isVar public var t(get,set):String;
	var initial_t:String;
	
	function get_t():String{
		return t;
	}

	function set_t(x:String):String{

		modified('t');
		t = x;
		if(initial_t == null)
			initial_t = t; 
		return t;
	}

	public function reset_t():String{
		return initial_t;
	}

	public function clear_t():String{
		t = '';
		return t;
	}

	//{"type":"character varying(32)","default":"''","attnum":"21"}
	@:isVar public var u(get,set):String;
	var initial_u:String;
	
	function get_u():String{
		return u;
	}

	function set_u(x:String):String{

		modified('u');
		u = x;
		if(initial_u == null)
			initial_u = u; 
		return u;
	}

	public function reset_u():String{
		return initial_u;
	}

	public function clear_u():String{
		u = '';
		return u;
	}

	//{"type":"character varying(32)","default":"''","attnum":"22"}
	@:isVar public var v(get,set):String;
	var initial_v:String;
	
	function get_v():String{
		return v;
	}

	function set_v(x:String):String{

		modified('v');
		v = x;
		if(initial_v == null)
			initial_v = v; 
		return v;
	}

	public function reset_v():String{
		return initial_v;
	}

	public function clear_v():String{
		v = '';
		return v;
	}

	//{"type":"character varying(28)","default":"''","attnum":"23"}
	@:isVar public var w(get,set):String;
	var initial_w:String;
	
	function get_w():String{
		return w;
	}

	function set_w(x:String):String{

		modified('w');
		w = x;
		if(initial_w == null)
			initial_w = w; 
		return w;
	}

	public function reset_w():String{
		return initial_w;
	}

	public function clear_w():String{
		w = '';
		return w;
	}

	//{"type":"character varying(32)","default":"''","attnum":"24"}
	@:isVar public var x(get,set):String;
	var initial_x:String;
	
	function get_x():String{
		return x;
	}

	function set_x(x:String):String{

		modified('x');
		x = x;
		if(initial_x == null)
			initial_x = x; 
		return x;
	}

	public function reset_x():String{
		return initial_x;
	}

	public function clear_x():String{
		x = '';
		return x;
	}

	//{"type":"character varying(11)","default":"''","attnum":"25"}
	@:isVar public var y(get,set):String;
	var initial_y:String;
	
	function get_y():String{
		return y;
	}

	function set_y(x:String):String{

		modified('y');
		y = x;
		if(initial_y == null)
			initial_y = y; 
		return y;
	}

	public function reset_y():String{
		return initial_y;
	}

	public function clear_y():String{
		y = '';
		return y;
	}

	//{"type":"character varying(22)","default":"''","attnum":"26"}
	@:isVar public var z(get,set):String;
	var initial_z:String;
	
	function get_z():String{
		return z;
	}

	function set_z(x:String):String{

		modified('z');
		z = x;
		if(initial_z == null)
			initial_z = z; 
		return z;
	}

	public function reset_z():String{
		return initial_z;
	}

	public function clear_z():String{
		z = '';
		return z;
	}

	//{"type":"bigint","default":"null","attnum":"27"}
	@:isVar public var aa(get,set):Int;
	var initial_aa:Int;
	
	function get_aa():Int{
		return aa;
	}

	function set_aa(x:Int):Int{

		modified('aa');
		aa = x;
		if(initial_aa == null)
			initial_aa = aa; 
		return aa;
	}

	public function reset_aa():Int{
		return initial_aa;
	}

	public function clear_aa():Int{
		aa = null;
		return aa;
	}

	//{"type":"smallint","default":"'0'","attnum":"28"}
	@:isVar public var processed(get,set):Int;
	var initial_processed:Int;
	
	function get_processed():Int{
		return processed;
	}

	function set_processed(x:Int):Int{

		modified('processed');
		processed = x;
		if(initial_processed == null)
			initial_processed = processed; 
		return processed;
	}

	public function reset_processed():Int{
		return initial_processed;
	}

	public function clear_processed():Int{
		processed = '0';
		return processed;
	}

	//{"type":"bigint","default":"null","attnum":"29"}
	@:isVar public var id(get,set):Int;
	var initial_id:Int;
	
	function get_id():Int{
		return id;
	}

	function set_id(x:Int):Int{

		modified('id');
		id = x;
		if(initial_id == null)
			initial_id = id; 
		return id;
	}

	public function reset_id():Int{
		return initial_id;
	}

	public function clear_id():Int{
		id = null;
		return id;
	}

	//{"type":"bigint","default":"null","attnum":"30"}
	@:isVar public var edited_by(get,set):Int;
	var initial_edited_by:Int;
	
	function get_edited_by():Int{
		return edited_by;
	}

	function set_edited_by(x:Int):Int{

		modified('edited_by');
		edited_by = x;
		if(initial_edited_by == null)
			initial_edited_by = edited_by; 
		return edited_by;
	}

	public function reset_edited_by():Int{
		return initial_edited_by;
	}

	public function clear_edited_by():Int{
		edited_by = null;
		return edited_by;
	}

	//{"type":"bigint","default":"nextval('statements_man_seq'","attnum":"31"}
	@:isVar public var mandator(get,set):Int;
	var initial_mandator:Int;
	
	function get_mandator():Int{
		return mandator;
	}

	function set_mandator(x:Int):Int{

		modified('mandator');
		mandator = x;
		if(initial_mandator == null)
			initial_mandator = mandator; 
		return mandator;
	}

	public function reset_mandator():Int{
		return initial_mandator;
	}

	public function clear_mandator():Int{
		mandator = nextval('statements_man_seq';
		return mandator;
	}
}