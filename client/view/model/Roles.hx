package view.model;
typedef Roles = 
{
  id:Int,//{"name":"id","type":"bigint","default":"nextval('roles_id_seq'::regclass)","attnum":"1","required":true}
	name:String,//{"name":"name","type":"character varying(64)","default":"","attnum":"2","required":true}
	?description:String,//{"name":"description","type":"character varying(2048)","default":"''::character varying","attnum":"3","required":false}
	permissions:String,//{"name":"permissions","type":"jsonb","default":"'{\"users\": [], \"groups\": [], \"routes\": []}'::jsonb","attnum":"4","required":true}
	edited_by:Int,//{"name":"edited_by","type":"bigint","default":"","attnum":"5","required":true}
	mandator:Int//{"name":"mandator","type":"bigint","default":"","attnum":"6","required":true}
}