<?php
/**
 * Generated by Haxe 4.1.1
 * Haxe source file: src/Util.hx
 */

use \php\_Boot\HxDynamicStr;
use \php\_Boot\HxAnon;
use \php\Boot;
use \haxe\Log;
use \shared\DbData;
use \haxe\iterators\MapKeyValueIterator;
use \haxe\ds\StringMap;
use \php\_NativeIndexedArray\NativeIndexedArrayIterator;

/**
 * ...
 * @author axel@cunity.me
 */
class Util {
	/**
	 * @param mixed $v
	 * 
	 * @return bool
	 */
	public static function any2bool ($v) {
		#src/Util.hx:19: characters 10-41
		if (($v !== null) && !Boot::equal($v, 0)) {
			#src/Util.hx:19: characters 34-40
			return $v !== "";
		} else {
			#src/Util.hx:19: characters 10-41
			return false;
		}
	}

	/**
	 * @param string $table
	 * @param \PDOStatement $stmt
	 * @param mixed $row
	 * @param DbData $dbData
	 * 
	 * @return void
	 */
	public static function bindClientData ($table, $stmt, $row, $dbData) {
		#src/Util.hx:24: characters 3-60
		$meta = \S::columnsMeta($table);
		#src/Util.hx:30: characters 17-40
		$_g = new MapKeyValueIterator($meta);
		#src/Util.hx:30: lines 30-62
		while ($_g->hasNext()) {
			#src/Util.hx:30: characters 17-40
			$_g1 = $_g->next();
			$k = $_g1->key;
			$v = $_g1->value;
			#src/Util.hx:32: lines 32-33
			if (!array_key_exists($k, $row)) {
				#src/Util.hx:33: characters 5-13
				continue;
			}
			#src/Util.hx:34: characters 4-28
			$kv = $row[$k];
			#src/Util.hx:35: characters 4-36
			$pdoType = $v["pdo_type"];
			#src/Util.hx:36: lines 36-55
			if (($kv === null) || Boot::equal(HxDynamicStr::wrap($kv)->indexOf("0000-00-00"), 0) || ($kv === "")) {
				#src/Util.hx:39: characters 13-29
				$__hx__switch = ($v["native_type"]);
				if ($__hx__switch === "int8") {
					#src/Util.hx:53: characters 7-13
					$kv = 0;
				} else if ($__hx__switch === "text" || $__hx__switch === "varchar") {
					#src/Util.hx:51: characters 7-14
					$kv = "";
				} else if ($__hx__switch === "date" || $__hx__switch === "datetime" || $__hx__switch === "timestamp") {
					#src/Util.hx:42: characters 7-31
					$pdoType = \PDO::PARAM_NULL;
				} else if ($__hx__switch === "timestamptz") {
					#src/Util.hx:44: characters 7-30
					$pdoType = \PDO::PARAM_STR;
					#src/Util.hx:45: characters 7-12
					(Log::$trace)($pdoType, new HxAnon([
						"fileName" => "src/Util.hx",
						"lineNumber" => 45,
						"className" => "Util",
						"methodName" => "bindClientData",
					]));
					#src/Util.hx:46: characters 7-30
					$pdoType = \PDO::PARAM_INT;
					#src/Util.hx:47: characters 7-12
					(Log::$trace)($pdoType, new HxAnon([
						"fileName" => "src/Util.hx",
						"lineNumber" => 47,
						"className" => "Util",
						"methodName" => "bindClientData",
					]));
					#src/Util.hx:48: characters 7-15
					continue;
				}
			}
			#src/Util.hx:57: lines 57-61
			if (!$stmt->bindValue(":" . ($k??'null'), $kv, $pdoType)) {
				#src/Util.hx:60: characters 25-56
				$_g2 = new StringMap();
				$value = "" . (\Std::string($kv)??'null') . ":" . ($pdoType??'null');
				$_g2->data["bindValue"] = $value;
				#src/Util.hx:60: characters 5-57
				\S::sendErrors($dbData, $_g2, new HxAnon([
					"fileName" => "src/Util.hx",
					"lineNumber" => 60,
					"className" => "Util",
					"methodName" => "bindClientData",
				]));
			}
		}
	}

	/**
	 * @param string $table
	 * @param \PDOStatement $stmt
	 * @param mixed $row
	 * @param DbData $dbData
	 * 
	 * @return void
	 */
	public static function bindClientDataNum ($table, $stmt, $row, $dbData) {
		#src/Util.hx:67: characters 3-60
		$meta = \S::columnsMeta($table);
		#src/Util.hx:69: characters 3-17
		$i = 0;
		#src/Util.hx:70: characters 17-40
		$_g = new MapKeyValueIterator($meta);
		#src/Util.hx:70: lines 70-98
		while ($_g->hasNext()) {
			#src/Util.hx:70: characters 17-40
			$_g1 = $_g->next();
			$k = $_g1->key;
			$v = $_g1->value;
			#src/Util.hx:75: characters 4-36
			$pdoType = $v["pdo_type"];
			#src/Util.hx:77: lines 77-90
			if (($row[$i] === null) || Boot::equal(HxDynamicStr::wrap($row[$i])->indexOf("0000-00-00"), 0) || ($row[$i] === "")) {
				#src/Util.hx:81: characters 13-29
				$__hx__switch = ($v["native_type"]);
				if ($__hx__switch === "int8") {
					#src/Util.hx:88: characters 6-16
					$row[$i] = 0;
				} else if ($__hx__switch === "text" || $__hx__switch === "varchar") {
					#src/Util.hx:86: characters 6-17
					$row[$i] = "";
				} else if ($__hx__switch === "date" || $__hx__switch === "datetime" || $__hx__switch === "timestamp") {
					#src/Util.hx:84: characters 6-30
					$pdoType = \PDO::PARAM_NULL;
				}
			}
			#src/Util.hx:92: lines 92-96
			if (!$stmt->bindValue(":" . ($k??'null'), $row[$i], $pdoType)) {
				#src/Util.hx:95: characters 25-60
				$_g2 = new StringMap();
				$value = "" . (\Std::string($row[$i])??'null') . ":" . ($pdoType??'null');
				$_g2->data["bindValue"] = $value;
				#src/Util.hx:95: characters 5-61
				\S::sendErrors($dbData, $_g2, new HxAnon([
					"fileName" => "src/Util.hx",
					"lineNumber" => 95,
					"className" => "Util",
					"methodName" => "bindClientDataNum",
				]));
			}
			#src/Util.hx:97: characters 4-7
			++$i;
		}
	}

	/**
	 * @param mixed $source1
	 * @param mixed $source2
	 * 
	 * @return mixed
	 */
	public static function copy ($source1, $source2 = null) {
		#src/Util.hx:133: characters 3-19
		$target = new HxAnon();
		#src/Util.hx:134: lines 134-135
		$_g = 0;
		$_g1 = \Reflect::fields($source1);
		while ($_g < $_g1->length) {
			#src/Util.hx:134: characters 8-13
			$field = ($_g1->arr[$_g] ?? null);
			#src/Util.hx:134: lines 134-135
			++$_g;
			#src/Util.hx:135: characters 4-66
			\Reflect::setField($target, $field, \Reflect::field($source1, $field));
		}
		#src/Util.hx:136: lines 136-138
		if ($source2 !== null) {
			#src/Util.hx:137: lines 137-138
			$_g = 0;
			$_g1 = \Reflect::fields($source2);
			while ($_g < $_g1->length) {
				#src/Util.hx:137: characters 9-14
				$field = ($_g1->arr[$_g] ?? null);
				#src/Util.hx:137: lines 137-138
				++$_g;
				#src/Util.hx:138: characters 5-67
				\Reflect::setField($target, $field, \Reflect::field($source2, $field));
			}
		}
		#src/Util.hx:139: characters 3-16
		return $target;
	}

	/**
	 * @param StringMap $m
	 * @param mixed $obj
	 * 
	 * @return void
	 */
	public static function copy2map ($m, $obj) {
		#src/Util.hx:127: lines 127-128
		$_g = 0;
		$_g1 = \Reflect::fields($obj);
		while ($_g < $_g1->length) {
			#src/Util.hx:127: characters 8-13
			$field = ($_g1->arr[$_g] ?? null);
			#src/Util.hx:127: lines 127-128
			++$_g;
			#src/Util.hx:128: characters 4-43
			$value = \Reflect::field($obj, $field);
			$m->data[$field] = $value;
		}
	}

	/**
	 * @param StringMap $source
	 * @param StringMap $source2
	 * 
	 * @return StringMap
	 */
	public static function copyStringMap ($source, $source2 = null) {
		#src/Util.hx:144: characters 3-38
		$copy = new StringMap();
		#src/Util.hx:145: characters 3-28
		$keys = new NativeIndexedArrayIterator(array_values(array_map("strval", array_keys($source->data))));
		#src/Util.hx:146: lines 146-150
		while ($keys->hasNext()) {
			#src/Util.hx:148: characters 4-31
			$k = $keys->next();
			#src/Util.hx:149: characters 4-30
			$value = ($source->data[$k] ?? null);
			$copy->data[$k] = $value;
		}
		#src/Util.hx:151: lines 151-152
		if ($source2 !== null) {
			#src/Util.hx:152: characters 4-25
			$keys = new NativeIndexedArrayIterator(array_values(array_map("strval", array_keys($source2->data))));
		}
		#src/Util.hx:153: lines 153-157
		while ($keys->hasNext()) {
			#src/Util.hx:155: characters 5-32
			$k = $keys->next();
			#src/Util.hx:156: characters 5-32
			$value = ($source2->data[$k] ?? null);
			$copy->data[$k] = $value;
		}
		#src/Util.hx:158: characters 3-14
		return $copy;
	}

	/**
	 * @return mixed
	 */
	public static function initNativeArray () {
		#src/Util.hx:163: characters 3-28
		return ((array)(null));
	}

	/**
	 * @return int
	 */
	public static function limit () {
		#src/Util.hx:174: characters 3-8
		(Log::$trace)((\S::$params->data["limit"] ?? null), new HxAnon([
			"fileName" => "src/Util.hx",
			"lineNumber" => 174,
			"className" => "Util",
			"methodName" => "limit",
		]));
		#src/Util.hx:175: characters 10-92
		if (array_key_exists("limit", \S::$params->data) && ((\S::$params->data["limit"] ?? null) !== null)) {
			#src/Util.hx:175: characters 65-86
			return (\S::$params->data["limit"] ?? null);
		} else {
			#src/Util.hx:175: characters 87-91
			return 1000;
		}
	}

	/**
	 * Convert NativeArray to Map
	 * @param row NativeArray
	 * @param keys Array<String>
	 * @return Map<String,Dynamic>
	 * 
	 * @param mixed $row
	 * @param \Array_hx $keys
	 * 
	 * @return StringMap
	 */
	public static function map2fields ($row, $keys) {
		#src/Util.hx:111: characters 3-8
		(Log::$trace)($keys, new HxAnon([
			"fileName" => "src/Util.hx",
			"lineNumber" => 111,
			"className" => "Util",
			"methodName" => "map2fields",
		]));
		#src/Util.hx:112: lines 112-115
		$_g = new StringMap();
		#src/Util.hx:113: lines 113-114
		$_g1 = 0;
		#src/Util.hx:113: characters 13-74
		$result = [];
		$data = $keys->arr;
		$_g_current = 0;
		$_g_length = count($data);
		$_g_data = $data;
		while ($_g_current < $_g_length) {
			$item = $_g_data[$_g_current++];
			if (array_key_exists($item, $row)) {
				$result[] = $item;
			}
		}
		#src/Util.hx:113: lines 113-114
		$_g2 = \Array_hx::wrap($result);
		while ($_g1 < $_g2->length) {
			#src/Util.hx:113: characters 8-9
			$k = ($_g2->arr[$_g1] ?? null);
			#src/Util.hx:113: lines 113-114
			++$_g1;
			#src/Util.hx:114: characters 5-16
			$_g->data[$k] = $row[$k];
		}
		#src/Util.hx:112: lines 112-115
		return $_g;
	}

	/**
	 * @param mixed $row
	 * @param \Array_hx $keys
	 * 
	 * @return StringMap
	 */
	public static function map2fieldsNum ($row, $keys) {
		#src/Util.hx:119: characters 3-17
		$i = 0;
		#src/Util.hx:120: lines 120-123
		$_g = new StringMap();
		#src/Util.hx:121: lines 121-122
		$_g1 = 0;
		while ($_g1 < $keys->length) {
			#src/Util.hx:121: characters 8-9
			$k = ($keys->arr[$_g1] ?? null);
			#src/Util.hx:121: lines 121-122
			++$_g1;
			#src/Util.hx:122: characters 5-18
			$_g->data[$k] = $row[$i++];
		}
		#src/Util.hx:120: lines 120-123
		return $_g;
	}

	/**
	 * @return int
	 */
	public static function minId () {
		#src/Util.hx:167: lines 167-170
		if (((\S::$params->data["offset"] ?? null) !== null) && (\Std::parseInt((\S::$params->data["offset"] ?? null)) !== null)) {
			#src/Util.hx:169: characters 4-48
			return \Std::parseInt((\S::$params->data["offset"] ?? null)) + 9999999;
		} else {
			#src/Util.hx:170: characters 4-11
			return 9999999;
		}
	}

	/**
	 * @param int $length
	 * @param string $charactersToUse
	 * 
	 * @return string
	 */
	public static function randomString ($length, $charactersToUse = "abcdefghijklmnopqrstuvwxyz_§!%ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") {
		#src/Util.hx:186: characters 3-47
		if ($charactersToUse === null) {
			$charactersToUse = "abcdefghijklmnopqrstuvwxyz_§!%ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		}
		return \Random::string($length, $charactersToUse);
	}
}

Boot::registerClass(Util::class, 'Util');
