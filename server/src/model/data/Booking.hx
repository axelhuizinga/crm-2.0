package model.data;
import php.Global;
import Model;
import comments.CommentString.*;

class Booking extends Model
{
	var bdate:String;
	var buchungs_datum:String;
	var booking_date:String;	
	var day:Int;	
	var bday:Int;
	var sday:String;
	var sdate:String;
	var start_date:String;
	var date:Date;
	//var start_date:String;

	public function new(?param:Map<String,String>) 
	{
		//table = 'contacts';
		super(param);
		trace(action);
		/*switch(action){
			case 'createDirectDebitsCSV':
				createBookingRequests();
			case _:
				run();
		}*/
	}

	function init() {
		date = Date.now();
		if(param['booking_day']=='15'){
			sday = '15';			
			day = 15;
			//booking_date = start_date = bdate = sdate =	Global.sprintf('%s-%02d-%02d', $year,$month,$day);
			booking_date = start_date = bdate = sdate =	DateTools.format(date,'%Y-%m-%d');
			buchungs_datum = DateTools.format(date,'%d.%m.%y');
		}
		else {
			day = 1;
			sday = '1';
			// SET FORMAL BOOKING DATE TO START OF NEXT MONTH
			date = DateTools.delta(date, DateTools.days(DateTools.getMonthDays(date) - date.getDate() + 1));
			// SET VALUTA TO END OF CURRENT MONTH
			bday = DateTools.delta(date,-DateTools.days(1)).getDate();
			booking_date = start_date = bdate = sdate =	DateTools.format(DateTools.delta(date,-DateTools.days(1)),'%Y-%m-%d');
			buchungs_datum = DateTools.format(date,'%d.%m.%y');			
		}
	}

	function buildBookingsSQL(tCond:String):String {
		return comment(unindent,format)/*	 
		(SELECT pt.name, pt.iban, pt.bic, ps.debtor, '', '', '',  ps.iban, '', deals.amount, '', 'BASIS',
		CASE
			WHEN deals.booking_day!='' AND SUBSTR('$bdate',9)!=deals.booking_day THEN
				CASE
					WHEN deals.booking_day<$bday THEN 
						CONCAT(SUBSTR(adddate(last_day(CURDATE()), 1),1,8),deals.booking_day)
					ELSE CONCAT(SUBSTR('$bdate',1,8),deals.booking_day)
				END
			ELSE '$bdate'
		END,
CONCAT('Förderer-NR. ',ps.client_id),'Förderbeitrag',
'','',deals.agent,'','','',deals.product,NULL,'neu',
CURDATE(),'0000-00-00',
deals.cycle,'',
CONCAT(deals.contact,deals.product,'1'), ps.sign_date, pt.creditor_id,'RCUR', ''
FROM deals 
INNER JOIN account acc ON acc.client_id=deals.contact 
INNER JOIN contacts cl ON cl.id=deals.contact 
INNER JOIN target_accounts pt ON pt.id=deals.target_account
WHERE acc.status!='passive' 
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
	function buildBookingsFirstSQL():String {
//TODO: TEST booking_day 11|27
		return comment(unindent,format)/*
		INSERT IGNORE buchungs_anforderungen SELECT pt.name, pt.iban, pt.bic, acc.account_holder, '', '', '',  acc.iban, '', deals.amount, '', 'BASIS',
		-- REAL BOOKING DAY
		CASE
			WHEN deals.booking_day!='' AND SUBSTR('$bdate',9)!=deals.booking_day THEN
				CASE
					WHEN deals.booking_day<$bday THEN 
						CONCAT(SUBSTR(adddate(last_day(CURDATE()), 1),1,8),deals.booking_day)
					ELSE CONCAT(SUBSTR('$bdate',1,8),deals.booking_day)
				END
			ELSE '$bdate'
		END,
	CONCAT('Förderer-NR. ',acc.client_id),'Förderbeitrag',
	'','',deals.agent,'','','',deals.product,NULL,'neu',
	CURDATE(),'0000-00-00',
	deals.cycle,'',
	CONCAT(deals.contact,deals.product,'1'), acc.sign_date,'DE28ZZZ00001362509','FRST', ''
	FROM accounts AS acc, target_accounts AS pt, deals 
	INNER JOIN contacts cl ON cl.id=deals.contact
	WHERE acc.status!='passive' 
	AND deals.pay_plan_state!='passive'
	AND deals.contact=acc.client_id
	AND deals.start_day='$sday'
	AND deals.account=acc.id
	AND cl.state='active'
	AND cl.old_active=0 
	AND (cl.register_off_to='0000-00-00' OR cl.register_off_to>'$sdate')
	AND (deals.start_date<'$sdate')
	-- BELOW LOOKS LIKE OVERKILL
	AND pt.id=CASEtarget_id=2,2,CASEdeals.product='3',3,1))
	*/;
	}
	//INNER JOIN target_accounts pt ON pt.id=deals.target_account
	
	public function createDirectDebitsCSV() {
		init();
		trace(buildBookingsFirstSQL());
		S.send('OK');
	}
}