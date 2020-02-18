package model;
import view.shared.io.DataAccess.DataView;

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

	public function new(props:DealProps, view:DataView) {
		propertyNames = 'id,contact,creation_date,account,target_account,start_day,start_date,cycle,amount,product,agent,project,status,pay_method,end_date,end_reason,repeat_date,edited_by,mandator,old_active,cycle_start_date,last_locktime'.split(',');
		super(props, view);
	}	
		
	@dataType("bigint")
	@:isVar public var id(get,set):Int;
	var id_initialized:Bool;
	
	function get_id():Int{
		return id;
	}

	function set_id(id:Int):Int{
		if(id_initialized)
			modified('id');
		this.id = id ;
		id_initialized = true; 
		return id;
	}	
		
	@dataType("bigint")
	@:isVar public var contact(get,set):Int;
	var contact_initialized:Bool;
	
	function get_contact():Int{
		return contact;
	}

	function set_contact(contact:Int):Int{
		if(contact_initialized)
			modified('contact');
		this.contact = contact ;
		contact_initialized = true; 
		return contact;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var creation_date(get,set):String;
	var creation_date_initialized:Bool;
	
	function get_creation_date():String{
			return creation_date;
	}

	function set_creation_date(creation_date:String):String{
		if(creation_date_initialized)
			modified('creation_date');
		this.creation_date = creation_date ;
		creation_date_initialized = true; 
		return creation_date;
	}	
		
	@dataType("bigint")
	@:isVar public var account(get,set):Int;
	var account_initialized:Bool;
	
	function get_account():Int{
		return account;
	}

	function set_account(account:Int):Int{
		if(account_initialized)
			modified('account');
		this.account = account ;
		account_initialized = true; 
		return account;
	}	
		
	@dataType("bigint")
	@:isVar public var target_account(get,set):Int;
	var target_account_initialized:Bool;
	
	function get_target_account():Int{
		return target_account;
	}

	function set_target_account(target_account:Int):Int{
		if(target_account_initialized)
			modified('target_account');
		this.target_account = target_account ;
		target_account_initialized = true; 
		return target_account;
	}	
		
	@dataType("character varying(2)")
	@:isVar public var start_day(get,set):String;
	var start_day_initialized:Bool;
	
	function get_start_day():String{
		return start_day;
	}

	function set_start_day(start_day:String):String{
		if(start_day_initialized)
			modified('start_day');
		this.start_day = start_day ;
		start_day_initialized = true; 
		return start_day;
	}	
		
	@dataType("date")
	@:isVar public var start_date(get,set):String;
	var start_date_initialized:Bool;
	
	function get_start_date():String{
			return start_date;
	}

	function set_start_date(start_date:String):String{
		if(start_date_initialized)
			modified('start_date');
		this.start_date = start_date ;
		start_date_initialized = true; 
		return start_date;
	}	
		
	@dataType("deals_cycle")
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
		
	@dataType("numeric(10,2)")
	@:isVar public var amount(get,set):String;
	var amount_initialized:Bool;
	
	function get_amount():String{
			return amount;
	}

	function set_amount(amount:String):String{
		if(amount_initialized)
			modified('amount');
		this.amount = amount ;
		amount_initialized = true; 
		return amount;
	}	
		
	@dataType("bigint")
	@:isVar public var product(get,set):Int;
	var product_initialized:Bool;
	
	function get_product():Int{
		return product;
	}

	function set_product(product:Int):Int{
		if(product_initialized)
			modified('product');
		this.product = product ;
		product_initialized = true; 
		return product;
	}	
		
	@dataType("bigint")
	@:isVar public var agent(get,set):Int;
	var agent_initialized:Bool;
	
	function get_agent():Int{
		return agent;
	}

	function set_agent(agent:Int):Int{
		if(agent_initialized)
			modified('agent');
		this.agent = agent ;
		agent_initialized = true; 
		return agent;
	}	
		
	@dataType("bigint")
	@:isVar public var project(get,set):Int;
	var project_initialized:Bool;
	
	function get_project():Int{
		return project;
	}

	function set_project(project:Int):Int{
		if(project_initialized)
			modified('project');
		this.project = project ;
		project_initialized = true; 
		return project;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var status(get,set):String;
	var status_initialized:Bool;
	
	function get_status():String{
		return status;
	}

	function set_status(status:String):String{
		if(status_initialized)
			modified('status');
		this.status = status ;
		status_initialized = true; 
		return status;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var pay_method(get,set):String;
	var pay_method_initialized:Bool;
	
	function get_pay_method():String{
		return pay_method;
	}

	function set_pay_method(pay_method:String):String{
		if(pay_method_initialized)
			modified('pay_method');
		this.pay_method = pay_method ;
		pay_method_initialized = true; 
		return pay_method;
	}	
		
	@dataType("date")
	@:isVar public var end_date(get,set):String;
	var end_date_initialized:Bool;
	
	function get_end_date():String{
			return end_date;
	}

	function set_end_date(end_date:String):String{
		if(end_date_initialized)
			modified('end_date');
		this.end_date = end_date ;
		end_date_initialized = true; 
		return end_date;
	}	
		
	@dataType("bigint")
	@:isVar public var end_reason(get,set):Int;
	var end_reason_initialized:Bool;
	
	function get_end_reason():Int{
		return end_reason;
	}

	function set_end_reason(end_reason:Int):Int{
		if(end_reason_initialized)
			modified('end_reason');
		this.end_reason = end_reason ;
		end_reason_initialized = true; 
		return end_reason;
	}	
		
	@dataType("date")
	@:isVar public var repeat_date(get,set):String;
	var repeat_date_initialized:Bool;
	
	function get_repeat_date():String{
			return repeat_date;
	}

	function set_repeat_date(repeat_date:String):String{
		if(repeat_date_initialized)
			modified('repeat_date');
		this.repeat_date = repeat_date ;
		repeat_date_initialized = true; 
		return repeat_date;
	}	
		
	@dataType("bigint")
	@:isVar public var edited_by(get,set):Int;
	var edited_by_initialized:Bool;
	
	function get_edited_by():Int{
		return edited_by;
	}

	function set_edited_by(edited_by:Int):Int{
		if(edited_by_initialized)
			modified('edited_by');
		this.edited_by = edited_by ;
		edited_by_initialized = true; 
		return edited_by;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(get,set):Int;
	var mandator_initialized:Bool;
	
	function get_mandator():Int{
		return mandator;
	}

	function set_mandator(mandator:Int):Int{
		if(mandator_initialized)
			modified('mandator');
		this.mandator = mandator ;
		mandator_initialized = true; 
		return mandator;
	}	
		
	@dataType("boolean")
	@:isVar public var old_active(get,set):Bool;
	var old_active_initialized:Bool;
	
	function get_old_active():Bool{
		return old_active;
	}

	function set_old_active(old_active:Bool):Bool{
		if(old_active_initialized)
			modified('old_active');
		this.old_active = old_active ;
		old_active_initialized = true; 
		return old_active;
	}	
		
	@dataType("date")
	@:isVar public var cycle_start_date(get,set):String;
	var cycle_start_date_initialized:Bool;
	
	function get_cycle_start_date():String{
			return cycle_start_date;
	}

	function set_cycle_start_date(cycle_start_date:String):String{
		if(cycle_start_date_initialized)
			modified('cycle_start_date');
		this.cycle_start_date = cycle_start_date ;
		cycle_start_date_initialized = true; 
		return cycle_start_date;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var last_locktime(get,set):String;
	var last_locktime_initialized:Bool;
	
	function get_last_locktime():String{
			return last_locktime;
	}

	function set_last_locktime(last_locktime:String):String{
		if(last_locktime_initialized)
			modified('last_locktime');
		this.last_locktime = last_locktime ;
		last_locktime_initialized = true; 
		return last_locktime;
	}	
	
}