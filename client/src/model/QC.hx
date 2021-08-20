package model;


@:keep
@:rtti
class QC extends ORM
{
	public static var tableName:String = "qcs";

	public function new(data:Map<String,String>) {
		super(data);		
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(default,set):Int;

	function set_mandator(mandator:Int):Int{
		if(initialized('mandator'))
			modified('mandator');
		this.mandator = mandator ;
		return mandator;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var entry_date(default,set):String;

	function set_entry_date(entry_date:String):String{
		if(initialized('entry_date'))
			modified('entry_date');
		this.entry_date = entry_date ;
		return entry_date;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var status(default,set):String;

	function set_status(status:String):String{
		if(initialized('status'))
			modified('status');
		this.status = status ;
		return status;
	}	
		
	@dataType("boolean")
	@:isVar public var use_email(default,set):Bool;

	function set_use_email(use_email:Bool):Bool{
		if(initialized('use_email'))
			modified('use_email');
		this.use_email = use_email ;
		return use_email;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var company_name(default,set):String;

	function set_company_name(company_name:String):String{
		if(initialized('company_name'))
			modified('company_name');
		this.company_name = company_name ;
		return company_name;
	}	
		
	@dataType("character varying(100)")
	@:isVar public var care_of(default,set):String;

	function set_care_of(care_of:String):String{
		if(initialized('care_of'))
			modified('care_of');
		this.care_of = care_of ;
		return care_of;
	}	
		
	@dataType("character varying(10)")
	@:isVar public var phone_code(default,set):String;

	function set_phone_code(phone_code:String):String{
		if(initialized('phone_code'))
			modified('phone_code');
		this.phone_code = phone_code ;
		return phone_code;
	}	
		
	@dataType("character varying(18)")
	@:isVar public var phone_number(default,set):String;

	function set_phone_number(phone_number:String):String{
		if(initialized('phone_number'))
			modified('phone_number');
		this.phone_number = phone_number ;
		return phone_number;
	}	
		
	@dataType("character varying(18)")
	@:isVar public var fax(default,set):String;

	function set_fax(fax:String):String{
		if(initialized('fax'))
			modified('fax');
		this.fax = fax ;
		return fax;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var title(default,set):String;

	function set_title(title:String):String{
		if(initialized('title'))
			modified('title');
		this.title = title ;
		return title;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var first_name(default,set):String;

	function set_first_name(first_name:String):String{
		if(initialized('first_name'))
			modified('first_name');
		this.first_name = first_name ;
		return first_name;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var last_name(default,set):String;

	function set_last_name(last_name:String):String{
		if(initialized('last_name'))
			modified('last_name');
		this.last_name = last_name ;
		return last_name;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var address(default,set):String;

	function set_address(address:String):String{
		if(initialized('address'))
			modified('address');
		this.address = address ;
		return address;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var address_2(default,set):String;

	function set_address_2(address_2:String):String{
		if(initialized('address_2'))
			modified('address_2');
		this.address_2 = address_2 ;
		return address_2;
	}	
		
	@dataType("character varying(50)")
	@:isVar public var city(default,set):String;

	function set_city(city:String):String{
		if(initialized('city'))
			modified('city');
		this.city = city ;
		return city;
	}	
		
	@dataType("character varying(10)")
	@:isVar public var postal_code(default,set):String;

	function set_postal_code(postal_code:String):String{
		if(initialized('postal_code'))
			modified('postal_code');
		this.postal_code = postal_code ;
		return postal_code;
	}	
		
	@dataType("character varying(3)")
	@:isVar public var country_code(default,set):String;

	function set_country_code(country_code:String):String{
		if(initialized('country_code'))
			modified('country_code');
		this.country_code = country_code ;
		return country_code;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var gender(default,set):String;

	function set_gender(gender:String):String{
		if(initialized('gender'))
			modified('gender');
		this.gender = gender ;
		return gender;
	}	
		
	@dataType("date")
	@:isVar public var date_of_birth(default,set):String;

	function set_date_of_birth(date_of_birth:String):String{
		if(initialized('date_of_birth'))
			modified('date_of_birth');
		this.date_of_birth = date_of_birth ;
		return date_of_birth;
	}	
		
	@dataType("character varying(19)")
	@:isVar public var mobile(default,set):String;

	function set_mobile(mobile:String):String{
		if(initialized('mobile'))
			modified('mobile');
		this.mobile = mobile ;
		return mobile;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var email(default,set):String;

	function set_email(email:String):String{
		if(initialized('email'))
			modified('email');
		this.email = email ;
		return email;
	}	
		
	@dataType("character varying(4096)")
	@:isVar public var comments(default,set):String;

	function set_comments(comments:String):String{
		if(initialized('comments'))
			modified('comments');
		this.comments = comments ;
		return comments;
	}	
		
	@dataType("bigint")
	@:isVar public var edited_by(default,set):Int;

	function set_edited_by(edited_by:Int):Int{
		if(initialized('edited_by'))
			modified('edited_by');
		this.edited_by = edited_by ;
		return edited_by;
	}	
		
	@dataType("bigint[]")
	@:isVar public var merged(default,set):Array<Int>;

	function set_merged(merged:Array<Int>):Array<Int>{
		if(initialized('merged'))
			modified('merged');
		this.merged = merged ;
		return merged;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var last_updated(default,set):String;

	function set_last_updated(last_updated:String):String{
		if(initialized('last_updated'))
			modified('last_updated');
		this.last_updated = last_updated ;
		return last_updated;
	}	
		
	@dataType("bigint")
	@:isVar public var owner(default,set):Int;

	function set_owner(owner:Int):Int{
		if(initialized('owner'))
			modified('owner');
		this.owner = owner ;
		return owner;
	}	
		
	@dataType("character varying(80)")
	@:isVar public var title_pro(default,set):String;

	function set_title_pro(title_pro:String):String{
		if(initialized('title_pro'))
			modified('title_pro');
		this.title_pro = title_pro ;
		return title_pro;
	}	
		
	@dataType("integer")
	@:isVar public var lead_id(default,set):String;

	function set_lead_id(lead_id:String):String{
		if(initialized('lead_id'))
			modified('lead_id');
		this.lead_id = lead_id ;
		return lead_id;
	}	
		
	@dataType("text")
	@:isVar public var period(default,set):String;

	function set_period(period:String):String{
		if(initialized('period'))
			modified('period');
		this.period = period ;
		return period;
	}	
		
	@dataType("text")
	@:isVar public var anrede(default,set):String;

	function set_anrede(anrede:String):String{
		if(initialized('anrede'))
			modified('anrede');
		this.anrede = anrede ;
		return anrede;
	}	
		
	@dataType("text")
	@:isVar public var account(default,set):String;

	function set_account(account:String):String{
		if(initialized('account'))
			modified('account');
		this.account = account ;
		return account;
	}	
		
	@dataType("text")
	@:isVar public var blz(default,set):String;

	function set_blz(blz:String):String{
		if(initialized('blz'))
			modified('blz');
		this.blz = blz ;
		return blz;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var iban(default,set):String;

	function set_iban(iban:String):String{
		if(initialized('iban'))
			modified('iban');
		this.iban = iban ;
		return iban;
	}	
		
	@dataType("text")
	@:isVar public var bank_name(default,set):String;

	function set_bank_name(bank_name:String):String{
		if(initialized('bank_name'))
			modified('bank_name');
		this.bank_name = bank_name ;
		return bank_name;
	}	
		
	@dataType("text")
	@:isVar public var spenden_hoehe(default,set):String;

	function set_spenden_hoehe(spenden_hoehe:String):String{
		if(initialized('spenden_hoehe'))
			modified('spenden_hoehe');
		this.spenden_hoehe = spenden_hoehe ;
		return spenden_hoehe;
	}	
		
	@dataType("text")
	@:isVar public var start_monat(default,set):String;

	function set_start_monat(start_monat:String):String{
		if(initialized('start_monat'))
			modified('start_monat');
		this.start_monat = start_monat ;
		return start_monat;
	}	
		
	@dataType("text")
	@:isVar public var buchungs_tag(default,set):String;

	function set_buchungs_tag(buchungs_tag:String):String{
		if(initialized('buchungs_tag'))
			modified('buchungs_tag');
		this.buchungs_tag = buchungs_tag ;
		return buchungs_tag;
	}	
		
	@dataType("text")
	@:isVar public var buchungs_zeitpunkt(default,set):String;

	function set_buchungs_zeitpunkt(buchungs_zeitpunkt:String):String{
		if(initialized('buchungs_zeitpunkt'))
			modified('buchungs_zeitpunkt');
		this.buchungs_zeitpunkt = buchungs_zeitpunkt ;
		return buchungs_zeitpunkt;
	}	
		
	@dataType("text")
	@:isVar public var mailing(default,set):String;

	function set_mailing(mailing:String):String{
		if(initialized('mailing'))
			modified('mailing');
		this.mailing = mailing ;
		return mailing;
	}	
		
	@dataType("text")
	@:isVar public var client_status(default,set):String;

	function set_client_status(client_status:String):String{
		if(initialized('client_status'))
			modified('client_status');
		this.client_status = client_status ;
		return client_status;
	}	
	
}