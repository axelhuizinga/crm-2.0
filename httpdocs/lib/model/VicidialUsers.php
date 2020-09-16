<?php
/**
 * Generated by Haxe 4.1.1
 * Haxe source file: src/model/VicidialUsers.hx
 */

namespace model;

use \php\_Boot\HxAnon;
use \php\Boot;
use \haxe\Log;
use \haxe\ds\StringMap;

class VicidialUsers extends \Model {
	/**
	 * @param StringMap $param
	 * 
	 * @return void
	 */
	public function __construct ($param) {
		#src/model/VicidialUsers.hx:21: characters 3-15
		parent::__construct($param);
	}

	/**
	 * @param string $user
	 * 
	 * @return string
	 */
	public function ex_user ($user = null) {
		#src/model/VicidialUsers.hx:54: characters 3-27
		$user = \S::$dbh->quote($user);
		#src/model/VicidialUsers.hx:55: characters 3-91
		$ex_user_data = $this->query("SELECT * FROM fly_crm.agent_ids WHERE ANr=" . ($user??'null'));
		#src/model/VicidialUsers.hx:56: characters 3-12
		return "";
	}

	/**
	 * @param string $user
	 * 
	 * @return \Array_hx
	 */
	public function get_info ($user = null) {
		#src/model/VicidialUsers.hx:28: characters 3-41
		$sqlBf = new \StringBuf();
		#src/model/VicidialUsers.hx:29: characters 3-52
		$phValues = new \Array_hx();
		#src/model/VicidialUsers.hx:30: characters 3-44
		$result = new \Array_hx();
		#src/model/VicidialUsers.hx:31: characters 3-44
		$param = new StringMap();
		#src/model/VicidialUsers.hx:32: characters 3-48
		$param->data["table"] = "asterisk.vicidial_users";
		#src/model/VicidialUsers.hx:33: characters 3-57
		$param->data["fields"] = "user,user_level, pass,full_name";
		#src/model/VicidialUsers.hx:34: characters 3-85
		$param->data["filter"] = ($user === null ? "user_group|LIKE|AGENT%,active|Y" : "user|" . ($user??'null'));
		#src/model/VicidialUsers.hx:36: characters 3-27
		$param->data["limit"] = "50";
		#src/model/VicidialUsers.hx:37: characters 3-40
		$userMap = $this->doSelect();
		#src/model/VicidialUsers.hx:38: characters 3-8
		(Log::$trace)(($param === null ? "null" : $param->toString()), new HxAnon([
			"fileName" => "src/model/VicidialUsers.hx",
			"lineNumber" => 38,
			"className" => "model.VicidialUsers",
			"methodName" => "get_info",
		]));
		#src/model/VicidialUsers.hx:41: characters 13-17
		$_g = 0;
		#src/model/VicidialUsers.hx:41: characters 17-25
		$_g1 = $this->num_rows;
		#src/model/VicidialUsers.hx:41: lines 41-48
		while ($_g < $_g1) {
			#src/model/VicidialUsers.hx:41: characters 13-25
			$n = $_g++;
			#src/model/VicidialUsers.hx:45: characters 18-36
			$userMap1 = $userMap[$n]["user"];
			#src/model/VicidialUsers.hx:46: characters 23-46
			$userMap2 = $userMap[$n]["full_name"];
			#src/model/VicidialUsers.hx:43: lines 43-47
			$result->arr[$result->length++] = new HxAnon([
				"user" => $userMap1,
				"full_name" => $userMap2,
			]);
		}
		#src/model/VicidialUsers.hx:49: characters 3-16
		return $result;
	}
}

Boot::registerClass(VicidialUsers::class, 'model.VicidialUsers');
