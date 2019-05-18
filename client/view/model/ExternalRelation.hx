package view.model;
typedef ExternalRelation = 
{
	//{"name":"id","type":"bigint","default":"nextval('external_relation_id_seq'::regclass)","attnum":"1","required":true}
	id:Int,
	//{"name":"name","type":"character varying","default":"''::character varying","attnum":"2","required":false}
	?name:String,
	//{"name":"url","type":"character varying","default":"","attnum":"3","required":false}
	?url:String,
	//{"name":"mandator","type":"bigint","default":"","attnum":"4","required":false}
	?mandator:Int,
	//{"name":"detail","type":"jsonb","default":"'{}'::jsonb","attnum":"5","required":false}
	?detail:String
}