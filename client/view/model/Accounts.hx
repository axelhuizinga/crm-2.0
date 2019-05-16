package view.model;
typedef Accounts = 
{
  id:Int,//{"name":"id","type":"bigint","default":"nextval('accounts_id_seq'::regclass)","attnum":"1","required":true}
	contact:Int,//{"name":"contact","type":"bigint","default":"","attnum":"2","required":true}
	owner:String,//{"name":"owner","type":"character varying(64)","default":"","attnum":"3","required":true}
	bank_name:String,//{"name":"bank_name","type":"character varying(64)","default":"","attnum":"4","required":true}
	?bic:String,//{"name":"bic","type":"character varying(11)","default":"''::character varying","attnum":"5","required":false}
	?account:String,//{"name":"account","type":"character varying(32)","default":"''::character varying","attnum":"6","required":false}
	?blz:String,//{"name":"blz","type":"character varying(12)","default":"''::character varying","attnum":"7","required":false}
	iban:String,//{"name":"iban","type":"character varying(32)","default":"","attnum":"8","required":true}
	creditor:Int,//{"name":"creditor","type":"bigint","default":"","attnum":"9","required":true}
	?sign_date:String,//{"name":"sign_date","type":"date","default":"","attnum":"10","required":false}
	?state:String,//{"name":"state","type":"accounts_state","default":"'new'::accounts_state","attnum":"11","required":false}
	?creation_date:String,//{"name":"creation_date","type":"timestamp with time zone","default":"now()","attnum":"12","required":false}
	edited_by:Int//{"name":"edited_by","type":"bigint","default":"","attnum":"13","required":true}
}