package model.data;
import php.Global;
import Model;
import comments.CommentString.*;

class Booking extends Model
{
	var bdate:String;
	var buchungs_datum:String;
	var booking_date:String;	
	var day:String;
	var sday:String;

	var sdate:String;
	var start_date:String;
	//var start_date:String;
	//var start_date:String;

	public function new(?param:Map<String,String>) 
	{
		//table = 'contacts';
		super(param);

		go();
	}

	function init() {
		if(param['booking_day']==15){
			sday = day = '15';
			booking_date = start_date = bdate = sdate =	Global.sprintf('%s-%02d-%02d', $year,$month,$day);
		}
	}

	function buildBookingsSQL(tCond:String):String {
		//var bdate:String = param['']
		return comment(unindent,format)/*	 
		(SELECT pt.name, pt.iban, pt.bic, ps.debtor, '', '', '',  ps.iban, '', deals.amount, '', 'BASIS',
IF(deals.booking_day!='' AND SUBSTR('$bdate',9)!=deals.booking_day,
	IF ( deals.booking_day<DAY('$bdate'),
		CONCAT(SUBSTR(adddate(last_day(CURDATE()), 1),1,8),deals.booking_day),
		CONCAT(SUBSTR('$bdate',1,8),deals.booking_day)
		),
	'$bdate'),
CONCAT('Förderer-NR. ',ps.client_id),'Förderbeitrag',
'','',deals.agent,'','','',deals.product,NULL,'neu',
CURDATE(),'0000-00-00',
deals.cycle,'',
CONCAT(deals.client_id,deals.product,'1'), ps.sign_date, pt.creditor_id,'RCUR', ''
FROM deals 
INNER JOIN account acc ON acc.client_id=deals.client_id 
INNER JOIN clients cl ON cl.client_id=deals.client_id 
INNER JOIN pay_target pt ON pt.id=deals.target_id 
WHERE `pay_source_state`!='passive' 
AND deals.pay_plan_state='active' 
AND $tCond 
AND (deals.product='K' OR deals.product='T') 
AND deals.start_day='$sday' 
AND deals.start_date<'$sdate' 
AND deals.account=acc.id 
AND cl.state='active' 
AND cl.old_active=0 
AND (cl.register_off_to='0000-00-00' OR cl.register_off_to>'$sdate') LIMIT 10000)
	*/;

}		
	function buildBookingsFirstSQL(tCond:String):String {

		return comment(unindent,format)/*
		INSERT IGNORE buchungs_anforderungen SELECT pt.name, pt.iban, pt.bic, acc.account_holder, '', '', '',  acc.iban, '', deals.amount, '', 'BASIS',
	IF(deals.booking_day!='' AND SUBSTR('$bdate',9)!=deals.booking_day,
	IF(deals.booking_day<DAY('$bdate'),
		CONCAT(SUBSTR(adddate(last_day(CURDATE()), 1),1,8),deals.booking_day),
		CONCAT(SUBSTR('$bdate',1,8),deals.booking_day)
		),
	'$bdate'),
	CONCAT('Förderer-NR. ',acc.client_id),'Förderbeitrag',
	'','',deals.agent,'','','',deals.product,NULL,'neu',
	CURDATE(),'0000-00-00',
	deals.cycle,'',
	CONCAT(deals.client_id,deals.product,'1'), acc.sign_date,'DE28ZZZ00001362509','FRST', ''
	FROM accounts AS acc, pay_target AS pt, deals 
	INNER JOIN clients cl ON cl.client_id=deals.client_id
	WHERE  `pay_source_state`!='passive' 
	AND deals.pay_plan_state!='passive'
	AND deals.client_id=acc.client_id
	AND deals.start_day='$sday'
	AND deals.account=acc.id
	AND cl.state='active'
	AND $tCond
	AND cl.old_active=0 
	AND (cl.register_off_to='0000-00-00' OR cl.register_off_to>'$sdate')
	AND (deals.`start_date`<'$sdate')
	### BELOW LOOKS LIKE OVERKILL
	AND pt.id=IF(target_id=2,2,IF(deals.product='3',3,1))
	*/;
	}

	function createBookingRequests() {
	
	}

	/**
	 * AND (deals.product='K' OR deals.product='T')
	 */
	function go():Void {
		trace(action);
		switch(action){
			case _:
				run();
		}		
	}	
}