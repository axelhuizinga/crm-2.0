package shared.model;
typedef Project = 
{
	//{"name":"id","type":"bigint","default":"nextval('projects_id_seq'::regclass)","attnum":"1","required":true}
	id:Int,
	//{"name":"mandator","type":"bigint","default":"","attnum":"2","required":true}
	mandator:Int,
	//{"name":"name","type":"character varying(64)","default":"","attnum":"3","required":true}
	name:String,
	//{"name":"description","type":"character varying(4096)","default":"","attnum":"4","required":false}
	?description:String,
	//{"name":"edited_by","type":"bigint","default":"","attnum":"5","required":true}
	edited_by:Int,
	//{"name":"provision_percent","type":"double precision","default":"(0.0)::double precision","attnum":"6","required":false}
	?provision_percent:String,
	//{"name":"cancellation_liable","type":"integer","default":"0","attnum":"7","required":false}
	?cancellation_liable:String
}