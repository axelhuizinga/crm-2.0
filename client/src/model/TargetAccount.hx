package model;


@:keep
@:rtti
class TargetAccount extends ORM
{
	public static var tableName:String = "target_accounts";

	public function new(data:Map<String,String>) {
		super(data);		
	}	
		
	@dataType("character varying(64)")
	@:isVar public var name(default,set):String;

	function set_name(name:String):String{
		if(initialized('name'))
			modified('name');
		this.name = name ;
		return name;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var bank_name(default,set):String;

	function set_bank_name(bank_name:String):String{
		if(initialized('bank_name'))
			modified('bank_name');
		this.bank_name = bank_name ;
		return bank_name;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var iban(default,set):String;

	function set_iban(iban:String):String{
		if(initialized('iban'))
			modified('iban');
		this.iban = iban ;
		return iban;
	}	
		
	@dataType("character varying(12)")
	@:isVar public var bic(default,set):String;

	function set_bic(bic:String):String{
		if(initialized('bic'))
			modified('bic');
		this.bic = bic ;
		return bic;
	}	
		
	@dataType("character varying(32)")
	@:isVar public var creditor_id(default,set):String;

	function set_creditor_id(creditor_id:String):String{
		if(initialized('creditor_id'))
			modified('creditor_id');
		this.creditor_id = creditor_id ;
		return creditor_id;
	}	
		
	@dataType("character varying(1024)")
	@:isVar public var project(default,set):String;

	function set_project(project:String):String{
		if(initialized('project'))
			modified('project');
		this.project = project ;
		return project;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(default,set):Int;

	function set_mandator(mandator:Int):Int{
		if(initialized('mandator'))
			modified('mandator');
		this.mandator = mandator ;
		return mandator;
	}	
	
}