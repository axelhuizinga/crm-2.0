<?php
/**
 * Generated by Haxe 4.1.1
 * Haxe source file: src/model/admin/SyncExternalBookings.hx
 */

namespace model\admin;

use \php\_Boot\HxAnon;
use \php\Boot;
use \haxe\Log;
use \php\Lib;
use \haxe\ds\StringMap;
use \php\_NativeIndexedArray\NativeIndexedArrayIterator;

class SyncExternalBookings extends \Model {
	/**
	 * @var \Array_hx
	 */
	static public $dKeys;

	/**
	 * @var int
	 */
	public $synced;

	/**
	 * @param StringMap $param
	 * 
	 * @return void
	 */
	public function __construct ($param) {
		#src/model/admin/SyncExternalBookings.hx:17: characters 3-15
		parent::__construct($param);
		#src/model/admin/SyncExternalBookings.hx:18: characters 3-37
		$this->tableNames->offsetSet(0, ($param->data["table"] ?? null));
		#src/model/admin/SyncExternalBookings.hx:19: characters 3-40
		$v = \Std::string($this->count());
		$param->data["offset"] = $v;
		#src/model/admin/SyncExternalBookings.hx:22: lines 22-26
		if (array_key_exists("offset", $param->data)) {
			#src/model/admin/SyncExternalBookings.hx:24: characters 4-33
			$this->synced = ($param->data["offset"] ?? null);
		} else {
			#src/model/admin/SyncExternalBookings.hx:26: characters 8-18
			$this->synced = 0;
		}
		#src/model/admin/SyncExternalBookings.hx:28: characters 9-14
		(Log::$trace)("calling " . ($this->action??'null'), new HxAnon([
			"fileName" => "src/model/admin/SyncExternalBookings.hx",
			"lineNumber" => 28,
			"className" => "model.admin.SyncExternalBookings",
			"methodName" => "new",
		]));
		#src/model/admin/SyncExternalBookings.hx:29: characters 3-8
		(Log::$trace)($this->action, new HxAnon([
			"fileName" => "src/model/admin/SyncExternalBookings.hx",
			"lineNumber" => 29,
			"className" => "model.admin.SyncExternalBookings",
			"methodName" => "new",
		]));
		#src/model/admin/SyncExternalBookings.hx:31: characters 10-16
		$__hx__switch = ($this->action);
		if ($__hx__switch === "syncAll") {
			#src/model/admin/SyncExternalBookings.hx:33: characters 5-14
			$this->syncAll();
		} else if ($__hx__switch === "syncBookingRequests") {
			#src/model/admin/SyncExternalBookings.hx:35: characters 5-45
			$this->syncBookingRequests(\S::$dbh, $this->getCrmData());
		} else {
			#src/model/admin/SyncExternalBookings.hx:37: characters 5-10
			$this->run();
		}
	}

	/**
	 * @return mixed
	 */
	public function getCrmData () {
		#src/model/admin/SyncExternalBookings.hx:98: characters 3-48
		$firstBatch = ($this->param->data["offset"] ?? null) === "0";
		#src/model/admin/SyncExternalBookings.hx:99: characters 3-36
		$selectTotalCount = "";
		#src/model/admin/SyncExternalBookings.hx:100: lines 100-105
		if (\Std::parseInt(($this->param->data["limit"] ?? null)) > 10000) {
			#src/model/admin/SyncExternalBookings.hx:102: characters 4-53
			ini_set('max_execution_time',3600);
			#src/model/admin/SyncExternalBookings.hx:103: characters 4-47
			ini_set('memory_limit','1G');
			#src/model/admin/SyncExternalBookings.hx:104: characters 4-9
			(Log::$trace)(ini_get('memory_limit'), new HxAnon([
				"fileName" => "src/model/admin/SyncExternalBookings.hx",
				"lineNumber" => 104,
				"className" => "model.admin.SyncExternalBookings",
				"methodName" => "getCrmData",
			]));
		}
		#src/model/admin/SyncExternalBookings.hx:106: characters 3-8
		(Log::$trace)("offset:" . (\Std::string(($this->param->data["offset"] ?? null))??'null') . " firstBatch:" . (\Std::string($firstBatch)??'null') . " ", new HxAnon([
			"fileName" => "src/model/admin/SyncExternalBookings.hx",
			"lineNumber" => 106,
			"className" => "model.admin.SyncExternalBookings",
			"methodName" => "getCrmData",
		]));
		#src/model/admin/SyncExternalBookings.hx:107: lines 107-110
		if ($firstBatch) {
			#src/model/admin/SyncExternalBookings.hx:109: characters 4-44
			$selectTotalCount = "SQL_CALC_FOUND_ROWS";
		}
		#src/model/admin/SyncExternalBookings.hx:111: lines 111-115
		$sql = "\x0A\x09\x09SELECT * FROM buchungs_anforderungen\x0AORDER BY Termin  \x0ALIMIT \x0A";
		#src/model/admin/SyncExternalBookings.hx:116: characters 9-129
		$stmt = \S::$syncDbh->query("" . ($sql??'null') . " " . (\Std::parseInt(($this->param->data["limit"] ?? null))??'null') . " OFFSET " . (\Std::parseInt(($this->param->data["offset"] ?? null))??'null'));
		#src/model/admin/SyncExternalBookings.hx:117: characters 3-8
		(Log::$trace)("loading  " . (\Std::parseInt(($this->param->data["limit"] ?? null))??'null') . " OFFSET " . (\Std::parseInt(($this->param->data["offset"] ?? null))??'null'), new HxAnon([
			"fileName" => "src/model/admin/SyncExternalBookings.hx",
			"lineNumber" => 117,
			"className" => "model.admin.SyncExternalBookings",
			"methodName" => "getCrmData",
		]));
		#src/model/admin/SyncExternalBookings.hx:118: lines 118-122
		if ($stmt === false) {
			#src/model/admin/SyncExternalBookings.hx:120: characters 4-9
			(Log::$trace)("" . ($sql??'null') . " " . (\Std::parseInt(($this->param->data["limit"] ?? null))??'null'), new HxAnon([
				"fileName" => "src/model/admin/SyncExternalBookings.hx",
				"lineNumber" => 120,
				"className" => "model.admin.SyncExternalBookings",
				"methodName" => "getCrmData",
			]));
			#src/model/admin/SyncExternalBookings.hx:121: characters 17-23
			$tmp = $this->dbData;
			#src/model/admin/SyncExternalBookings.hx:121: characters 25-69
			$_g = new StringMap();
			$value = \S::$syncDbh->errorInfo();
			$_g->data["getCrmData query:"] = $value;
			#src/model/admin/SyncExternalBookings.hx:121: characters 4-70
			\S::sendErrors($tmp, $_g, new HxAnon([
				"fileName" => "src/model/admin/SyncExternalBookings.hx",
				"lineNumber" => 121,
				"className" => "model.admin.SyncExternalBookings",
				"methodName" => "getCrmData",
			]));
		}
		#src/model/admin/SyncExternalBookings.hx:123: lines 123-126
		if ($stmt->errorCode() !== "00000") {
			#src/model/admin/SyncExternalBookings.hx:125: characters 4-9
			(Log::$trace)($stmt->errorInfo(), new HxAnon([
				"fileName" => "src/model/admin/SyncExternalBookings.hx",
				"lineNumber" => 125,
				"className" => "model.admin.SyncExternalBookings",
				"methodName" => "getCrmData",
			]));
		}
		#src/model/admin/SyncExternalBookings.hx:127: characters 3-76
		$res = ($stmt->execute() ? $stmt->fetchAll(\PDO::FETCH_NUM) : null);
		#src/model/admin/SyncExternalBookings.hx:129: lines 129-135
		if ($firstBatch) {
			#src/model/admin/SyncExternalBookings.hx:131: characters 4-49
			$stmt = \S::$syncDbh->query("SELECT FOUND_ROWS()");
			#src/model/admin/SyncExternalBookings.hx:132: characters 4-38
			$totalRes = $stmt->fetchColumn();
			#src/model/admin/SyncExternalBookings.hx:133: characters 4-9
			(Log::$trace)($totalRes, new HxAnon([
				"fileName" => "src/model/admin/SyncExternalBookings.hx",
				"lineNumber" => 133,
				"className" => "model.admin.SyncExternalBookings",
				"methodName" => "getCrmData",
			]));
			#src/model/admin/SyncExternalBookings.hx:134: characters 4-46
			$this->dbData->dataInfo->data["totalRecords"] = $totalRes;
		}
		#src/model/admin/SyncExternalBookings.hx:136: characters 3-13
		return $res;
	}

	/**
	 * @return void
	 */
	public function syncAll () {
		#src/model/admin/SyncExternalBookings.hx:42: characters 3-8
		(Log::$trace)(($this->param === null ? "null" : $this->param->toString()), new HxAnon([
			"fileName" => "src/model/admin/SyncExternalBookings.hx",
			"lineNumber" => 42,
			"className" => "model.admin.SyncExternalBookings",
			"methodName" => "syncAll",
		]));
		#src/model/admin/SyncExternalBookings.hx:45: lines 45-46
		if (($this->param->data["offset"] ?? null) === null) {
			#src/model/admin/SyncExternalBookings.hx:46: characters 4-25
			$this->param->data["offset"] = "0";
		}
		#src/model/admin/SyncExternalBookings.hx:47: lines 47-48
		if (($this->param->data["limit"] ?? null) === null) {
			#src/model/admin/SyncExternalBookings.hx:48: characters 4-27
			$this->param->data["limit"] = "1000";
		}
		#src/model/admin/SyncExternalBookings.hx:53: characters 3-8
		(Log::$trace)(($this->param === null ? "null" : $this->param->toString()), new HxAnon([
			"fileName" => "src/model/admin/SyncExternalBookings.hx",
			"lineNumber" => 53,
			"className" => "model.admin.SyncExternalBookings",
			"methodName" => "syncAll",
		]));
		#src/model/admin/SyncExternalBookings.hx:54: characters 3-43
		$this->syncBookingRequests(\S::$dbh, $this->getCrmData());
		#src/model/admin/SyncExternalBookings.hx:55: characters 16-22
		$tmp = $this->dbData;
		#src/model/admin/SyncExternalBookings.hx:55: characters 23-43
		$_g = new StringMap();
		$_g->data["syncAll"] = "NOTOK";
		#src/model/admin/SyncExternalBookings.hx:55: characters 3-44
		\S::sendErrors($tmp, $_g, new HxAnon([
			"fileName" => "src/model/admin/SyncExternalBookings.hx",
			"lineNumber" => 55,
			"className" => "model.admin.SyncExternalBookings",
			"methodName" => "syncAll",
		]));
	}

	/**
	 * @param \PDO $dbh
	 * @param mixed $bookings
	 * 
	 * @return void
	 */
	public function syncBookingRequests ($dbh, $bookings) {
		#src/model/admin/SyncExternalBookings.hx:60: characters 3-61
		$bookingsRows = count($bookings);
		#src/model/admin/SyncExternalBookings.hx:61: characters 3-8
		(Log::$trace)("bookingsRows:" . ($bookingsRows??'null'), new HxAnon([
			"fileName" => "src/model/admin/SyncExternalBookings.hx",
			"lineNumber" => 61,
			"className" => "model.admin.SyncExternalBookings",
			"methodName" => "syncBookingRequests",
		]));
		#src/model/admin/SyncExternalBookings.hx:63: characters 3-71
		$dD = \Util::map2fieldsNum($bookings[0], SyncExternalBookings::$dKeys);
		#src/model/admin/SyncExternalBookings.hx:64: characters 36-59
		$_g = new \Array_hx();
		#src/model/admin/SyncExternalBookings.hx:64: characters 46-55
		$k = new NativeIndexedArrayIterator(array_values(array_map("strval", array_keys($dD->data))));
		while ($k->hasNext()) {
			#src/model/admin/SyncExternalBookings.hx:64: characters 37-58
			$k1 = $k->next();
			#src/model/admin/SyncExternalBookings.hx:64: characters 57-58
			$_g->arr[$_g->length++] = $k1;
		}
		#src/model/admin/SyncExternalBookings.hx:64: characters 9-60
		$dNames = $_g;
		#src/model/admin/SyncExternalBookings.hx:65: characters 38-58
		$_g = new \Array_hx();
		#src/model/admin/SyncExternalBookings.hx:65: characters 39-57
		$_g1 = 0;
		while ($_g1 < $dNames->length) {
			#src/model/admin/SyncExternalBookings.hx:65: characters 43-44
			$k = ($dNames->arr[$_g1] ?? null);
			#src/model/admin/SyncExternalBookings.hx:65: characters 39-57
			++$_g1;
			#src/model/admin/SyncExternalBookings.hx:65: characters 56-57
			$_g->arr[$_g->length++] = $k;
		}
		#src/model/admin/SyncExternalBookings.hx:65: characters 38-89
		$result = [];
		$data = $_g->arr;
		$_g_current = 0;
		$_g_length = count($data);
		$_g_data = $data;
		while ($_g_current < $_g_length) {
			$item = $_g_data[$_g_current++];
			$result[] = (":" . ($item??'null'));
		}
		#src/model/admin/SyncExternalBookings.hx:65: characters 3-90
		$dPlaceholders = \Array_hx::wrap($result);
		#src/model/admin/SyncExternalBookings.hx:66: lines 66-68
		$_g = new \Array_hx();
		#src/model/admin/SyncExternalBookings.hx:67: characters 4-56
		$_g1 = 0;
		#src/model/admin/SyncExternalBookings.hx:67: characters 13-53
		$result = [];
		$data = $dNames->arr;
		$_g_current = 0;
		$_g_length = count($data);
		$_g_data = $data;
		while ($_g_current < $_g_length) {
			$item = $_g_data[$_g_current++];
			if ($item !== "id") {
				$result[] = $item;
			}
		}
		#src/model/admin/SyncExternalBookings.hx:67: characters 4-56
		$_g2 = \Array_hx::wrap($result);
		while ($_g1 < $_g2->length) {
			#src/model/admin/SyncExternalBookings.hx:67: characters 8-9
			$k = ($_g2->arr[$_g1] ?? null);
			#src/model/admin/SyncExternalBookings.hx:67: characters 4-56
			++$_g1;
			#src/model/admin/SyncExternalBookings.hx:67: characters 55-56
			$_g->arr[$_g->length++] = $k;
		}
		#src/model/admin/SyncExternalBookings.hx:66: lines 66-68
		$result = [];
		$data = $_g->arr;
		$_g_current = 0;
		$_g_length = count($data);
		$_g_data = $data;
		while ($_g_current < $_g_length) {
			$item = $_g_data[$_g_current++];
			$result[] = (" \"" . ($item??'null') . "\"=:" . ($item??'null'));
		}
		$dSet = \Array_hx::wrap($result)->join(",");
		#src/model/admin/SyncExternalBookings.hx:69: lines 69-72
		$sql = "\x0A" . ("INSERT INTO bank_transfers (" . ($dNames->join(",")??'null') . ")\x0A") . ("VALUES (" . ($dPlaceholders->join(",")??'null') . ") ON CONFLICT DO NOTHING;\x09\x09\x09\x09\x0A") . "";
		#src/model/admin/SyncExternalBookings.hx:75: characters 3-65
		$stmt = \S::$dbh->prepare($sql, ((array)(null)));
		#src/model/admin/SyncExternalBookings.hx:76: characters 3-8
		(Log::$trace)($sql, new HxAnon([
			"fileName" => "src/model/admin/SyncExternalBookings.hx",
			"lineNumber" => 76,
			"className" => "model.admin.SyncExternalBookings",
			"methodName" => "syncBookingRequests",
		]));
		#src/model/admin/SyncExternalBookings.hx:77: characters 14-33
		$data = array_values($bookings);
		$_g6_current = 0;
		$_g6_length = count($data);
		$_g6_data = $data;
		#src/model/admin/SyncExternalBookings.hx:77: lines 77-88
		while ($_g6_current < $_g6_length) {
			$row = $_g6_data[$_g6_current++];
			#src/model/admin/SyncExternalBookings.hx:79: characters 4-60
			\Util::bindClientDataNum("bank_transfers", $stmt, $row, $this->dbData);
			#src/model/admin/SyncExternalBookings.hx:80: lines 80-86
			if (!$stmt->execute()) {
				#src/model/admin/SyncExternalBookings.hx:81: characters 5-10
				(Log::$trace)($row, new HxAnon([
					"fileName" => "src/model/admin/SyncExternalBookings.hx",
					"lineNumber" => 81,
					"className" => "model.admin.SyncExternalBookings",
					"methodName" => "syncBookingRequests",
				]));
				#src/model/admin/SyncExternalBookings.hx:82: characters 5-10
				(Log::$trace)($stmt->errorInfo(), new HxAnon([
					"fileName" => "src/model/admin/SyncExternalBookings.hx",
					"lineNumber" => 82,
					"className" => "model.admin.SyncExternalBookings",
					"methodName" => "syncBookingRequests",
				]));
				#src/model/admin/SyncExternalBookings.hx:83: characters 18-24
				$tmp = $this->dbData;
				#src/model/admin/SyncExternalBookings.hx:83: lines 83-85
				$_g = new StringMap();
				$value = Lib::hashOfAssociativeArray($stmt->errorInfo());
				$_g->data["execute"] = $value;
				$_g->data["sql"] = $sql;
				$value1 = \Std::string($row['ba_id']);
				$_g->data["ba_id"] = $value1;
				\S::sendErrors($tmp, $_g, new HxAnon([
					"fileName" => "src/model/admin/SyncExternalBookings.hx",
					"lineNumber" => 83,
					"className" => "model.admin.SyncExternalBookings",
					"methodName" => "syncBookingRequests",
				]));
			}
			#src/model/admin/SyncExternalBookings.hx:87: characters 4-12
			$this->synced++;
		}
		#src/model/admin/SyncExternalBookings.hx:89: characters 9-14
		(Log::$trace)("done", new HxAnon([
			"fileName" => "src/model/admin/SyncExternalBookings.hx",
			"lineNumber" => 89,
			"className" => "model.admin.SyncExternalBookings",
			"methodName" => "syncBookingRequests",
		]));
		#src/model/admin/SyncExternalBookings.hx:90: characters 3-69
		$this1 = $this->dbData->dataInfo;
		$v = \Std::parseInt(($this->param->data["offset"] ?? null)) + $this->synced;
		$this1->data["offset"] = $v;
		#src/model/admin/SyncExternalBookings.hx:91: characters 3-8
		(Log::$trace)(($this->dbData->dataInfo === null ? "null" : $this->dbData->dataInfo->toString()), new HxAnon([
			"fileName" => "src/model/admin/SyncExternalBookings.hx",
			"lineNumber" => 91,
			"className" => "model.admin.SyncExternalBookings",
			"methodName" => "syncBookingRequests",
		]));
		#src/model/admin/SyncExternalBookings.hx:93: characters 14-20
		$tmp = $this->dbData;
		#src/model/admin/SyncExternalBookings.hx:93: characters 21-58
		$_g = new StringMap();
		$value = "OK:" . ($stmt->rowCount()??'null');
		$_g->data["imported"] = $value;
		#src/model/admin/SyncExternalBookings.hx:93: characters 3-59
		\S::sendInfo($tmp, $_g);
	}

	/**
	 * @internal
	 * @access private
	 */
	static public function __hx__init ()
	{
		static $called = false;
		if ($called) return;
		$called = true;


		self::$dKeys = \S::tableFields("bank_transfers");
	}
}

Boot::registerClass(SyncExternalBookings::class, 'model.admin.SyncExternalBookings');
SyncExternalBookings::__hx__init();
