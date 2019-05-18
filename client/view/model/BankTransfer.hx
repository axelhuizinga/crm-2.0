package view.model;
typedef BankTransfer = 
{
	//{"name":"ag_name","type":"character varying(64)","default":"","attnum":"1","required":true}
	ag_name:String,
	//{"name":"ag_konto_or_iban","type":"character varying(18)","default":"","attnum":"2","required":true}
	ag_konto_or_iban:String,
	//{"name":"ag_blz_or_bic","type":"character varying(11)","default":"","attnum":"3","required":true}
	ag_blz_or_bic:String,
	//{"name":"zahlpfl_name","type":"character varying(21)","default":"","attnum":"4","required":true}
	zahlpfl_name:String,
	//{"name":"zahlpfl_name2","type":"character varying(32)","default":"''::character varying","attnum":"5","required":true}
	zahlpfl_name2:String,
	//{"name":"zahlpfl_strasse","type":"character varying(32)","default":"","attnum":"6","required":true}
	zahlpfl_strasse:String,
	//{"name":"zahlpfl_name_ort","type":"character varying(32)","default":"","attnum":"7","required":true}
	zahlpfl_name_ort:String,
	//{"name":"zahlpfl_name_kto_or_iban","type":"character varying(22)","default":"","attnum":"8","required":true}
	zahlpfl_name_kto_or_iban:String,
	//{"name":"zahlpfl_name_blz_or_bic","type":"character varying(11)","default":"''::character varying","attnum":"9","required":true}
	zahlpfl_name_blz_or_bic:String,
	//{"name":"betrag","type":"double precision","default":"","attnum":"10","required":false}
	?betrag:String,
	//{"name":"currency","type":"character varying(32)","default":"'\u20ac'::character varying","attnum":"11","required":false}
	?currency:String,
	//{"name":"zahlart","type":"character varying(5)","default":"'BASIS'::character varying","attnum":"12","required":true}
	zahlart:String,
	//{"name":"termin","type":"date","default":"","attnum":"13","required":true}
	termin:String,
	//{"name":"vwz1","type":"character varying(22)","default":"''::character varying","attnum":"14","required":false}
	?vwz1:String,
	//{"name":"vwz2","type":"character varying(64)","default":"''::character varying","attnum":"15","required":false}
	?vwz2:String,
	//{"name":"vwz3","type":"character varying(64)","default":"''::character varying","attnum":"16","required":false}
	?vwz3:String,
	//{"name":"vwz4","type":"character varying(32)","default":"''::character varying","attnum":"17","required":false}
	?vwz4:String,
	//{"name":"vwz5","type":"character varying(32)","default":"''::character varying","attnum":"18","required":false}
	?vwz5:String,
	//{"name":"vwz6","type":"character varying(32)","default":"''::character varying","attnum":"19","required":false}
	?vwz6:String,
	//{"name":"vwz7","type":"character varying(32)","default":"''::character varying","attnum":"20","required":false}
	?vwz7:String,
	//{"name":"vwz8","type":"character varying(32)","default":"''::character varying","attnum":"21","required":false}
	?vwz8:String,
	//{"name":"vwz9","type":"character varying(32)","default":"''::character varying","attnum":"22","required":false}
	?vwz9:String,
	//{"name":"ba_id","type":"bigint","default":"nextval('bank_transfers_buchungsanforderungid_seq'::regclass)","attnum":"23","required":true}
	ba_id:Int,
	//{"name":"tracking_status","type":"bank_transfers_tracking_status","default":"'neu'::bank_transfers_tracking_status","attnum":"24","required":true}
	tracking_status:String,
	//{"name":"anforderungs_datum","type":"date","default":"","attnum":"25","required":true}
	anforderungs_datum:String,
	//{"name":"rueck_datum","type":"date","default":"","attnum":"26","required":true}
	rueck_datum:String,
	//{"name":"cycle","type":"character varying(32)","default":"","attnum":"27","required":true}
	cycle:String,
	//{"name":"ref_id","type":"character varying(32)","default":"","attnum":"28","required":true}
	ref_id:String,
	//{"name":"mandat_id","type":"character varying(11)","default":"","attnum":"29","required":true}
	mandat_id:String,
	//{"name":"mandat_datum","type":"date","default":"","attnum":"30","required":true}
	mandat_datum:String,
	//{"name":"ag_creditor_id","type":"character varying(18)","default":"","attnum":"31","required":true}
	ag_creditor_id:String,
	//{"name":"sequenz","type":"character varying(4)","default":"","attnum":"32","required":true}
	sequenz:String,
	//{"name":"super_ag_name","type":"character varying(32)","default":"","attnum":"33","required":true}
	super_ag_name:String,
	//{"name":"edited_by","type":"bigint","default":"","attnum":"34","required":true}
	edited_by:Int
}