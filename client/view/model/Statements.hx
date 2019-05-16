package view.model;
typedef Statements = 
{
  a:Int,//{"name":"a","type":"bigint","default":"","attnum":"1","required":true}
	b:Int,//{"name":"b","type":"bigint","default":"","attnum":"2","required":true}
	c:String,//{"name":"c","type":"date","default":"","attnum":"3","required":true}
	d:String,//{"name":"d","type":"date","default":"","attnum":"4","required":true}
	e:String,//{"name":"e","type":"double precision","default":"","attnum":"5","required":true}
	f:String,//{"name":"f","type":"character varying(3)","default":"''::character varying","attnum":"6","required":true}
	?g:Int,//{"name":"g","type":"bigint","default":"","attnum":"7","required":false}
	h:String,//{"name":"h","type":"character varying(160)","default":"''::character varying","attnum":"8","required":true}
	i:String,//{"name":"i","type":"character varying(160)","default":"''::character varying","attnum":"9","required":true}
	j:String,//{"name":"j","type":"character varying(160)","default":"''::character varying","attnum":"10","required":true}
	k:String,//{"name":"k","type":"character varying(160)","default":"''::character varying","attnum":"11","required":true}
	l:String,//{"name":"l","type":"character varying(160)","default":"''::character varying","attnum":"12","required":true}
	m:String,//{"name":"m","type":"character varying(160)","default":"''::character varying","attnum":"13","required":true}
	n:String,//{"name":"n","type":"character varying(32)","default":"''::character varying","attnum":"14","required":true}
	o:String,//{"name":"o","type":"character varying(32)","default":"''::character varying","attnum":"15","required":true}
	p:String,//{"name":"p","type":"character varying(32)","default":"''::character varying","attnum":"16","required":true}
	q:String,//{"name":"q","type":"character varying(64)","default":"''::character varying","attnum":"17","required":true}
	r:String,//{"name":"r","type":"character varying(32)","default":"''::character varying","attnum":"18","required":true}
	s:String,//{"name":"s","type":"character varying(32)","default":"''::character varying","attnum":"19","required":true}
	t:String,//{"name":"t","type":"character varying(32)","default":"''::character varying","attnum":"20","required":true}
	u:String,//{"name":"u","type":"character varying(32)","default":"''::character varying","attnum":"21","required":true}
	v:String,//{"name":"v","type":"character varying(32)","default":"''::character varying","attnum":"22","required":true}
	w:String,//{"name":"w","type":"character varying(28)","default":"''::character varying","attnum":"23","required":true}
	x:String,//{"name":"x","type":"character varying(32)","default":"''::character varying","attnum":"24","required":true}
	y:String,//{"name":"y","type":"character varying(11)","default":"''::character varying","attnum":"25","required":true}
	z:String,//{"name":"z","type":"character varying(22)","default":"''::character varying","attnum":"26","required":true}
	?aa:Int,//{"name":"aa","type":"bigint","default":"","attnum":"27","required":false}
	processed:Int,//{"name":"processed","type":"smallint","default":"'0'::smallint","attnum":"28","required":true}
	id:Int,//{"name":"id","type":"bigint","default":"nextval('statements_id_seq'::regclass)","attnum":"29","required":true}
	edited_by:Int//{"name":"edited_by","type":"bigint","default":"","attnum":"30","required":true}
}