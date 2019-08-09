package model;
typedef User = 
{
	//{"name":"id","type":"bigint","default":"nextval('users_id_seq'::regclass)","attnum":"1","required":true}
	id:Int,
	//{"name":"contact","type":"bigint","default":"0","attnum":"2","required":true}
	contact:Int,
	//{"name":"last_login","type":"timestamp(0) without time zone","default":"","attnum":"3","required":false}
	?last_login:String,
	//{"name":"password","type":"character varying(512)","default":"","attnum":"4","required":false}
	?password:String,
	//{"name":"id","type":"character varying(64)","default":"","attnum":"5","required":true}
	user_name:String,
	//{"name":"active","type":"boolean","default":"true","attnum":"6","required":false}
	?active:String,
	//{"name":"edited_by","type":"bigint","default":"","attnum":"7","required":false}
	?edited_by:Int,
	//{"name":"editing","type":"jsonb","default":"'{}'::jsonb","attnum":"8","required":false}
	?editing:String,
	//{"name":"settings","type":"jsonb","default":"'{}'::jsonb","attnum":"9","required":false}
	?settings:String,
	//{"name":"external","type":"jsonb","default":"'{}'::jsonb","attnum":"10","required":false}
	?external:String,
	//{"name":"user_group","type":"bigint","default":"","attnum":"11","required":false}
	?user_group:Int,
	//{"name":"change_pass_required","type":"boolean","default":"false","attnum":"12","required":false}
	?change_pass_required:String,
	//{"name":"online","type":"boolean","default":"false","attnum":"13","required":false}
	?online:String,
	//{"name":"last_request_time","type":"timestamp without time zone","default":"","attnum":"14","required":false}
	?last_request_time:String,
	//{"name":"request","type":"character varying(4096)","default":"''::character varying","attnum":"15","required":false}
	?request:String,
	//{"name":"mandator","type":"bigint","default":"0","attnum":"16","required":true}
	mandator:Int
}