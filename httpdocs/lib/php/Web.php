<?php
/**
 * Generated by Haxe 4.1.1
 * Haxe source file: /usr/share/haxe/std/php/Web.hx
 */

namespace php;


/**
 * This class is used for accessing the local Web server and the current
 * client request and information.
 */
class Web {
	/**
	 * @var bool
	 */
	static public $isModNeko;

	/**
	 * Returns all the POST data. POST Data is always parsed as
	 * being application/x-www-form-urlencoded and is stored into
	 * the getParams hashtable. POST Data is maximimized to 256K
	 * unless the content type is multipart/form-data. In that
	 * case, you will have to use `php.Web.getMultipart()` or
	 * `php.Web.parseMultipart()` methods.
	 * 
	 * @return string
	 */
	public static function getPostData () {
		#/usr/share/haxe/std/php/Web.hx:319: characters 3-37
		$h = fopen("php://input", "r");
		#/usr/share/haxe/std/php/Web.hx:320: characters 3-20
		$bsize = 8192;
		#/usr/share/haxe/std/php/Web.hx:321: characters 3-16
		$max = 32;
		#/usr/share/haxe/std/php/Web.hx:322: characters 3-26
		$data = null;
		#/usr/share/haxe/std/php/Web.hx:323: characters 3-19
		$counter = 0;
		#/usr/share/haxe/std/php/Web.hx:324: lines 324-327
		while (!feof($h) && ($counter < $max)) {
			#/usr/share/haxe/std/php/Web.hx:325: characters 11-47
			$data = ($data . fread($h, $bsize));
			#/usr/share/haxe/std/php/Web.hx:326: characters 4-13
			++$counter;
		}
		#/usr/share/haxe/std/php/Web.hx:328: characters 3-12
		fclose($h);
		#/usr/share/haxe/std/php/Web.hx:329: characters 3-14
		return $data;
	}

	/**
	 * Set a Cookie value in the HTTP headers. Same remark as `php.Web.setHeader()`.
	 * 
	 * @param string $key
	 * @param string $value
	 * @param \Date $expire
	 * @param string $domain
	 * @param string $path
	 * @param bool $secure
	 * @param bool $httpOnly
	 * 
	 * @return void
	 */
	public static function setCookie ($key, $value, $expire = null, $domain = null, $path = null, $secure = null, $httpOnly = null) {
		#/usr/share/haxe/std/php/Web.hx:345: characters 3-67
		$t = ($expire === null ? 0 : (int)(($expire->getTime() / 1000.0)));
		#/usr/share/haxe/std/php/Web.hx:346: lines 346-347
		if ($path === null) {
			#/usr/share/haxe/std/php/Web.hx:347: characters 4-14
			$path = "/";
		}
		#/usr/share/haxe/std/php/Web.hx:348: lines 348-349
		if ($domain === null) {
			#/usr/share/haxe/std/php/Web.hx:349: characters 4-15
			$domain = "";
		}
		#/usr/share/haxe/std/php/Web.hx:350: lines 350-351
		if ($secure === null) {
			#/usr/share/haxe/std/php/Web.hx:351: characters 4-18
			$secure = false;
		}
		#/usr/share/haxe/std/php/Web.hx:352: lines 352-353
		if ($httpOnly === null) {
			#/usr/share/haxe/std/php/Web.hx:353: characters 4-20
			$httpOnly = false;
		}
		#/usr/share/haxe/std/php/Web.hx:354: characters 3-59
		setcookie($key, $value, $t, $path, $domain, $secure, $httpOnly);
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

		#/usr/share/haxe/std/php/Web.hx:480: characters 3-27
		Web::$isModNeko = 0 !== strncasecmp(PHP_SAPI, "cli", 3);

	}
}

Boot::registerClass(Web::class, 'php.Web');
Web::__hx__init();
