package view.model;
typedef External_relations = 
{
  id:Int,//{"name":"id","type":"bigint","default":"nextval('external_relation_id_seq'::regclass)","attnum":"1","required":true}
	?name:String,//{"name":"name","type":"character varying","default":"''::character varying","attnum":"2","required":false}
	?url:String,//{"name":"url","type":"character varying","default":"","attnum":"3","required":false}
	?mandator:Int,//{"name":"mandator","type":"bigint","default":"","attnum":"4","required":false}
	?detail:String//{"name":"detail","type":"jsonb","default":"'{}'::jsonb","attnum":"5","required":false}
}