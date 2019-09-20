package model;
typedef Contact = 
{
	//{"name":"id","type":"bigint","default":"nextval('contacts_id_seq'::regclass)","attnum":"1","required":true}
	?id:Int,
	//{"name":"mandator","type":"bigint","default":"","attnum":"2","required":true}
	mandator:Int,
	//{"name":"creation_date","type":"timestamp with time zone","default":"now()","attnum":"3","required":false}
	?creation_date:String,
	//{"name":"state","type":"contacts_state","default":"'active'::contacts_state","attnum":"4","required":false}
	?state:String,
	//{"name":"use_email","type":"smallint","default":"'0'::smallint","attnum":"5","required":false}
	?use_email:Int,
	//{"name":"company_name","type":"character varying(64)","default":"''::character varying","attnum":"6","required":false}
	?company_name:String,
	//{"name":"co_field","type":"character varying(100)","default":"''::character varying","attnum":"7","required":false}
	?co_field:String,
	//{"name":"phone_code","type":"character varying(10)","default":"49","attnum":"8","required":false}
	?phone_code:String,
	//{"name":"phone_number","type":"character varying(18)","default":"''::character varying","attnum":"9","required":false}
	?phone_number:String,
	//{"name":"fax","type":"character varying(18)","default":"''::character varying","attnum":"10","required":false}
	?fax:String,
	//{"name":"title","type":"character varying(64)","default":"''::character varying","attnum":"11","required":false}
	?title:String,
	//{"name":"title_2","type":"character varying(64)","default":"''::character varying","attnum":"12","required":false}
	?title_2:String,
	//{"name":"first_name","type":"character varying(32)","default":"''::character varying","attnum":"13","required":false}
	?first_name:String,
	//{"name":"last_name","type":"character varying(32)","default":"''::character varying","attnum":"14","required":false}
	?last_name:String,
	//{"name":"address","type":"character varying(32)","default":"''::character varying","attnum":"15","required":false}
	?address:String,
	//{"name":"address_2","type":"character varying(8)","default":"''::character varying","attnum":"16","required":false}
	?address_2:String,
	//{"name":"city","type":"character varying(50)","default":"''::character varying","attnum":"17","required":false}
	?city:String,
	//{"name":"plz","type":"character varying(10)","default":"''::character varying","attnum":"18","required":false}
	?plz:String,
	//{"name":"country_code","type":"character varying(3)","default":"''::character varying","attnum":"19","required":false}
	?country_code:String,
	//{"name":"gender","type":"contacts_gender","default":"''::contacts_gender","attnum":"20","required":false}
	?gender:String,
	//{"name":"date_of_birth","type":"date","default":"","attnum":"21","required":false}
	?date_of_birth:String,
	//{"name":"mobile","type":"character varying(19)","default":"''::character varying","attnum":"22","required":false}
	?mobile:String,
	//{"name":"email","type":"character varying(64)","default":"''::character varying","attnum":"23","required":false}
	?email:String,
	//{"name":"comment","type":"character varying(4096)","default":"''::character varying","attnum":"24","required":false}
	?comment:String,
	//{"name":"edited_by","type":"bigint","default":"","attnum":"25","required":true}
	edited_by:Int
}