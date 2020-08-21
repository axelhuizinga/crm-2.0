package model;

typedef DealProps = {
	?id:Int,
	?contact:Int,
	?creation_date:String,
	?account:Int,
	?target_account:Int,
	?start_day:String,
	?start_date:String,
	?cycle:String,
	?amount:String,
	?product:Int,
	?agent:Int,
	?project:Int,
	?status:String,
	?pay_method:String,
	?end_date:String,
	?end_reason:Int,
	?repeat_date:String,
	?edited_by:Int,
	?mandator:Int,
	?old_active:Bool,
	?cycle_start_date:String,
	?last_locktime:String
};

@:rtti
class Deal extends ORM
{

	public function new(data:Map<String,String>) {
		super(data);
		propertyNames = 'id,contact,creation_date,account,target_account,start_day,start_date,cycle,amount,product,agent,project,status,pay_method,end_date,end_reason,repeat_date,edited_by,mandator,old_active,cycle_start_date,last_locktime'.split(',');
	}	
		
	@dataType("bigint")
	@:isVar public var id(default,set):Int;

	function set_id(id:Int):Int{
		if(initialized('id'))
			modified('id');
		this.id = id ;
		return id;
	}	
		
	@dataType("bigint")
	@:isVar public var contact(default,set):Int;

	function set_contact(contact:Int):Int{
		if(initialized('contact'))
			modified('contact');
		this.contact = contact ;
		return contact;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var creation_date(default,set):String;

	function set_creation_date(creation_date:String):String{
		if(initialized('creation_date'))
			modified('creation_date');
		this.creation_date = creation_date ;
		return creation_date;
	}	
		
	@dataType("bigint")
	@:isVar public var account(default,set):Int;

	function set_account(account:Int):Int{
		if(initialized('account'))
			modified('account');
		this.account = account ;
		return account;
	}	
		
	@dataType("bigint")
	@:isVar public var target_account(default,set):Int;

	function set_target_account(target_account:Int):Int{
		if(initialized('target_account'))
			modified('target_account');
		this.target_account = target_account ;
		return target_account;
	}	
		
	@dataType("character varying(2)")
	@:isVar public var start_day(default,set):String;

	function set_start_day(start_day:String):String{
		if(initialized('start_day'))
			modified('start_day');
		this.start_day = start_day ;
		return start_day;
	}	
		
	@dataType("date")
	@:isVar public var start_date(default,set):String;

	function set_start_date(start_date:String):String{
		if(initialized('start_date'))
			modified('start_date');
		this.start_date = start_date ;
		return start_date;
	}	
		
	@dataType("deals_cycle")
	@:isVar public var cycle(default,set):String;

	function set_cycle(cycle:String):String{
		if(initialized('cycle'))
			modified('cycle');
		this.cycle = cycle ;
		return cycle;
	}	
		
	@dataType("numeric(10,2)")
	@:isVar public var amount(default,set):String;

	function set_amount(amount:String):String{
		if(initialized('amount'))
			modified('amount');
		this.amount = amount ;
		return amount;
	}	
		
	@dataType("bigint")
	@:isVar public var product(default,set):Int;

	function set_product(product:Int):Int{
		if(initialized('product'))
			modified('product');
		this.product = product ;
		return product;
	}	
		
	@dataType("bigint")
	@:isVar public var agent(default,set):Int;

	function set_agent(agent:Int):Int{
		if(initialized('agent'))
			modified('agent');
		this.agent = agent ;
		return agent;
	}	
		
	@dataType("bigint")
	@:isVar public var project(default,set):Int;

	function set_project(project:Int):Int{
		if(initialized('project'))
			modified('project');
		this.project = project ;
		return project;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var status(default,set):String;

	function set_status(status:String):String{
		if(initialized('status'))
			modified('status');
		this.status = status ;
		return status;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var pay_method(default,set):String;

	function set_pay_method(pay_method:String):String{
		if(initialized('pay_method'))
			modified('pay_method');
		this.pay_method = pay_method ;
		return pay_method;
	}	
		
	@dataType("date")
	@:isVar public var end_date(default,set):String;

	function set_end_date(end_date:String):String{
		if(initialized('end_date'))
			modified('end_date');
		this.end_date = end_date ;
		return end_date;
	}	
		
	@dataType("bigint")
	@:isVar public var end_reason(default,set):Int;

	function set_end_reason(end_reason:Int):Int{
		if(initialized('end_reason'))
			modified('end_reason');
		this.end_reason = end_reason ;
		return end_reason;
	}	
		
	@dataType("date")
	@:isVar public var repeat_date(default,set):String;

	function set_repeat_date(repeat_date:String):String{
		if(initialized('repeat_date'))
			modified('repeat_date');
		this.repeat_date = repeat_date ;
		return repeat_date;
	}	
		
	@dataType("bigint")
	@:isVar public var edited_by(default,set):Int;

	function set_edited_by(edited_by:Int):Int{
		if(initialized('edited_by'))
			modified('edited_by');
		this.edited_by = edited_by ;
		return edited_by;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(default,set):Int;

	function set_mandator(mandator:Int):Int{
		if(initialized('mandator'))
			modified('mandator');
		this.mandator = mandator ;
		return mandator;
	}	
		
	@dataType("boolean")
	@:isVar public var old_active(default,set):Bool;

	function set_old_active(old_active:Bool):Bool{
		if(initialized('old_active'))
			modified('old_active');
		this.old_active = old_active ;
		return old_active;
	}	
		
	@dataType("date")
	@:isVar public var cycle_start_date(default,set):String;

	function set_cycle_start_date(cycle_start_date:String):String{
		if(initialized('cycle_start_date'))
			modified('cycle_start_date');
		this.cycle_start_date = cycle_start_date ;
		return cycle_start_date;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var last_locktime(default,set):String;

	function set_last_locktime(last_locktime:String):String{
		if(initialized('last_locktime'))
			modified('last_locktime');
		this.last_locktime = last_locktime ;
		return last_locktime;
	}	
	
}