package view.model;
typedef End_reasons = 
{
  ?id:Int,//{"name":"id","type":"bigint","default":"","attnum":"1","required":false}
	reason:String,//{"name":"reason","type":"character varying(64)","default":"","attnum":"2","required":true}
	edited_by:Int,//{"name":"edited_by","type":"bigint","default":"","attnum":"3","required":true}
	mandator:Int//{"name":"mandator","type":"bigint","default":"","attnum":"4","required":true}
}