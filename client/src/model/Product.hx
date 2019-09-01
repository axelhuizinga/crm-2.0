package model;
typedef Product = 
{
	//{"name":"id","type":"bigint","default":"nextval('products_id_seq'::regclass)","attnum":"1","required":true}
	id:Int,
	//{"name":"name","type":"character varying(1024)","default":"","attnum":"2","required":true}
	name:String,
	//{"name":"description","type":"character varying(4096)","default":"","attnum":"3","required":false}
	?description:String,
	//{"name":"value","type":"numeric(10,2)","default":"","attnum":"4","required":true}
	value:String,
	//{"name":"attributes","type":"jsonb","default":"'{}'::jsonb","attnum":"5","required":false}
	?attributes:String,
	//{"name":"mandator","type":"bigint","default":"","attnum":"6","required":true}
	mandator:Int,
	//{"name":"active","type":"smallint","default":"'1'::smallint","attnum":"7","required":false}
	?active:Int,
	//{"name":"edited_by","type":"bigint","default":"","attnum":"8","required":true}
	edited_by:Int
}