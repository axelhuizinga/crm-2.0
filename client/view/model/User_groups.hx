package view.model;
typedef User_groups = 
{
  id:Int,//{"name":"id","type":"bigint","default":"nextval('user_groups_id_seq'::regclass)","attnum":"1","required":true}
	name:String,//{"name":"name","type":"character varying(64)","default":"","attnum":"2","required":true}
	?description:String,//{"name":"description","type":"character varying(1024)","default":"","attnum":"3","required":false}
	?can:String,//{"name":"can","type":"jsonb","default":"'{}'::jsonb","attnum":"4","required":false}
	mandator:Int,//{"name":"mandator","type":"bigint","default":"","attnum":"5","required":true}
	edited_by:Int//{"name":"edited_by","type":"bigint","default":"","attnum":"6","required":true}
}