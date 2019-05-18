package view.model;
typedef Mandator = 
{
	//{"name":"id","type":"bigint","default":"nextval('mandators_id_seq'::regclass)","attnum":"1","required":true}
	id:Int,
	//{"name":"contact","type":"bigint","default":"","attnum":"2","required":true}
	contact:Int,
	//{"name":"name","type":"character varying(64)","default":"","attnum":"3","required":true}
	name:String,
	//{"name":"description","type":"character varying(4096)","default":"","attnum":"4","required":false}
	?description:String,
	//{"name":"any","type":"jsonb","default":"'{}'::jsonb","attnum":"5","required":false}
	?any:String,
	//{"name":"edited_by","type":"bigint","default":"","attnum":"6","required":true}
	edited_by:Int
}