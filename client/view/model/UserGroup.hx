package view.model;
typedef UserGroup = 
{
	//{"name":"id","type":"bigint","default":"nextval('user_groups_id_seq'::regclass)","attnum":"1","required":true}
	id:Int,
	//{"name":"name","type":"character varying(64)","default":"","attnum":"2","required":true}
	name:String,
	//{"name":"description","type":"character varying(1024)","default":"","attnum":"3","required":false}
	?description:String,
	//{"name":"can","type":"jsonb","default":"'{}'::jsonb","attnum":"4","required":false}
	?can:String,
	//{"name":"mandator","type":"bigint","default":"","attnum":"5","required":true}
	mandator:Int,
	//{"name":"edited_by","type":"bigint","default":"","attnum":"6","required":true}
	edited_by:Int
}