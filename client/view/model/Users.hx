package view.model;
typedef Users = 
{
  id:Int,//{"name":"id","type":"bigint","default":"nextval('users_id_seq'::regclass)","attnum":"1","required":true}
	contact:Int,//{"name":"contact","type":"bigint","default":"0","attnum":"2","required":true}
	?last_login:String,//{"name":"last_login","type":"timestamp(0) without time zone","default":"","attnum":"3","required":false}
	?password:String,//{"name":"password","type":"character varying(512)","default":"","attnum":"4","required":false}
	user_name:String,//{"name":"user_name","type":"character varying(64)","default":"","attnum":"5","required":true}
	?active:String,//{"name":"active","type":"boolean","default":"true","attnum":"6","required":false}
	?edited_by:Int,//{"name":"edited_by","type":"bigint","default":"","attnum":"7","required":false}
	?editing:String,//{"name":"editing","type":"jsonb","default":"'{}'::jsonb","attnum":"8","required":false}
	?settings:String,//{"name":"settings","type":"jsonb","default":"'{}'::jsonb","attnum":"9","required":false}
	?external:String,//{"name":"external","type":"jsonb","default":"'{}'::jsonb","attnum":"10","required":false}
	?user_group:Int,//{"name":"user_group","type":"bigint","default":"","attnum":"11","required":false}
	?change_pass_required:String,//{"name":"change_pass_required","type":"boolean","default":"false","attnum":"12","required":false}
	?online:String,//{"name":"online","type":"boolean","default":"false","attnum":"13","required":false}
	?last_request_time:String,//{"name":"last_request_time","type":"timestamp without time zone","default":"","attnum":"14","required":false}
	?request:String,//{"name":"request","type":"character varying(4096)","default":"''::character varying","attnum":"15","required":false}
	mandator:Int//{"name":"mandator","type":"bigint","default":"0","attnum":"16","required":true}
}