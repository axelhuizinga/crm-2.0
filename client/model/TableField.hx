package model;
typedef TableField = 
{
	//{"name":"id","type":"bigint","default":"nextval('external_relation_id_seq'::regclass)","attnum":"1","required":true}
	id:Int,
	//{"name":"table_name","type":"character varying","default":"''::character varying","attnum":"2","required":true}
	table_name:String,
	//{"name":"mandator","type":"bigint","default":"","attnum":"5","required":false}
	?mandator:Int,
	//{"name":"field_name","type":"character varying","default":"''::character varying","attnum":"6","required":true}
	field_name:String,
	//{"name":"readonly","type":"boolean","default":"false","attnum":"7","required":false}
	?readonly:String,
	//{"name":"element","type":"element","default":"'Input'::element","attnum":"8","required":false}
	?element:String,
	//{"name":"any","type":"jsonb","default":"'{}'::jsonb","attnum":"10","required":true}
	any:String,
	//{"name":"required","type":"boolean","default":"false","attnum":"11","required":false}
	?required:String,
	//{"name":"use_as_index","type":"boolean","default":"false","attnum":"12","required":false}
	?use_as_index:String,
	//{"name":"admin_only","type":"boolean","default":"false","attnum":"13","required":false}
	?admin_only:String,
	//{"name":"field_type","type":"data_type","default":"","attnum":"14","required":false}
	?field_type:String
}