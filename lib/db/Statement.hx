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

@:rtti
class Statement extends ORM
{

	public function new(props:StatementProps) {
		propertyNames = 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,aa,processed,id,edited_by,mandator'.split(',');
		super(propsMwaaa);
	}	
		
	@dataType("bigint")
	@:isVar public var a(get,set):Int;
	var a_initialized:Bool;
	
	function get_a():Int{
		return a;
	}

	function set_a(a:Int):Int{
		if(a_initialized)
			modified('a');
		this.a = a ;
		a_initialized = true; 
		return a;
	}	
		
	@dataType("bigint")
	@:isVar public var b(get,set):Int;
	var b_initialized:Bool;
	
	function get_b():Int{
		return b;
	}

	function set_b(b:Int):Int{
		if(b_initialized)
			modified('b');
		this.b = b ;
		b_initialized = true; 
		return b;
	}	
		
	@dataType("date")
	@:isVar public var c(get,set):String;
	var c_initialized:Bool;
	
	function get_c():String{
			return c;
	}

	function set_c(c:String):String{
		if(c_initialized)
			modified('c');
		this.c = c ;
		c_initialized = true; 
		return c;
	}	
		
	@dataType("date")
	@:isVar public var d(get,set):String;
	var d_initialized:Bool;
	
	function get_d():String{
			return d;
	}

	function set_d(d:String):String{
		if(d_initialized)
			modified('d');
		this.d = d ;
		d_initialized = true; 
		return d;
	}	
		
	@dataType("double precision")
	@:isVar public var e(get,set):String;
	var e_initialized:Bool;
	
	function get_e():String{
			return e;
	}

	function set_e(e:String):String{
		if(e_initialized)
			modified('e');
		this.e = e ;
		e_initialized = true; 
		return e;
	}	
		
	@dataType("character varying(3)")
	@:isVar public var f(get,set):String;
	var f_initialized:Bool;
	
	function get_f():String{
		return f;
	}

	function set_f(f:String):String{
		if(f_initialized)
			modified('f');
		this.f = f ;
		f_initialized = true; 
		return f;
	}	
		
	@dataType("bigint")
	@:isVar public var g(get,set):Int;
	var g_initialized:Bool;
	
	function get_g():Int{
		return g;
	}

	function set_g(g:Int):Int{
		if(g_initialized)
			modified('g');
		this.g = g ;
		g_initialized = true; 
		return g;
	}	
		
	@dataType("character varying(160)")
	@:isVar public var h(get,set):String;
	var h_initialized:Bool;
	
	function get_h():String{
		return h;
	}

	function set_h(h:String):String{
		if(h_initialized)
			modified('h');
		this.h = h ;
		h_initialized = true; 
		return h;
	}	
		
	@dataType("character varying(160)")
	@:isVar public var i(get,set):String;
	var i_initialized:Bool;
	
	function get_i():String{
		return i;
	}

	function set_i(i:String):String{
		if(i_initialized)
			modified('i');
		this.i = i ;
		i_initialized = true; 
		return i;
	}	
		
	@dataType("character varying(160)")
	@:isVar public var j(get,set):String;
	var j_initialized:Bool;
	
	function get_j():String{
		return j;
	}

	function set_j(j:String):String{
		if(j_initialized)
			modified('j');
		this.j = j ;
		j_initialized = true; 
		return j;
	}	
		
	@dataType("character varying(160)")
	@:isVar public var k(get,set):String;
	var k_initialized:Bool;
	
	function get_k():String{
		return k;
	}

	function set_k(k:String):String{
		if(k_initialized)
			modified('k');
		this.k = k ;
		k_initialized = true; 
		return k;
	}	
		
	@dataType("character varying(160)")
	@:isVar public var l(get,set):String;
	var l_initialized:Bool;
	
	function get_l():String{
		return l;
	}

	function set_l(l:String):String{
		if(l_initialized)
			modified('l');
		this.l = l ;
		l_initialized = true; 
		return l;
	}	
		
	@dataType("character varying(160)")
	@:isVar public var m(get,set):String;
	var m_initialized:Bool;
	
	function get_m():String{
		return m;
	}

	function set_m(m:String):String{
		if(m_initialized)
			modified('m');
		this.m = m ;
		m_initialized = true; 
		return m;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var n(get,set):String;
	var n_initialized:Bool;
	
	function get_n():String{
		return n;
	}

	function set_n(n:String):String{
		if(n_initialized)
			modified('n');
		this.n = n ;
		n_initialized = true; 
		return n;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var o(get,set):String;
	var o_initialized:Bool;
	
	function get_o():String{
		return o;
	}

	function set_o(o:String):String{
		if(o_initialized)
			modified('o');
		this.o = o ;
		o_initialized = true; 
		return o;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var p(get,set):String;
	var p_initialized:Bool;
	
	function get_p():String{
		return p;
	}

	function set_p(p:String):String{
		if(p_initialized)
			modified('p');
		this.p = p ;
		p_initialized = true; 
		return p;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var q(get,set):String;
	var q_initialized:Bool;
	
	function get_q():String{
		return q;
	}

	function set_q(q:String):String{
		if(q_initialized)
			modified('q');
		this.q = q ;
		q_initialized = true; 
		return q;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var r(get,set):String;
	var r_initialized:Bool;
	
	function get_r():String{
		return r;
	}

	function set_r(r:String):String{
		if(r_initialized)
			modified('r');
		this.r = r ;
		r_initialized = true; 
		return r;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var s(get,set):String;
	var s_initialized:Bool;
	
	function get_s():String{
		return s;
	}

	function set_s(s:String):String{
		if(s_initialized)
			modified('s');
		this.s = s ;
		s_initialized = true; 
		return s;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var t(get,set):String;
	var t_initialized:Bool;
	
	function get_t():String{
		return t;
	}

	function set_t(t:String):String{
		if(t_initialized)
			modified('t');
		this.t = t ;
		t_initialized = true; 
		return t;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var u(get,set):String;
	var u_initialized:Bool;
	
	function get_u():String{
		return u;
	}

	function set_u(u:String):String{
		if(u_initialized)
			modified('u');
		this.u = u ;
		u_initialized = true; 
		return u;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var v(get,set):String;
	var v_initialized:Bool;
	
	function get_v():String{
		return v;
	}

	function set_v(v:String):String{
		if(v_initialized)
			modified('v');
		this.v = v ;
		v_initialized = true; 
		return v;
	}	
		
	@dataType("character varying(28)")
	@:isVar public var w(get,set):String;
	var w_initialized:Bool;
	
	function get_w():String{
		return w;
	}

	function set_w(w:String):String{
		if(w_initialized)
			modified('w');
		this.w = w ;
		w_initialized = true; 
		return w;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var x(get,set):String;
	var x_initialized:Bool;
	
	function get_x():String{
		return x;
	}

	function set_x(x:String):String{
		if(x_initialized)
			modified('x');
		this.x = x ;
		x_initialized = true; 
		return x;
	}	
		
	@dataType("character varying(11)")
	@:isVar public var y(get,set):String;
	var y_initialized:Bool;
	
	function get_y():String{
		return y;
	}

	function set_y(y:String):String{
		if(y_initialized)
			modified('y');
		this.y = y ;
		y_initialized = true; 
		return y;
	}	
		
	@dataType("character varying(22)")
	@:isVar public var z(get,set):String;
	var z_initialized:Bool;
	
	function get_z():String{
		return z;
	}

	function set_z(z:String):String{
		if(z_initialized)
			modified('z');
		this.z = z ;
		z_initialized = true; 
		return z;
	}	
		
	@dataType("bigint")
	@:isVar public var aa(get,set):Int;
	var aa_initialized:Bool;
	
	function get_aa():Int{
		return aa;
	}

	function set_aa(aa:Int):Int{
		if(aa_initialized)
			modified('aa');
		this.aa = aa ;
		aa_initialized = true; 
		return aa;
	}	
		
	@dataType("smallint")
	@:isVar public var processed(get,set):Int;
	var processed_initialized:Bool;
	
	function get_processed():Int{
		return processed;
	}

	function set_processed(processed:Int):Int{
		if(processed_initialized)
			modified('processed');
		this.processed = processed ;
		processed_initialized = true; 
		return processed;
	}	
		
	@dataType("bigint")
	@:isVar public var id(get,set):Int;
	var id_initialized:Bool;
	
	function get_id():Int{
		return id;
	}

	function set_id(id:Int):Int{
		if(id_initialized)
			modified('id');
		this.id = id ;
		id_initialized = true; 
		return id;
	}	
		
	@dataType("bigint")
	@:isVar public var edited_by(get,set):Int;
	var edited_by_initialized:Bool;
	
	function get_edited_by():Int{
		return edited_by;
	}

	function set_edited_by(edited_by:Int):Int{
		if(edited_by_initialized)
			modified('edited_by');
		this.edited_by = edited_by ;
		edited_by_initialized = true; 
		return edited_by;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(get,set):Int;
	var mandator_initialized:Bool;
	
	function get_mandator():Int{
		return mandator;
	}

	function set_mandator(mandator:Int):Int{
		if(mandator_initialized)
			modified('mandator');
		this.mandator = mandator ;
		mandator_initialized = true; 
		return mandator;
	}	
	
}