package model;
import view.shared.io.DataAccess.DataView;

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

	public function new(props:BankTransferProps, view:DataView) {
		propertyNames = 'ag_name,ag_konto_or_iban,ag_blz_or_bic,zahlpfl_name,zahlpfl_name2,zahlpfl_strasse,zahlpfl_name_ort,zahlpfl_name_kto_or_iban,zahlpfl_name_blz_or_bic,betrag,currency,zahlart,termin,vwz1,vwz2,vwz3,vwz4,vwz5,vwz6,vwz7,vwz8,vwz9,ba_id,tracking_status,anforderungs_datum,rueck_datum,cycle,ref_id,mandat_id,mandat_datum,ag_creditor_id,sequenz,super_ag_name'.split(',');
		super(props, view);
	}	
		
	@dataType("character varying(64)")
	@:isVar public var ag_name(get,set):String;
	var ag_name_initialized:Bool;
	
	function get_ag_name():String{
		return ag_name;
	}

	function set_ag_name(ag_name:String):String{
		if(ag_name_initialized)
			modified('ag_name');
		this.ag_name = ag_name ;
		ag_name_initialized = true; 
		return ag_name;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var ag_konto_or_iban(get,set):String;
	var ag_konto_or_iban_initialized:Bool;
	
	function get_ag_konto_or_iban():String{
		return ag_konto_or_iban;
	}

	function set_ag_konto_or_iban(ag_konto_or_iban:String):String{
		if(ag_konto_or_iban_initialized)
			modified('ag_konto_or_iban');
		this.ag_konto_or_iban = ag_konto_or_iban ;
		ag_konto_or_iban_initialized = true; 
		return ag_konto_or_iban;
	}	
		
	@dataType("character varying(11)")
	@:isVar public var ag_blz_or_bic(get,set):String;
	var ag_blz_or_bic_initialized:Bool;
	
	function get_ag_blz_or_bic():String{
		return ag_blz_or_bic;
	}

	function set_ag_blz_or_bic(ag_blz_or_bic:String):String{
		if(ag_blz_or_bic_initialized)
			modified('ag_blz_or_bic');
		this.ag_blz_or_bic = ag_blz_or_bic ;
		ag_blz_or_bic_initialized = true; 
		return ag_blz_or_bic;
	}	
		
	@dataType("character varying(21)")
	@:isVar public var zahlpfl_name(get,set):String;
	var zahlpfl_name_initialized:Bool;
	
	function get_zahlpfl_name():String{
		return zahlpfl_name;
	}

	function set_zahlpfl_name(zahlpfl_name:String):String{
		if(zahlpfl_name_initialized)
			modified('zahlpfl_name');
		this.zahlpfl_name = zahlpfl_name ;
		zahlpfl_name_initialized = true; 
		return zahlpfl_name;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var zahlpfl_name2(get,set):String;
	var zahlpfl_name2_initialized:Bool;
	
	function get_zahlpfl_name2():String{
		return zahlpfl_name2;
	}

	function set_zahlpfl_name2(zahlpfl_name2:String):String{
		if(zahlpfl_name2_initialized)
			modified('zahlpfl_name2');
		this.zahlpfl_name2 = zahlpfl_name2 ;
		zahlpfl_name2_initialized = true; 
		return zahlpfl_name2;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var zahlpfl_strasse(get,set):String;
	var zahlpfl_strasse_initialized:Bool;
	
	function get_zahlpfl_strasse():String{
		return zahlpfl_strasse;
	}

	function set_zahlpfl_strasse(zahlpfl_strasse:String):String{
		if(zahlpfl_strasse_initialized)
			modified('zahlpfl_strasse');
		this.zahlpfl_strasse = zahlpfl_strasse ;
		zahlpfl_strasse_initialized = true; 
		return zahlpfl_strasse;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var zahlpfl_name_ort(get,set):String;
	var zahlpfl_name_ort_initialized:Bool;
	
	function get_zahlpfl_name_ort():String{
		return zahlpfl_name_ort;
	}

	function set_zahlpfl_name_ort(zahlpfl_name_ort:String):String{
		if(zahlpfl_name_ort_initialized)
			modified('zahlpfl_name_ort');
		this.zahlpfl_name_ort = zahlpfl_name_ort ;
		zahlpfl_name_ort_initialized = true; 
		return zahlpfl_name_ort;
	}	
		
	@dataType("character varying(22)")
	@:isVar public var zahlpfl_name_kto_or_iban(get,set):String;
	var zahlpfl_name_kto_or_iban_initialized:Bool;
	
	function get_zahlpfl_name_kto_or_iban():String{
		return zahlpfl_name_kto_or_iban;
	}

	function set_zahlpfl_name_kto_or_iban(zahlpfl_name_kto_or_iban:String):String{
		if(zahlpfl_name_kto_or_iban_initialized)
			modified('zahlpfl_name_kto_or_iban');
		this.zahlpfl_name_kto_or_iban = zahlpfl_name_kto_or_iban ;
		zahlpfl_name_kto_or_iban_initialized = true; 
		return zahlpfl_name_kto_or_iban;
	}	
		
	@dataType("character varying(11)")
	@:isVar public var zahlpfl_name_blz_or_bic(get,set):String;
	var zahlpfl_name_blz_or_bic_initialized:Bool;
	
	function get_zahlpfl_name_blz_or_bic():String{
		return zahlpfl_name_blz_or_bic;
	}

	function set_zahlpfl_name_blz_or_bic(zahlpfl_name_blz_or_bic:String):String{
		if(zahlpfl_name_blz_or_bic_initialized)
			modified('zahlpfl_name_blz_or_bic');
		this.zahlpfl_name_blz_or_bic = zahlpfl_name_blz_or_bic ;
		zahlpfl_name_blz_or_bic_initialized = true; 
		return zahlpfl_name_blz_or_bic;
	}	
		
	@dataType("double precision")
	@:isVar public var betrag(get,set):String;
	var betrag_initialized:Bool;
	
	function get_betrag():String{
			return betrag;
	}

	function set_betrag(betrag:String):String{
		if(betrag_initialized)
			modified('betrag');
		this.betrag = betrag ;
		betrag_initialized = true; 
		return betrag;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var currency(get,set):String;
	var currency_initialized:Bool;
	
	function get_currency():String{
		return currency;
	}

	function set_currency(currency:String):String{
		if(currency_initialized)
			modified('currency');
		this.currency = currency ;
		currency_initialized = true; 
		return currency;
	}	
		
	@dataType("character varying(5)")
	@:isVar public var zahlart(get,set):String;
	var zahlart_initialized:Bool;
	
	function get_zahlart():String{
		return zahlart;
	}

	function set_zahlart(zahlart:String):String{
		if(zahlart_initialized)
			modified('zahlart');
		this.zahlart = zahlart ;
		zahlart_initialized = true; 
		return zahlart;
	}	
		
	@dataType("date")
	@:isVar public var termin(get,set):String;
	var termin_initialized:Bool;
	
	function get_termin():String{
			return termin;
	}

	function set_termin(termin:String):String{
		if(termin_initialized)
			modified('termin');
		this.termin = termin ;
		termin_initialized = true; 
		return termin;
	}	
		
	@dataType("character varying(22)")
	@:isVar public var vwz1(get,set):String;
	var vwz1_initialized:Bool;
	
	function get_vwz1():String{
		return vwz1;
	}

	function set_vwz1(vwz1:String):String{
		if(vwz1_initialized)
			modified('vwz1');
		this.vwz1 = vwz1 ;
		vwz1_initialized = true; 
		return vwz1;
	}	
		
	@dataType("character varying(256)")
	@:isVar public var vwz2(get,set):String;
	var vwz2_initialized:Bool;
	
	function get_vwz2():String{
		return vwz2;
	}

	function set_vwz2(vwz2:String):String{
		if(vwz2_initialized)
			modified('vwz2');
		this.vwz2 = vwz2 ;
		vwz2_initialized = true; 
		return vwz2;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var vwz3(get,set):String;
	var vwz3_initialized:Bool;
	
	function get_vwz3():String{
		return vwz3;
	}

	function set_vwz3(vwz3:String):String{
		if(vwz3_initialized)
			modified('vwz3');
		this.vwz3 = vwz3 ;
		vwz3_initialized = true; 
		return vwz3;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var vwz4(get,set):String;
	var vwz4_initialized:Bool;
	
	function get_vwz4():String{
		return vwz4;
	}

	function set_vwz4(vwz4:String):String{
		if(vwz4_initialized)
			modified('vwz4');
		this.vwz4 = vwz4 ;
		vwz4_initialized = true; 
		return vwz4;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var vwz5(get,set):String;
	var vwz5_initialized:Bool;
	
	function get_vwz5():String{
		return vwz5;
	}

	function set_vwz5(vwz5:String):String{
		if(vwz5_initialized)
			modified('vwz5');
		this.vwz5 = vwz5 ;
		vwz5_initialized = true; 
		return vwz5;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var vwz6(get,set):String;
	var vwz6_initialized:Bool;
	
	function get_vwz6():String{
		return vwz6;
	}

	function set_vwz6(vwz6:String):String{
		if(vwz6_initialized)
			modified('vwz6');
		this.vwz6 = vwz6 ;
		vwz6_initialized = true; 
		return vwz6;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var vwz7(get,set):String;
	var vwz7_initialized:Bool;
	
	function get_vwz7():String{
		return vwz7;
	}

	function set_vwz7(vwz7:String):String{
		if(vwz7_initialized)
			modified('vwz7');
		this.vwz7 = vwz7 ;
		vwz7_initialized = true; 
		return vwz7;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var vwz8(get,set):String;
	var vwz8_initialized:Bool;
	
	function get_vwz8():String{
		return vwz8;
	}

	function set_vwz8(vwz8:String):String{
		if(vwz8_initialized)
			modified('vwz8');
		this.vwz8 = vwz8 ;
		vwz8_initialized = true; 
		return vwz8;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var vwz9(get,set):String;
	var vwz9_initialized:Bool;
	
	function get_vwz9():String{
		return vwz9;
	}

	function set_vwz9(vwz9:String):String{
		if(vwz9_initialized)
			modified('vwz9');
		this.vwz9 = vwz9 ;
		vwz9_initialized = true; 
		return vwz9;
	}	
		
	@dataType("bigint")
	@:isVar public var ba_id(get,set):Int;
	var ba_id_initialized:Bool;
	
	function get_ba_id():Int{
		return ba_id;
	}

	function set_ba_id(ba_id:Int):Int{
		if(ba_id_initialized)
			modified('ba_id');
		this.ba_id = ba_id ;
		ba_id_initialized = true; 
		return ba_id;
	}	
		
	@dataType("bank_transfers_tracking_status")
	@:isVar public var tracking_status(get,set):String;
	var tracking_status_initialized:Bool;
	
	function get_tracking_status():String{
			return tracking_status;
	}

	function set_tracking_status(tracking_status:String):String{
		if(tracking_status_initialized)
			modified('tracking_status');
		this.tracking_status = tracking_status ;
		tracking_status_initialized = true; 
		return tracking_status;
	}	
		
	@dataType("date")
	@:isVar public var anforderungs_datum(get,set):String;
	var anforderungs_datum_initialized:Bool;
	
	function get_anforderungs_datum():String{
			return anforderungs_datum;
	}

	function set_anforderungs_datum(anforderungs_datum:String):String{
		if(anforderungs_datum_initialized)
			modified('anforderungs_datum');
		this.anforderungs_datum = anforderungs_datum ;
		anforderungs_datum_initialized = true; 
		return anforderungs_datum;
	}	
		
	@dataType("date")
	@:isVar public var rueck_datum(get,set):String;
	var rueck_datum_initialized:Bool;
	
	function get_rueck_datum():String{
			return rueck_datum;
	}

	function set_rueck_datum(rueck_datum:String):String{
		if(rueck_datum_initialized)
			modified('rueck_datum');
		this.rueck_datum = rueck_datum ;
		rueck_datum_initialized = true; 
		return rueck_datum;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var cycle(get,set):String;
	var cycle_initialized:Bool;
	
	function get_cycle():String{
		return cycle;
	}

	function set_cycle(cycle:String):String{
		if(cycle_initialized)
			modified('cycle');
		this.cycle = cycle ;
		cycle_initialized = true; 
		return cycle;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var ref_id(get,set):String;
	var ref_id_initialized:Bool;
	
	function get_ref_id():String{
		return ref_id;
	}

	function set_ref_id(ref_id:String):String{
		if(ref_id_initialized)
			modified('ref_id');
		this.ref_id = ref_id ;
		ref_id_initialized = true; 
		return ref_id;
	}	
		
	@dataType("character varying(11)")
	@:isVar public var mandat_id(get,set):String;
	var mandat_id_initialized:Bool;
	
	function get_mandat_id():String{
		return mandat_id;
	}

	function set_mandat_id(mandat_id:String):String{
		if(mandat_id_initialized)
			modified('mandat_id');
		this.mandat_id = mandat_id ;
		mandat_id_initialized = true; 
		return mandat_id;
	}	
		
	@dataType("date")
	@:isVar public var mandat_datum(get,set):String;
	var mandat_datum_initialized:Bool;
	
	function get_mandat_datum():String{
			return mandat_datum;
	}

	function set_mandat_datum(mandat_datum:String):String{
		if(mandat_datum_initialized)
			modified('mandat_datum');
		this.mandat_datum = mandat_datum ;
		mandat_datum_initialized = true; 
		return mandat_datum;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var ag_creditor_id(get,set):String;
	var ag_creditor_id_initialized:Bool;
	
	function get_ag_creditor_id():String{
		return ag_creditor_id;
	}

	function set_ag_creditor_id(ag_creditor_id:String):String{
		if(ag_creditor_id_initialized)
			modified('ag_creditor_id');
		this.ag_creditor_id = ag_creditor_id ;
		ag_creditor_id_initialized = true; 
		return ag_creditor_id;
	}	
		
	@dataType("character varying(4)")
	@:isVar public var sequenz(get,set):String;
	var sequenz_initialized:Bool;
	
	function get_sequenz():String{
		return sequenz;
	}

	function set_sequenz(sequenz:String):String{
		if(sequenz_initialized)
			modified('sequenz');
		this.sequenz = sequenz ;
		sequenz_initialized = true; 
		return sequenz;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var super_ag_name(get,set):String;
	var super_ag_name_initialized:Bool;
	
	function get_super_ag_name():String{
		return super_ag_name;
	}

	function set_super_ag_name(super_ag_name:String):String{
		if(super_ag_name_initialized)
			modified('super_ag_name');
		this.super_ag_name = super_ag_name ;
		super_ag_name_initialized = true; 
		return super_ag_name;
	}	
	
}