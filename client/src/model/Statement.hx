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
	?edited_by:Int,
	?mandator:Int
};

@:rtti
class Statement extends ORM
{

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,aa,processed,edited_by,mandator'.split(',');
	}	
		
	@dataType("bigint")
	@:isVar public var a(default,set):Int;

	function set_a(a:Int):Int{
		if(initialized('a'))
			modified('a');
		this.a = a ;
		return a;
	}	
		
	@dataType("bigint")
	@:isVar public var b(default,set):Int;

	function set_b(b:Int):Int{
		if(initialized('b'))
			modified('b');
		this.b = b ;
		return b;
	}	
		
	@dataType("date")
	@:isVar public var c(default,set):String;

	function set_c(c:String):String{
		if(initialized('c'))
			modified('c');
		this.c = c ;
		return c;
	}	
		
	@dataType("date")
	@:isVar public var d(default,set):String;

	function set_d(d:String):String{
		if(initialized('d'))
			modified('d');
		this.d = d ;
		return d;
	}	
		
	@dataType("double precision")
	@:isVar public var e(default,set):String;

	function set_e(e:String):String{
		if(initialized('e'))
			modified('e');
		this.e = e ;
		return e;
	}	
		
	@dataType("character varying(3)")
	@:isVar public var f(default,set):String;

	function set_f(f:String):String{
		if(initialized('f'))
			modified('f');
		this.f = f ;
		return f;
	}	
		
	@dataType("bigint")
	@:isVar public var g(default,set):Int;

	function set_g(g:Int):Int{
		if(initialized('g'))
			modified('g');
		this.g = g ;
		return g;
	}	
		
	@dataType("character varying(160)")
	@:isVar public var h(default,set):String;

	function set_h(h:String):String{
		if(initialized('h'))
			modified('h');
		this.h = h ;
		return h;
	}	
		
	@dataType("character varying(160)")
	@:isVar public var i(default,set):String;

	function set_i(i:String):String{
		if(initialized('i'))
			modified('i');
		this.i = i ;
		return i;
	}	
		
	@dataType("character varying(160)")
	@:isVar public var j(default,set):String;

	function set_j(j:String):String{
		if(initialized('j'))
			modified('j');
		this.j = j ;
		return j;
	}	
		
	@dataType("character varying(160)")
	@:isVar public var k(default,set):String;

	function set_k(k:String):String{
		if(initialized('k'))
			modified('k');
		this.k = k ;
		return k;
	}	
		
	@dataType("character varying(160)")
	@:isVar public var l(default,set):String;

	function set_l(l:String):String{
		if(initialized('l'))
			modified('l');
		this.l = l ;
		return l;
	}	
		
	@dataType("character varying(160)")
	@:isVar public var m(default,set):String;

	function set_m(m:String):String{
		if(initialized('m'))
			modified('m');
		this.m = m ;
		return m;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var n(default,set):String;

	function set_n(n:String):String{
		if(initialized('n'))
			modified('n');
		this.n = n ;
		return n;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var o(default,set):String;

	function set_o(o:String):String{
		if(initialized('o'))
			modified('o');
		this.o = o ;
		return o;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var p(default,set):String;

	function set_p(p:String):String{
		if(initialized('p'))
			modified('p');
		this.p = p ;
		return p;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var q(default,set):String;

	function set_q(q:String):String{
		if(initialized('q'))
			modified('q');
		this.q = q ;
		return q;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var r(default,set):String;

	function set_r(r:String):String{
		if(initialized('r'))
			modified('r');
		this.r = r ;
		return r;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var s(default,set):String;

	function set_s(s:String):String{
		if(initialized('s'))
			modified('s');
		this.s = s ;
		return s;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var t(default,set):String;

	function set_t(t:String):String{
		if(initialized('t'))
			modified('t');
		this.t = t ;
		return t;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var u(default,set):String;

	function set_u(u:String):String{
		if(initialized('u'))
			modified('u');
		this.u = u ;
		return u;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var v(default,set):String;

	function set_v(v:String):String{
		if(initialized('v'))
			modified('v');
		this.v = v ;
		return v;
	}	
		
	@dataType("character varying(28)")
	@:isVar public var w(default,set):String;

	function set_w(w:String):String{
		if(initialized('w'))
			modified('w');
		this.w = w ;
		return w;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var x(default,set):String;

	function set_x(x:String):String{
		if(initialized('x'))
			modified('x');
		this.x = x ;
		return x;
	}	
		
	@dataType("character varying(11)")
	@:isVar public var y(default,set):String;

	function set_y(y:String):String{
		if(initialized('y'))
			modified('y');
		this.y = y ;
		return y;
	}	
		
	@dataType("character varying(22)")
	@:isVar public var z(default,set):String;

	function set_z(z:String):String{
		if(initialized('z'))
			modified('z');
		this.z = z ;
		return z;
	}	
		
	@dataType("bigint")
	@:isVar public var aa(default,set):Int;

	function set_aa(aa:Int):Int{
		if(initialized('aa'))
			modified('aa');
		this.aa = aa ;
		return aa;
	}	
		
	@dataType("smallint")
	@:isVar public var processed(default,set):Int;

	function set_processed(processed:Int):Int{
		if(initialized('processed'))
			modified('processed');
		this.processed = processed ;
		return processed;
	}	
		
	@dataType("bigint")
	@:isVar public var edited_by(default,set):Int;

	function set_edited_by(edited_by:Int):Int{
		if(initialized('edited_by'))
			modified('edited_by');
		this.edited_by = edited_by ;
		return edited_by;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(default,set):Int;

	function set_mandator(mandator:Int):Int{
		if(initialized('mandator'))
			modified('mandator');
		this.mandator = mandator ;
		return mandator;
	}	
	
}