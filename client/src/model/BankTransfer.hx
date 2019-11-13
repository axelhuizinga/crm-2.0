package model;

typedef BankTransferProps = {
	?ag_name:String,
	?ag_konto_or_iban:String,
	?ag_blz_or_bic:String,
	?zahlpfl_name:String,
	?zahlpfl_name2:String,
	?zahlpfl_strasse:String,
	?zahlpfl_name_ort:String,
	?zahlpfl_name_kto_or_iban:String,
	?zahlpfl_name_blz_or_bic:String,
	?betrag:String,
	?currency:String,
	?zahlart:String,
	?termin:String,
	?vwz1:String,
	?vwz2:String,
	?vwz3:String,
	?vwz4:String,
	?vwz5:String,
	?vwz6:String,
	?vwz7:String,
	?vwz8:String,
	?vwz9:String,
	?ba_id:Int,
	?tracking_status:String,
	?anforderungs_datum:String,
	?rueck_datum:String,
	?cycle:String,
	?ref_id:String,
	?mandat_id:String,
	?mandat_datum:String,
	?ag_creditor_id:String,
	?sequenz:String,
	?super_ag_name:String,
	?edited_by:Int
};

class BankTransfer extends ORM
{
		public function new(props:BankTransferProps) {
		super(props);
		for(f in Reflect.fields(props))
		{
			Reflect.setField(this, f, Reflect.field(props, f));
		}
	}

	//{"type":"character varying(64)","default":"","attnum":"1"}
	@:isVar public var ag_name(get,set):String;
	var initial_ag_name:String;
	
	function get_ag_name():String{
		return ag_name;
	}

	function set_ag_name(x:String):String{

		modified('ag_name');
		ag_name = x;
		if(initial_ag_name == null)
			initial_ag_name = ag_name; 
		return ag_name;
	}

	public function reset_ag_name():String{
		return initial_ag_name;
	}

	public function clear_ag_name():String{
		ag_name = '';
		return ag_name;
	}

	//{"type":"character varying(18)","default":"","attnum":"2"}
	@:isVar public var ag_konto_or_iban(get,set):String;
	var initial_ag_konto_or_iban:String;
	
	function get_ag_konto_or_iban():String{
		return ag_konto_or_iban;
	}

	function set_ag_konto_or_iban(x:String):String{

		modified('ag_konto_or_iban');
		ag_konto_or_iban = x;
		if(initial_ag_konto_or_iban == null)
			initial_ag_konto_or_iban = ag_konto_or_iban; 
		return ag_konto_or_iban;
	}

	public function reset_ag_konto_or_iban():String{
		return initial_ag_konto_or_iban;
	}

	public function clear_ag_konto_or_iban():String{
		ag_konto_or_iban = '';
		return ag_konto_or_iban;
	}

	//{"type":"character varying(11)","default":"","attnum":"3"}
	@:isVar public var ag_blz_or_bic(get,set):String;
	var initial_ag_blz_or_bic:String;
	
	function get_ag_blz_or_bic():String{
		return ag_blz_or_bic;
	}

	function set_ag_blz_or_bic(x:String):String{

		modified('ag_blz_or_bic');
		ag_blz_or_bic = x;
		if(initial_ag_blz_or_bic == null)
			initial_ag_blz_or_bic = ag_blz_or_bic; 
		return ag_blz_or_bic;
	}

	public function reset_ag_blz_or_bic():String{
		return initial_ag_blz_or_bic;
	}

	public function clear_ag_blz_or_bic():String{
		ag_blz_or_bic = '';
		return ag_blz_or_bic;
	}

	//{"type":"character varying(21)","default":"","attnum":"4"}
	@:isVar public var zahlpfl_name(get,set):String;
	var initial_zahlpfl_name:String;
	
	function get_zahlpfl_name():String{
		return zahlpfl_name;
	}

	function set_zahlpfl_name(x:String):String{

		modified('zahlpfl_name');
		zahlpfl_name = x;
		if(initial_zahlpfl_name == null)
			initial_zahlpfl_name = zahlpfl_name; 
		return zahlpfl_name;
	}

	public function reset_zahlpfl_name():String{
		return initial_zahlpfl_name;
	}

	public function clear_zahlpfl_name():String{
		zahlpfl_name = '';
		return zahlpfl_name;
	}

	//{"type":"character varying(32)","default":"''","attnum":"5"}
	@:isVar public var zahlpfl_name2(get,set):String;
	var initial_zahlpfl_name2:String;
	
	function get_zahlpfl_name2():String{
		return zahlpfl_name2;
	}

	function set_zahlpfl_name2(x:String):String{

		modified('zahlpfl_name2');
		zahlpfl_name2 = x;
		if(initial_zahlpfl_name2 == null)
			initial_zahlpfl_name2 = zahlpfl_name2; 
		return zahlpfl_name2;
	}

	public function reset_zahlpfl_name2():String{
		return initial_zahlpfl_name2;
	}

	public function clear_zahlpfl_name2():String{
		zahlpfl_name2 = '''';
		return zahlpfl_name2;
	}

	//{"type":"character varying(32)","default":"","attnum":"6"}
	@:isVar public var zahlpfl_strasse(get,set):String;
	var initial_zahlpfl_strasse:String;
	
	function get_zahlpfl_strasse():String{
		return zahlpfl_strasse;
	}

	function set_zahlpfl_strasse(x:String):String{

		modified('zahlpfl_strasse');
		zahlpfl_strasse = x;
		if(initial_zahlpfl_strasse == null)
			initial_zahlpfl_strasse = zahlpfl_strasse; 
		return zahlpfl_strasse;
	}

	public function reset_zahlpfl_strasse():String{
		return initial_zahlpfl_strasse;
	}

	public function clear_zahlpfl_strasse():String{
		zahlpfl_strasse = '';
		return zahlpfl_strasse;
	}

	//{"type":"character varying(32)","default":"","attnum":"7"}
	@:isVar public var zahlpfl_name_ort(get,set):String;
	var initial_zahlpfl_name_ort:String;
	
	function get_zahlpfl_name_ort():String{
		return zahlpfl_name_ort;
	}

	function set_zahlpfl_name_ort(x:String):String{

		modified('zahlpfl_name_ort');
		zahlpfl_name_ort = x;
		if(initial_zahlpfl_name_ort == null)
			initial_zahlpfl_name_ort = zahlpfl_name_ort; 
		return zahlpfl_name_ort;
	}

	public function reset_zahlpfl_name_ort():String{
		return initial_zahlpfl_name_ort;
	}

	public function clear_zahlpfl_name_ort():String{
		zahlpfl_name_ort = '';
		return zahlpfl_name_ort;
	}

	//{"type":"character varying(22)","default":"","attnum":"8"}
	@:isVar public var zahlpfl_name_kto_or_iban(get,set):String;
	var initial_zahlpfl_name_kto_or_iban:String;
	
	function get_zahlpfl_name_kto_or_iban():String{
		return zahlpfl_name_kto_or_iban;
	}

	function set_zahlpfl_name_kto_or_iban(x:String):String{

		modified('zahlpfl_name_kto_or_iban');
		zahlpfl_name_kto_or_iban = x;
		if(initial_zahlpfl_name_kto_or_iban == null)
			initial_zahlpfl_name_kto_or_iban = zahlpfl_name_kto_or_iban; 
		return zahlpfl_name_kto_or_iban;
	}

	public function reset_zahlpfl_name_kto_or_iban():String{
		return initial_zahlpfl_name_kto_or_iban;
	}

	public function clear_zahlpfl_name_kto_or_iban():String{
		zahlpfl_name_kto_or_iban = '';
		return zahlpfl_name_kto_or_iban;
	}

	//{"type":"character varying(11)","default":"''","attnum":"9"}
	@:isVar public var zahlpfl_name_blz_or_bic(get,set):String;
	var initial_zahlpfl_name_blz_or_bic:String;
	
	function get_zahlpfl_name_blz_or_bic():String{
		return zahlpfl_name_blz_or_bic;
	}

	function set_zahlpfl_name_blz_or_bic(x:String):String{

		modified('zahlpfl_name_blz_or_bic');
		zahlpfl_name_blz_or_bic = x;
		if(initial_zahlpfl_name_blz_or_bic == null)
			initial_zahlpfl_name_blz_or_bic = zahlpfl_name_blz_or_bic; 
		return zahlpfl_name_blz_or_bic;
	}

	public function reset_zahlpfl_name_blz_or_bic():String{
		return initial_zahlpfl_name_blz_or_bic;
	}

	public function clear_zahlpfl_name_blz_or_bic():String{
		zahlpfl_name_blz_or_bic = '''';
		return zahlpfl_name_blz_or_bic;
	}

	//{"type":"double precision","default":"","attnum":"10"}
	@:isVar public var betrag(get,set):String;
	var initial_betrag:String;
	
	function get_betrag():String{
			return betrag;
	}

	function set_betrag(x:String):String{

		modified('betrag');
		betrag = x;
		if(initial_betrag == null)
			initial_betrag = betrag; 
		return betrag;
	}

	public function reset_betrag():String{
		return initial_betrag;
	}

	public function clear_betrag():String{
		betrag = '';
		return betrag;
	}

	//{"type":"character varying(32)","default":"'\u20ac'","attnum":"11"}
	@:isVar public var currency(get,set):String;
	var initial_currency:String;
	
	function get_currency():String{
		return currency;
	}

	function set_currency(x:String):String{

		modified('currency');
		currency = x;
		if(initial_currency == null)
			initial_currency = currency; 
		return currency;
	}

	public function reset_currency():String{
		return initial_currency;
	}

	public function clear_currency():String{
		currency = ''€'';
		return currency;
	}

	//{"type":"character varying(5)","default":"'BASIS'","attnum":"12"}
	@:isVar public var zahlart(get,set):String;
	var initial_zahlart:String;
	
	function get_zahlart():String{
		return zahlart;
	}

	function set_zahlart(x:String):String{

		modified('zahlart');
		zahlart = x;
		if(initial_zahlart == null)
			initial_zahlart = zahlart; 
		return zahlart;
	}

	public function reset_zahlart():String{
		return initial_zahlart;
	}

	public function clear_zahlart():String{
		zahlart = ''BASIS'';
		return zahlart;
	}

	//{"type":"date","default":"","attnum":"13"}
	@:isVar public var termin(get,set):String;
	var initial_termin:String;
	
	function get_termin():String{
			return termin;
	}

	function set_termin(x:String):String{

		modified('termin');
		termin = x;
		if(initial_termin == null)
			initial_termin = termin; 
		return termin;
	}

	public function reset_termin():String{
		return initial_termin;
	}

	public function clear_termin():String{
		termin = '';
		return termin;
	}

	//{"type":"character varying(22)","default":"''","attnum":"14"}
	@:isVar public var vwz1(get,set):String;
	var initial_vwz1:String;
	
	function get_vwz1():String{
		return vwz1;
	}

	function set_vwz1(x:String):String{

		modified('vwz1');
		vwz1 = x;
		if(initial_vwz1 == null)
			initial_vwz1 = vwz1; 
		return vwz1;
	}

	public function reset_vwz1():String{
		return initial_vwz1;
	}

	public function clear_vwz1():String{
		vwz1 = '''';
		return vwz1;
	}

	//{"type":"character varying(64)","default":"''","attnum":"15"}
	@:isVar public var vwz2(get,set):String;
	var initial_vwz2:String;
	
	function get_vwz2():String{
		return vwz2;
	}

	function set_vwz2(x:String):String{

		modified('vwz2');
		vwz2 = x;
		if(initial_vwz2 == null)
			initial_vwz2 = vwz2; 
		return vwz2;
	}

	public function reset_vwz2():String{
		return initial_vwz2;
	}

	public function clear_vwz2():String{
		vwz2 = '''';
		return vwz2;
	}

	//{"type":"character varying(64)","default":"''","attnum":"16"}
	@:isVar public var vwz3(get,set):String;
	var initial_vwz3:String;
	
	function get_vwz3():String{
		return vwz3;
	}

	function set_vwz3(x:String):String{

		modified('vwz3');
		vwz3 = x;
		if(initial_vwz3 == null)
			initial_vwz3 = vwz3; 
		return vwz3;
	}

	public function reset_vwz3():String{
		return initial_vwz3;
	}

	public function clear_vwz3():String{
		vwz3 = '''';
		return vwz3;
	}

	//{"type":"character varying(32)","default":"''","attnum":"17"}
	@:isVar public var vwz4(get,set):String;
	var initial_vwz4:String;
	
	function get_vwz4():String{
		return vwz4;
	}

	function set_vwz4(x:String):String{

		modified('vwz4');
		vwz4 = x;
		if(initial_vwz4 == null)
			initial_vwz4 = vwz4; 
		return vwz4;
	}

	public function reset_vwz4():String{
		return initial_vwz4;
	}

	public function clear_vwz4():String{
		vwz4 = '''';
		return vwz4;
	}

	//{"type":"character varying(32)","default":"''","attnum":"18"}
	@:isVar public var vwz5(get,set):String;
	var initial_vwz5:String;
	
	function get_vwz5():String{
		return vwz5;
	}

	function set_vwz5(x:String):String{

		modified('vwz5');
		vwz5 = x;
		if(initial_vwz5 == null)
			initial_vwz5 = vwz5; 
		return vwz5;
	}

	public function reset_vwz5():String{
		return initial_vwz5;
	}

	public function clear_vwz5():String{
		vwz5 = '''';
		return vwz5;
	}

	//{"type":"character varying(32)","default":"''","attnum":"19"}
	@:isVar public var vwz6(get,set):String;
	var initial_vwz6:String;
	
	function get_vwz6():String{
		return vwz6;
	}

	function set_vwz6(x:String):String{

		modified('vwz6');
		vwz6 = x;
		if(initial_vwz6 == null)
			initial_vwz6 = vwz6; 
		return vwz6;
	}

	public function reset_vwz6():String{
		return initial_vwz6;
	}

	public function clear_vwz6():String{
		vwz6 = '''';
		return vwz6;
	}

	//{"type":"character varying(32)","default":"''","attnum":"20"}
	@:isVar public var vwz7(get,set):String;
	var initial_vwz7:String;
	
	function get_vwz7():String{
		return vwz7;
	}

	function set_vwz7(x:String):String{

		modified('vwz7');
		vwz7 = x;
		if(initial_vwz7 == null)
			initial_vwz7 = vwz7; 
		return vwz7;
	}

	public function reset_vwz7():String{
		return initial_vwz7;
	}

	public function clear_vwz7():String{
		vwz7 = '''';
		return vwz7;
	}

	//{"type":"character varying(32)","default":"''","attnum":"21"}
	@:isVar public var vwz8(get,set):String;
	var initial_vwz8:String;
	
	function get_vwz8():String{
		return vwz8;
	}

	function set_vwz8(x:String):String{

		modified('vwz8');
		vwz8 = x;
		if(initial_vwz8 == null)
			initial_vwz8 = vwz8; 
		return vwz8;
	}

	public function reset_vwz8():String{
		return initial_vwz8;
	}

	public function clear_vwz8():String{
		vwz8 = '''';
		return vwz8;
	}

	//{"type":"character varying(32)","default":"''","attnum":"22"}
	@:isVar public var vwz9(get,set):String;
	var initial_vwz9:String;
	
	function get_vwz9():String{
		return vwz9;
	}

	function set_vwz9(x:String):String{

		modified('vwz9');
		vwz9 = x;
		if(initial_vwz9 == null)
			initial_vwz9 = vwz9; 
		return vwz9;
	}

	public function reset_vwz9():String{
		return initial_vwz9;
	}

	public function clear_vwz9():String{
		vwz9 = '''';
		return vwz9;
	}

	//{"type":"bigint","default":"nextval('bank_transfers_buchungsanforderungid_seq'","attnum":"23"}
	@:isVar public var ba_id(get,set):Int;
	var initial_ba_id:Int;
	
	function get_ba_id():Int{
		return ba_id;
	}

	function set_ba_id(x:Int):Int{

		modified('ba_id');
		ba_id = x;
		if(initial_ba_id == null)
			initial_ba_id = ba_id; 
		return ba_id;
	}

	public function reset_ba_id():Int{
		return initial_ba_id;
	}

	public function clear_ba_id():Int{
		ba_id = 'nextval('bank_transfers_buchungsanforderungid_seq'';
		return ba_id;
	}

	//{"type":"bank_transfers_tracking_status","default":"'neu'","attnum":"24"}
	@:isVar public var tracking_status(get,set):String;
	var initial_tracking_status:String;
	
	function get_tracking_status():String{
			return tracking_status;
	}

	function set_tracking_status(x:String):String{

		modified('tracking_status');
		tracking_status = x;
		if(initial_tracking_status == null)
			initial_tracking_status = tracking_status; 
		return tracking_status;
	}

	public function reset_tracking_status():String{
		return initial_tracking_status;
	}

	public function clear_tracking_status():String{
		tracking_status = ''neu'';
		return tracking_status;
	}

	//{"type":"date","default":"","attnum":"25"}
	@:isVar public var anforderungs_datum(get,set):String;
	var initial_anforderungs_datum:String;
	
	function get_anforderungs_datum():String{
			return anforderungs_datum;
	}

	function set_anforderungs_datum(x:String):String{

		modified('anforderungs_datum');
		anforderungs_datum = x;
		if(initial_anforderungs_datum == null)
			initial_anforderungs_datum = anforderungs_datum; 
		return anforderungs_datum;
	}

	public function reset_anforderungs_datum():String{
		return initial_anforderungs_datum;
	}

	public function clear_anforderungs_datum():String{
		anforderungs_datum = '';
		return anforderungs_datum;
	}

	//{"type":"date","default":"","attnum":"26"}
	@:isVar public var rueck_datum(get,set):String;
	var initial_rueck_datum:String;
	
	function get_rueck_datum():String{
			return rueck_datum;
	}

	function set_rueck_datum(x:String):String{

		modified('rueck_datum');
		rueck_datum = x;
		if(initial_rueck_datum == null)
			initial_rueck_datum = rueck_datum; 
		return rueck_datum;
	}

	public function reset_rueck_datum():String{
		return initial_rueck_datum;
	}

	public function clear_rueck_datum():String{
		rueck_datum = '';
		return rueck_datum;
	}

	//{"type":"character varying(32)","default":"","attnum":"27"}
	@:isVar public var cycle(get,set):String;
	var initial_cycle:String;
	
	function get_cycle():String{
		return cycle;
	}

	function set_cycle(x:String):String{

		modified('cycle');
		cycle = x;
		if(initial_cycle == null)
			initial_cycle = cycle; 
		return cycle;
	}

	public function reset_cycle():String{
		return initial_cycle;
	}

	public function clear_cycle():String{
		cycle = '';
		return cycle;
	}

	//{"type":"character varying(32)","default":"","attnum":"28"}
	@:isVar public var ref_id(get,set):String;
	var initial_ref_id:String;
	
	function get_ref_id():String{
		return ref_id;
	}

	function set_ref_id(x:String):String{

		modified('ref_id');
		ref_id = x;
		if(initial_ref_id == null)
			initial_ref_id = ref_id; 
		return ref_id;
	}

	public function reset_ref_id():String{
		return initial_ref_id;
	}

	public function clear_ref_id():String{
		ref_id = '';
		return ref_id;
	}

	//{"type":"character varying(11)","default":"","attnum":"29"}
	@:isVar public var mandat_id(get,set):String;
	var initial_mandat_id:String;
	
	function get_mandat_id():String{
		return mandat_id;
	}

	function set_mandat_id(x:String):String{

		modified('mandat_id');
		mandat_id = x;
		if(initial_mandat_id == null)
			initial_mandat_id = mandat_id; 
		return mandat_id;
	}

	public function reset_mandat_id():String{
		return initial_mandat_id;
	}

	public function clear_mandat_id():String{
		mandat_id = '';
		return mandat_id;
	}

	//{"type":"date","default":"","attnum":"30"}
	@:isVar public var mandat_datum(get,set):String;
	var initial_mandat_datum:String;
	
	function get_mandat_datum():String{
			return mandat_datum;
	}

	function set_mandat_datum(x:String):String{

		modified('mandat_datum');
		mandat_datum = x;
		if(initial_mandat_datum == null)
			initial_mandat_datum = mandat_datum; 
		return mandat_datum;
	}

	public function reset_mandat_datum():String{
		return initial_mandat_datum;
	}

	public function clear_mandat_datum():String{
		mandat_datum = '';
		return mandat_datum;
	}

	//{"type":"character varying(18)","default":"","attnum":"31"}
	@:isVar public var ag_creditor_id(get,set):String;
	var initial_ag_creditor_id:String;
	
	function get_ag_creditor_id():String{
		return ag_creditor_id;
	}

	function set_ag_creditor_id(x:String):String{

		modified('ag_creditor_id');
		ag_creditor_id = x;
		if(initial_ag_creditor_id == null)
			initial_ag_creditor_id = ag_creditor_id; 
		return ag_creditor_id;
	}

	public function reset_ag_creditor_id():String{
		return initial_ag_creditor_id;
	}

	public function clear_ag_creditor_id():String{
		ag_creditor_id = '';
		return ag_creditor_id;
	}

	//{"type":"character varying(4)","default":"","attnum":"32"}
	@:isVar public var sequenz(get,set):String;
	var initial_sequenz:String;
	
	function get_sequenz():String{
		return sequenz;
	}

	function set_sequenz(x:String):String{

		modified('sequenz');
		sequenz = x;
		if(initial_sequenz == null)
			initial_sequenz = sequenz; 
		return sequenz;
	}

	public function reset_sequenz():String{
		return initial_sequenz;
	}

	public function clear_sequenz():String{
		sequenz = '';
		return sequenz;
	}

	//{"type":"character varying(32)","default":"","attnum":"33"}
	@:isVar public var super_ag_name(get,set):String;
	var initial_super_ag_name:String;
	
	function get_super_ag_name():String{
		return super_ag_name;
	}

	function set_super_ag_name(x:String):String{

		modified('super_ag_name');
		super_ag_name = x;
		if(initial_super_ag_name == null)
			initial_super_ag_name = super_ag_name; 
		return super_ag_name;
	}

	public function reset_super_ag_name():String{
		return initial_super_ag_name;
	}

	public function clear_super_ag_name():String{
		super_ag_name = '';
		return super_ag_name;
	}

	//{"type":"bigint","default":0,"attnum":"34"}
	@:isVar public var edited_by(get,set):Int;
	var initial_edited_by:Int;
	
	function get_edited_by():Int{
		return edited_by;
	}

	function set_edited_by(x:Int):Int{

		modified('edited_by');
		edited_by = x;
		if(initial_edited_by == null)
			initial_edited_by = edited_by; 
		return edited_by;
	}

	public function reset_edited_by():Int{
		return initial_edited_by;
	}

	public function clear_edited_by():Int{
		edited_by = '0';
		return edited_by;
	}
}