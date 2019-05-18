package view.model;
typedef EndReason = 
{
	//{"name":"id","type":"bigint","default":"","attnum":"1","required":false}
	?id:Int,
	//{"name":"reason","type":"character varying(64)","default":"","attnum":"2","required":true}
	reason:String,
	//{"name":"edited_by","type":"bigint","default":"","attnum":"3","required":true}
	edited_by:Int,
	//{"name":"mandator","type":"bigint","default":"","attnum":"4","required":true}
	mandator:Int
}