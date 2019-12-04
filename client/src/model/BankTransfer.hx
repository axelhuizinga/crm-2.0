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
	?super_ag_name:String
};

@:rtti
class BankTransfer extends ORM
{

	public function new(props:BankTransferProps) {
		propertyNames = 'ag_name,ag_konto_or_iban,ag_blz_or_bic,zahlpfl_name,zahlpfl_name2,zahlpfl_strasse,zahlpfl_name_ort,zahlpfl_name_kto_or_iban,zahlpfl_name_blz_or_bic,betrag,currency,zahlart,termin,vwz1,vwz2,vwz3,vwz4,vwz5,vwz6,vwz7,vwz8,vwz9,ba_id,tracking_status,anforderungs_datum,rueck_datum,cycle,ref_id,mandat_id,mandat_datum,ag_creditor_id,sequenz,super_ag_name'.split(',');
		super(props);
	}	
		
	@dataType("character varying(64)")
	@:isVar public var ag_name(get,set):String;
	var initial_ag_name:String;
	
	function get_ag_name():String{
		return ag_name;
	}

	function set_ag_name(x:String):String{
		if(ag_name != null)
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
		
	@dataType("character varying(32)")
	@:isVar public var ag_konto_or_iban(get,set):String;
	var initial_ag_konto_or_iban:String;
	
	function get_ag_konto_or_iban():String{
		return ag_konto_or_iban;
	}

	function set_ag_konto_or_iban(x:String):String{
		if(ag_konto_or_iban != null)
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
		
	@dataType("character varying(11)")
	@:isVar public var ag_blz_or_bic(get,set):String;
	var initial_ag_blz_or_bic:String;
	
	function get_ag_blz_or_bic():String{
		return ag_blz_or_bic;
	}

	function set_ag_blz_or_bic(x:String):String{
		if(ag_blz_or_bic != null)
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
		
	@dataType("character varying(21)")
	@:isVar public var zahlpfl_name(get,set):String;
	var initial_zahlpfl_name:String;
	
	function get_zahlpfl_name():String{
		return zahlpfl_name;
	}

	function set_zahlpfl_name(x:String):String{
		if(zahlpfl_name != null)
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
		
	@dataType("character varying(32)")
	@:isVar public var zahlpfl_name2(get,set):String;
	var initial_zahlpfl_name2:String;
	
	function get_zahlpfl_name2():String{
		return zahlpfl_name2;
	}

	function set_zahlpfl_name2(x:String):String{
		if(zahlpfl_name2 != null)
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
		zahlpfl_name2 = '';
		return zahlpfl_name2;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var zahlpfl_strasse(get,set):String;
	var initial_zahlpfl_strasse:String;
	
	function get_zahlpfl_strasse():String{
		return zahlpfl_strasse;
	}

	function set_zahlpfl_strasse(x:String):String{
		if(zahlpfl_strasse != null)
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
		
	@dataType("character varying(32)")
	@:isVar public var zahlpfl_name_ort(get,set):String;
	var initial_zahlpfl_name_ort:String;
	
	function get_zahlpfl_name_ort():String{
		return zahlpfl_name_ort;
	}

	function set_zahlpfl_name_ort(x:String):String{
		if(zahlpfl_name_ort != null)
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
		
	@dataType("character varying(22)")
	@:isVar public var zahlpfl_name_kto_or_iban(get,set):String;
	var initial_zahlpfl_name_kto_or_iban:String;
	
	function get_zahlpfl_name_kto_or_iban():String{
		return zahlpfl_name_kto_or_iban;
	}

	function set_zahlpfl_name_kto_or_iban(x:String):String{
		if(zahlpfl_name_kto_or_iban != null)
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
		
	@dataType("character varying(11)")
	@:isVar public var zahlpfl_name_blz_or_bic(get,set):String;
	var initial_zahlpfl_name_blz_or_bic:String;
	
	function get_zahlpfl_name_blz_or_bic():String{
		return zahlpfl_name_blz_or_bic;
	}

	function set_zahlpfl_name_blz_or_bic(x:String):String{
		if(zahlpfl_name_blz_or_bic != null)
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
		zahlpfl_name_blz_or_bic = '';
		return zahlpfl_name_blz_or_bic;
	}	
		
	@dataType("double precision")
	@:isVar public var betrag(get,set):String;
	var initial_betrag:String;
	
	function get_betrag():String{
			return betrag;
	}

	function set_betrag(x:String):String{
		if(betrag != null)
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
		
	@dataType("character varying(32)")
	@:isVar public var currency(get,set):String;
	var initial_currency:String;
	
	function get_currency():String{
		return currency;
	}

	function set_currency(x:String):String{
		if(currency != null)
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
		currency = '€';
		return currency;
	}	
		
	@dataType("character varying(5)")
	@:isVar public var zahlart(get,set):String;
	var initial_zahlart:String;
	
	function get_zahlart():String{
		return zahlart;
	}

	function set_zahlart(x:String):String{
		if(zahlart != null)
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
		zahlart = 'BASIS';
		return zahlart;
	}	
		
	@dataType("date")
	@:isVar public var termin(get,set):String;
	var initial_termin:String;
	
	function get_termin():String{
			return termin;
	}

	function set_termin(x:String):String{
		if(termin != null)
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
		termin = 'null';
		return termin;
	}	
		
	@dataType("character varying(22)")
	@:isVar public var vwz1(get,set):String;
	var initial_vwz1:String;
	
	function get_vwz1():String{
		return vwz1;
	}

	function set_vwz1(x:String):String{
		if(vwz1 != null)
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
		vwz1 = '';
		return vwz1;
	}	
		
	@dataType("character varying(256)")
	@:isVar public var vwz2(get,set):String;
	var initial_vwz2:String;
	
	function get_vwz2():String{
		return vwz2;
	}

	function set_vwz2(x:String):String{
		if(vwz2 != null)
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
		vwz2 = '';
		return vwz2;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var vwz3(get,set):String;
	var initial_vwz3:String;
	
	function get_vwz3():String{
		return vwz3;
	}

	function set_vwz3(x:String):String{
		if(vwz3 != null)
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
		vwz3 = '';
		return vwz3;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var vwz4(get,set):String;
	var initial_vwz4:String;
	
	function get_vwz4():String{
		return vwz4;
	}

	function set_vwz4(x:String):String{
		if(vwz4 != null)
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
		vwz4 = '';
		return vwz4;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var vwz5(get,set):String;
	var initial_vwz5:String;
	
	function get_vwz5():String{
		return vwz5;
	}

	function set_vwz5(x:String):String{
		if(vwz5 != null)
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
		vwz5 = '';
		return vwz5;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var vwz6(get,set):String;
	var initial_vwz6:String;
	
	function get_vwz6():String{
		return vwz6;
	}

	function set_vwz6(x:String):String{
		if(vwz6 != null)
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
		vwz6 = '';
		return vwz6;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var vwz7(get,set):String;
	var initial_vwz7:String;
	
	function get_vwz7():String{
		return vwz7;
	}

	function set_vwz7(x:String):String{
		if(vwz7 != null)
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
		vwz7 = '';
		return vwz7;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var vwz8(get,set):String;
	var initial_vwz8:String;
	
	function get_vwz8():String{
		return vwz8;
	}

	function set_vwz8(x:String):String{
		if(vwz8 != null)
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
		vwz8 = '';
		return vwz8;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var vwz9(get,set):String;
	var initial_vwz9:String;
	
	function get_vwz9():String{
		return vwz9;
	}

	function set_vwz9(x:String):String{
		if(vwz9 != null)
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
		vwz9 = '';
		return vwz9;
	}	
		
	@dataType("bigint")
	@:isVar public var ba_id(get,set):Int;
	var initial_ba_id:Int;
	
	function get_ba_id():Int{
		return ba_id;
	}

	function set_ba_id(x:Int):Int{
		if(ba_id != null)
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
		trace('ba_id primary key cannot be empty');
		return ba_id;
	}	
		
	@dataType("bank_transfers_tracking_status")
	@:isVar public var tracking_status(get,set):String;
	var initial_tracking_status:String;
	
	function get_tracking_status():String{
			return tracking_status;
	}

	function set_tracking_status(x:String):String{
		if(tracking_status != null)
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
		tracking_status = 'neu';
		return tracking_status;
	}	
		
	@dataType("date")
	@:isVar public var anforderungs_datum(get,set):String;
	var initial_anforderungs_datum:String;
	
	function get_anforderungs_datum():String{
			return anforderungs_datum;
	}

	function set_anforderungs_datum(x:String):String{
		if(anforderungs_datum != null)
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
		anforderungs_datum = 'null';
		return anforderungs_datum;
	}	
		
	@dataType("date")
	@:isVar public var rueck_datum(get,set):String;
	var initial_rueck_datum:String;
	
	function get_rueck_datum():String{
			return rueck_datum;
	}

	function set_rueck_datum(x:String):String{
		if(rueck_datum != null)
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
		rueck_datum = 'null';
		return rueck_datum;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var cycle(get,set):String;
	var initial_cycle:String;
	
	function get_cycle():String{
		return cycle;
	}

	function set_cycle(x:String):String{
		if(cycle != null)
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
		
	@dataType("character varying(32)")
	@:isVar public var ref_id(get,set):String;
	var initial_ref_id:String;
	
	function get_ref_id():String{
		return ref_id;
	}

	function set_ref_id(x:String):String{
		if(ref_id != null)
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
		
	@dataType("character varying(11)")
	@:isVar public var mandat_id(get,set):String;
	var initial_mandat_id:String;
	
	function get_mandat_id():String{
		return mandat_id;
	}

	function set_mandat_id(x:String):String{
		if(mandat_id != null)
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
		
	@dataType("date")
	@:isVar public var mandat_datum(get,set):String;
	var initial_mandat_datum:String;
	
	function get_mandat_datum():String{
			return mandat_datum;
	}

	function set_mandat_datum(x:String):String{
		if(mandat_datum != null)
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
		mandat_datum = 'null';
		return mandat_datum;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var ag_creditor_id(get,set):String;
	var initial_ag_creditor_id:String;
	
	function get_ag_creditor_id():String{
		return ag_creditor_id;
	}

	function set_ag_creditor_id(x:String):String{
		if(ag_creditor_id != null)
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
		
	@dataType("character varying(4)")
	@:isVar public var sequenz(get,set):String;
	var initial_sequenz:String;
	
	function get_sequenz():String{
		return sequenz;
	}

	function set_sequenz(x:String):String{
		if(sequenz != null)
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
		
	@dataType("character varying(32)")
	@:isVar public var super_ag_name(get,set):String;
	var initial_super_ag_name:String;
	
	function get_super_ag_name():String{
		return super_ag_name;
	}

	function set_super_ag_name(x:String):String{
		if(super_ag_name != null)
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
	
}