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

	public function new(props:DealProps) {
		propertyNames = 'id,contact,creation_date,account,target_account,start_day,start_date,cycle,amount,product,agent,project,status,pay_method,end_date,end_reason,repeat_date,edited_by,mandator,old_active,cycle_start_date,last_locktime'.split(',');
		super(props);
	}	
		
	@dataType("bigint")
	@:isVar public var id(get,set):Int;
	var initial_id:Int;
	
	function get_id():Int{
		return id;
	}

	function set_id(x:Int):Int{
		if(id != null)
			modified('id');
		id = x;
		if(initial_id == null)
			initial_id = id; 
		return id;
	}

	public function reset_id():Int{
		return initial_id;
	}

	public function clear_id():Int{
		trace('id primary key cannot be empty');
		return id;
	}	
		
	@dataType("bigint")
	@:isVar public var contact(get,set):Int;
	var initial_contact:Int;
	
	function get_contact():Int{
		return contact;
	}

	function set_contact(x:Int):Int{
		if(contact != null)
			modified('contact');
		contact = x;
		if(initial_contact == null)
			initial_contact = contact; 
		return contact;
	}

	public function reset_contact():Int{
		return initial_contact;
	}

	public function clear_contact():Int{
		contact = null;
		return contact;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var creation_date(get,set):String;
	var initial_creation_date:String;
	
	function get_creation_date():String{
			return creation_date;
	}

	function set_creation_date(x:String):String{
		if(creation_date != null)
			modified('creation_date');
		creation_date = x;
		if(initial_creation_date == null)
			initial_creation_date = creation_date; 
		return creation_date;
	}

	public function reset_creation_date():String{
		return initial_creation_date;
	}

	public function clear_creation_date():String{
		creation_date = 'CURRENT_TIMESTAMP';
		return creation_date;
	}	
		
	@dataType("bigint")
	@:isVar public var account(get,set):Int;
	var initial_account:Int;
	
	function get_account():Int{
		return account;
	}

	function set_account(x:Int):Int{
		if(account != null)
			modified('account');
		account = x;
		if(initial_account == null)
			initial_account = account; 
		return account;
	}

	public function reset_account():Int{
		return initial_account;
	}

	public function clear_account():Int{
		account = null;
		return account;
	}	
		
	@dataType("bigint")
	@:isVar public var target_account(get,set):Int;
	var initial_target_account:Int;
	
	function get_target_account():Int{
		return target_account;
	}

	function set_target_account(x:Int):Int{
		if(target_account != null)
			modified('target_account');
		target_account = x;
		if(initial_target_account == null)
			initial_target_account = target_account; 
		return target_account;
	}

	public function reset_target_account():Int{
		return initial_target_account;
	}

	public function clear_target_account():Int{
		target_account = null;
		return target_account;
	}	
		
	@dataType("character varying(2)")
	@:isVar public var start_day(get,set):String;
	var initial_start_day:String;
	
	function get_start_day():String{
		return start_day;
	}

	function set_start_day(x:String):String{
		if(start_day != null)
			modified('start_day');
		start_day = x;
		if(initial_start_day == null)
			initial_start_day = start_day; 
		return start_day;
	}

	public function reset_start_day():String{
		return initial_start_day;
	}

	public function clear_start_day():String{
		start_day = '1';
		return start_day;
	}	
		
	@dataType("date")
	@:isVar public var start_date(get,set):String;
	var initial_start_date:String;
	
	function get_start_date():String{
			return start_date;
	}

	function set_start_date(x:String):String{
		if(start_date != null)
			modified('start_date');
		start_date = x;
		if(initial_start_date == null)
			initial_start_date = start_date; 
		return start_date;
	}

	public function reset_start_date():String{
		return initial_start_date;
	}

	public function clear_start_date():String{
		start_date = 'null';
		return start_date;
	}	
		
	@dataType("deals_cycle")
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
		
	@dataType("numeric(10,2)")
	@:isVar public var amount(get,set):String;
	var initial_amount:String;
	
	function get_amount():String{
			return amount;
	}

	function set_amount(x:String):String{
		if(amount != null)
			modified('amount');
		amount = x;
		if(initial_amount == null)
			initial_amount = amount; 
		return amount;
	}

	public function reset_amount():String{
		return initial_amount;
	}

	public function clear_amount():String{
		amount = '';
		return amount;
	}	
		
	@dataType("bigint")
	@:isVar public var product(get,set):Int;
	var initial_product:Int;
	
	function get_product():Int{
		return product;
	}

	function set_product(x:Int):Int{
		if(product != null)
			modified('product');
		product = x;
		if(initial_product == null)
			initial_product = product; 
		return product;
	}

	public function reset_product():Int{
		return initial_product;
	}

	public function clear_product():Int{
		product = null;
		return product;
	}	
		
	@dataType("bigint")
	@:isVar public var agent(get,set):Int;
	var initial_agent:Int;
	
	function get_agent():Int{
		return agent;
	}

	function set_agent(x:Int):Int{
		if(agent != null)
			modified('agent');
		agent = x;
		if(initial_agent == null)
			initial_agent = agent; 
		return agent;
	}

	public function reset_agent():Int{
		return initial_agent;
	}

	public function clear_agent():Int{
		agent = null;
		return agent;
	}	
		
	@dataType("bigint")
	@:isVar public var project(get,set):Int;
	var initial_project:Int;
	
	function get_project():Int{
		return project;
	}

	function set_project(x:Int):Int{
		if(project != null)
			modified('project');
		project = x;
		if(initial_project == null)
			initial_project = project; 
		return project;
	}

	public function reset_project():Int{
		return initial_project;
	}

	public function clear_project():Int{
		project = null;
		return project;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var status(get,set):String;
	var initial_status:String;
	
	function get_status():String{
		return status;
	}

	function set_status(x:String):String{
		if(status != null)
			modified('status');
		status = x;
		if(initial_status == null)
			initial_status = status; 
		return status;
	}

	public function reset_status():String{
		return initial_status;
	}

	public function clear_status():String{
		status = 'active';
		return status;
	}	
		
	@dataType("character varying(64)")
	@:isVar public var pay_method(get,set):String;
	var initial_pay_method:String;
	
	function get_pay_method():String{
		return pay_method;
	}

	function set_pay_method(x:String):String{
		if(pay_method != null)
			modified('pay_method');
		pay_method = x;
		if(initial_pay_method == null)
			initial_pay_method = pay_method; 
		return pay_method;
	}

	public function reset_pay_method():String{
		return initial_pay_method;
	}

	public function clear_pay_method():String{
		pay_method = 'debit';
		return pay_method;
	}	
		
	@dataType("date")
	@:isVar public var end_date(get,set):String;
	var initial_end_date:String;
	
	function get_end_date():String{
			return end_date;
	}

	function set_end_date(x:String):String{
		if(end_date != null)
			modified('end_date');
		end_date = x;
		if(initial_end_date == null)
			initial_end_date = end_date; 
		return end_date;
	}

	public function reset_end_date():String{
		return initial_end_date;
	}

	public function clear_end_date():String{
		end_date = 'null';
		return end_date;
	}	
		
	@dataType("bigint")
	@:isVar public var end_reason(get,set):Int;
	var initial_end_reason:Int;
	
	function get_end_reason():Int{
		return end_reason;
	}

	function set_end_reason(x:Int):Int{
		if(end_reason != null)
			modified('end_reason');
		end_reason = x;
		if(initial_end_reason == null)
			initial_end_reason = end_reason; 
		return end_reason;
	}

	public function reset_end_reason():Int{
		return initial_end_reason;
	}

	public function clear_end_reason():Int{
		end_reason = null;
		return end_reason;
	}	
		
	@dataType("date")
	@:isVar public var repeat_date(get,set):String;
	var initial_repeat_date:String;
	
	function get_repeat_date():String{
			return repeat_date;
	}

	function set_repeat_date(x:String):String{
		if(repeat_date != null)
			modified('repeat_date');
		repeat_date = x;
		if(initial_repeat_date == null)
			initial_repeat_date = repeat_date; 
		return repeat_date;
	}

	public function reset_repeat_date():String{
		return initial_repeat_date;
	}

	public function clear_repeat_date():String{
		repeat_date = 'null';
		return repeat_date;
	}	
		
	@dataType("bigint")
	@:isVar public var edited_by(get,set):Int;
	var initial_edited_by:Int;
	
	function get_edited_by():Int{
		return edited_by;
	}

	function set_edited_by(x:Int):Int{
		if(edited_by != null)
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
		edited_by = null;
		return edited_by;
	}	
		
	@dataType("bigint")
	@:isVar public var mandator(get,set):Int;
	var initial_mandator:Int;
	
	function get_mandator():Int{
		return mandator;
	}

	function set_mandator(x:Int):Int{
		if(mandator != null)
			modified('mandator');
		mandator = x;
		if(initial_mandator == null)
			initial_mandator = mandator; 
		return mandator;
	}

	public function reset_mandator():Int{
		return initial_mandator;
	}

	public function clear_mandator():Int{
		mandator = null;
		return mandator;
	}	
		
	@dataType("boolean")
	@:isVar public var old_active(get,set):Bool;
	var initial_old_active:Bool;
	
	function get_old_active():Bool{
		return old_active;
	}

	function set_old_active(x:Bool):Bool{
		if(old_active != null)
			modified('old_active');
		old_active = x;
		if(initial_old_active == null)
			initial_old_active = old_active; 
		return old_active;
	}

	public function reset_old_active():Bool{
		return initial_old_active;
	}

	public function clear_old_active():Bool{
		old_active = 1;
		return old_active;
	}	
		
	@dataType("date")
	@:isVar public var cycle_start_date(get,set):String;
	var initial_cycle_start_date:String;
	
	function get_cycle_start_date():String{
			return cycle_start_date;
	}

	function set_cycle_start_date(x:String):String{
		if(cycle_start_date != null)
			modified('cycle_start_date');
		cycle_start_date = x;
		if(initial_cycle_start_date == null)
			initial_cycle_start_date = cycle_start_date; 
		return cycle_start_date;
	}

	public function reset_cycle_start_date():String{
		return initial_cycle_start_date;
	}

	public function clear_cycle_start_date():String{
		cycle_start_date = 'null';
		return cycle_start_date;
	}	
		
	@dataType("timestamp(0) without time zone")
	@:isVar public var last_locktime(get,set):String;
	var initial_last_locktime:String;
	
	function get_last_locktime():String{
			return last_locktime;
	}

	function set_last_locktime(x:String):String{
		if(last_locktime != null)
			modified('last_locktime');
		last_locktime = x;
		if(initial_last_locktime == null)
			initial_last_locktime = last_locktime; 
		return last_locktime;
	}

	public function reset_last_locktime():String{
		return initial_last_locktime;
	}

	public function clear_last_locktime():String{
		last_locktime = 'CURRENT_TIMESTAMP';
		return last_locktime;
	}	
	
}