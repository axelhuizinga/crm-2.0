package model;
typedef Statement = 
{
	//{"name":"a","type":"bigint","default":"","attnum":"1","required":true}
	a:Int,
	//{"name":"b","type":"bigint","default":"","attnum":"2","required":true}
	b:Int,
	//{"name":"c","type":"date","default":"","attnum":"3","required":true}
	c:String,
	//{"name":"d","type":"date","default":"","attnum":"4","required":true}
	d:String,
	//{"name":"e","type":"double precision","default":"","attnum":"5","required":true}
	e:String,
	//{"name":"f","type":"character varying(3)","default":"''::character varying","attnum":"6","required":true}
	f:String,
	//{"name":"g","type":"bigint","default":"","attnum":"7","required":false}
	?g:Int,
	//{"name":"h","type":"character varying(160)","default":"''::character varying","attnum":"8","required":true}
	h:String,
	//{"name":"i","type":"character varying(160)","default":"''::character varying","attnum":"9","required":true}
	i:String,
	//{"name":"j","type":"character varying(160)","default":"''::character varying","attnum":"10","required":true}
	j:String,
	//{"name":"k","type":"character varying(160)","default":"''::character varying","attnum":"11","required":true}
	k:String,
	//{"name":"l","type":"character varying(160)","default":"''::character varying","attnum":"12","required":true}
	l:String,
	//{"name":"m","type":"character varying(160)","default":"''::character varying","attnum":"13","required":true}
	m:String,
	//{"name":"n","type":"character varying(32)","default":"''::character varying","attnum":"14","required":true}
	n:String,
	//{"name":"o","type":"character varying(32)","default":"''::character varying","attnum":"15","required":true}
	o:String,
	//{"name":"p","type":"character varying(32)","default":"''::character varying","attnum":"16","required":true}
	p:String,
	//{"name":"q","type":"character varying(64)","default":"''::character varying","attnum":"17","required":true}
	q:String,
	//{"name":"r","type":"character varying(32)","default":"''::character varying","attnum":"18","required":true}
	r:String,
	//{"name":"s","type":"character varying(32)","default":"''::character varying","attnum":"19","required":true}
	s:String,
	//{"name":"t","type":"character varying(32)","default":"''::character varying","attnum":"20","required":true}
	t:String,
	//{"name":"u","type":"character varying(32)","default":"''::character varying","attnum":"21","required":true}
	u:String,
	//{"name":"v","type":"character varying(32)","default":"''::character varying","attnum":"22","required":true}
	v:String,
	//{"name":"w","type":"character varying(28)","default":"''::character varying","attnum":"23","required":true}
	w:String,
	//{"name":"x","type":"character varying(32)","default":"''::character varying","attnum":"24","required":true}
	x:String,
	//{"name":"y","type":"character varying(11)","default":"''::character varying","attnum":"25","required":true}
	y:String,
	//{"name":"z","type":"character varying(22)","default":"''::character varying","attnum":"26","required":true}
	z:String,
	//{"name":"aa","type":"bigint","default":"","attnum":"27","required":false}
	?aa:Int,
	//{"name":"processed","type":"smallint","default":"'0'::smallint","attnum":"28","required":true}
	processed:Int,
	//{"name":"id","type":"bigint","default":"nextval('statements_id_seq'::regclass)","attnum":"29","required":true}
	id:Int,
	//{"name":"edited_by","type":"bigint","default":"","attnum":"30","required":true}
	edited_by:Int
}