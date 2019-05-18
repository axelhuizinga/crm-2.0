package view.model;
typedef ViewComponent = 
{
	//{"name":"id","type":"bigint","default":"nextval('view_components_id_seq'::regclass)","attnum":"1","required":true}
	id:Int,
	//{"name":"component","type":"character varying(64)","default":"","attnum":"2","required":true}
	component:String,
	//{"name":"title","type":"character varying(64)","default":"","attnum":"3","required":true}
	title:String,
	//{"name":"description","type":"character varying(2048)","default":"","attnum":"4","required":true}
	description:String,
	//{"name":"active","type":"smallint","default":"'1'::smallint","attnum":"5","required":true}
	active:Int,
	//{"name":"edited_by","type":"bigint","default":"","attnum":"6","required":true}
	edited_by:Int
}