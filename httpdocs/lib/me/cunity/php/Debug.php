<?php
/**
 * Generated by Haxe 4.1.1
 * Haxe source file: /opt/src/lib/me/cunity/php/Debug.hx
 */

namespace me\cunity\php;

use \php\Boot;

class Debug {
	/**
	 * @var string
	 */
	static public $logFile;

	/**
	 * @param mixed $v
	 * @param object $i
	 * 
	 * @return void
	 */
	public static function _trace ($v, $i = null) {
		#/opt/src/lib/me/cunity/php/Debug.hx:21: characters 3-95
		$info = ($i !== null ? ($i->fileName??'null') . ":" . ($i->methodName??'null') . ":" . ($i->lineNumber??'null') . ":" : "");
		#/opt/src/lib/me/cunity/php/Debug.hx:25: lines 25-26
		if (Debug::$logFile === null) {
			#/opt/src/lib/me/cunity/php/Debug.hx:26: characters 4-10
			return;
		}
		#/opt/src/lib/me/cunity/php/Debug.hx:28: lines 28-31
		file_put_contents(Debug::$logFile, ($info??'null') . ":" . (((is_string($v) || Boot::isOfType($v, Boot::getClass('Int')) || (is_float($v) || is_int($v)) ? (\Std::string($v)??'null') . "\x0A" : print_r($v,1)))??'null'), 8);
	}

	/**
	 * @param mixed $message
	 * @param int $stackPos
	 * 
	 * @return void
	 */
	public static function dump ($message, $stackPos = 0) {
		#/opt/src/lib/me/cunity/php/Debug.hx:16: characters 3-50
		if ($stackPos === null) {
			$stackPos = 0;
		}
		edump($message,$stackPos);
	}
}

Boot::registerClass(Debug::class, 'me.cunity.php.Debug');
