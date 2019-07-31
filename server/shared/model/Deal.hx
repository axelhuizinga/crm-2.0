package shared.model;
typedef Deal = 
{
	//{"name":"id","type":"bigint","default":"nextval('deals_id_seq'::regclass)","attnum":"1","required":true}
	id:Int,
	//{"name":"contact","type":"bigint","default":"","attnum":"2","required":true}
	contact:Int,
	//{"name":"creation_date","type":"timestamp with time zone","default":"now()","attnum":"3","required":false}
	?creation_date:String,
	//{"name":"account","type":"bigint","default":"","attnum":"4","required":true}
	account:Int,
	//{"name":"target_account","type":"bigint","default":"","attnum":"5","required":true}
	target_account:Int,
	//{"name":"start_day","type":"deals_start_day","default":"'1'::deals_start_day","attnum":"6","required":false}
	?start_day:String,
	//{"name":"start_date","type":"date","default":"","attnum":"7","required":true}
	start_date:String,
	//{"name":"cycle","type":"deals_cycle","default":"","attnum":"8","required":true}
	cycle:String,
	//{"name":"value","type":"numeric(10,2)","default":"","attnum":"9","required":true}
	value:String,
	//{"name":"product","type":"bigint","default":"","attnum":"10","required":true}
	product:Int,
	//{"name":"agent","type":"character varying(20)","default":"","attnum":"11","required":true}
	agent:String,
	//{"name":"project","type":"bigint","default":"","attnum":"12","required":true}
	project:Int,
	//{"name":"status","type":"deals_status","default":"'active'::deals_status","attnum":"13","required":false}
	?status:String,
	//{"name":"pay_method","type":"deals_pay_method","default":"'debit'::deals_pay_method","attnum":"14","required":false}
	?pay_method:String,
	//{"name":"end_date","type":"date","default":"","attnum":"15","required":false}
	?end_date:String,
	//{"name":"end_reason","type":"bigint","default":"","attnum":"16","required":false}
	?end_reason:Int,
	//{"name":"repeat_date","type":"date","default":"","attnum":"17","required":false}
	?repeat_date:String,
	//{"name":"edited_by","type":"bigint","default":"","attnum":"18","required":true}
	edited_by:Int,
	//{"name":"mandator","type":"bigint","default":"","attnum":"2","required":true}
	mandator:Int
}