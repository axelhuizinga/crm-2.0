<?php
/**
 * Generated by Haxe 4.1.1
 * Haxe source file: /usr/share/haxe/std/php/_std/Type.hx
 */

use \php\_Boot\HxAnon;
use \php\Boot;
use \php\_Boot\HxClass;
use \php\_Boot\HxString;
use \haxe\Exception as HaxeException;
use \php\_Boot\HxClosure;
use \php\_Boot\HxEnum;

/**
 * The Haxe Reflection API allows retrieval of type information at runtime.
 * This class complements the more lightweight Reflect class, with a focus on
 * class and enum instances.
 * @see https://haxe.org/manual/types.html
 * @see https://haxe.org/manual/std-reflection.html
 */
class Type {
	/**
	 * Returns a list of all constructors of enum `e` that require no
	 * arguments.
	 * This may return the empty Array `[]` if all constructors of `e` require
	 * arguments.
	 * Otherwise an instance of `e` constructed through each of its non-
	 * argument constructors is returned, in the order of the constructor
	 * declaration.
	 * If `e` is null, the result is unspecified.
	 * 
	 * @param Enum $e
	 * 
	 * @return \Array_hx
	 */
	public static function allEnums ($e) {
		#/usr/share/haxe/std/php/_std/Type.hx:337: lines 337-338
		if ($e === null) {
			#/usr/share/haxe/std/php/_std/Type.hx:338: characters 4-15
			return null;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:340: characters 3-43
		$phpName = $e->phpClassName;
		#/usr/share/haxe/std/php/_std/Type.hx:342: characters 3-19
		$result = new \Array_hx();
		#/usr/share/haxe/std/php/_std/Type.hx:344: lines 344-349
		$_g = 0;
		$_g1 = Type::getEnumConstructs($e);
		while ($_g < $_g1->length) {
			#/usr/share/haxe/std/php/_std/Type.hx:344: characters 8-12
			$name = ($_g1->arr[$_g] ?? null);
			#/usr/share/haxe/std/php/_std/Type.hx:344: lines 344-349
			++$_g;
			#/usr/share/haxe/std/php/_std/Type.hx:345: characters 4-57
			$reflection = new \ReflectionMethod($phpName, $name);
			#/usr/share/haxe/std/php/_std/Type.hx:346: lines 346-348
			if ($reflection->getNumberOfParameters() === 0) {
				#/usr/share/haxe/std/php/_std/Type.hx:347: characters 5-41
				$x = $reflection->invoke(null);
				$result->arr[$result->length++] = $x;
			}
		}
		#/usr/share/haxe/std/php/_std/Type.hx:351: characters 3-16
		return $result;
	}

	/**
	 * Creates an instance of class `cl`.
	 * This function guarantees that the class constructor is not called.
	 * If `cl` is null, the result is unspecified.
	 * 
	 * @param Class $cl
	 * 
	 * @return mixed
	 */
	public static function createEmptyInstance ($cl) {
		#/usr/share/haxe/std/php/_std/Type.hx:131: lines 131-132
		if (Boot::getClass('String') === $cl) {
			#/usr/share/haxe/std/php/_std/Type.hx:132: characters 4-18
			return "";
		}
		#/usr/share/haxe/std/php/_std/Type.hx:133: lines 133-134
		if (Boot::getClass(\Array_hx::class) === $cl) {
			#/usr/share/haxe/std/php/_std/Type.hx:134: characters 4-18
			return new \Array_hx();
		}
		#/usr/share/haxe/std/php/_std/Type.hx:136: characters 3-68
		$reflection = new \ReflectionClass($cl->phpClassName);
		#/usr/share/haxe/std/php/_std/Type.hx:137: characters 3-52
		return $reflection->newInstanceWithoutConstructor();
	}

	/**
	 * Creates an instance of enum `e` by calling its constructor `constr` with
	 * arguments `params`.
	 * If `e` or `constr` is null, or if enum `e` has no constructor named
	 * `constr`, or if the number of elements in `params` does not match the
	 * expected number of constructor arguments, or if any argument has an
	 * invalid type, the result is unspecified.
	 * 
	 * @param Enum $e
	 * @param string $constr
	 * @param \Array_hx $params
	 * 
	 * @return mixed
	 */
	public static function createEnum ($e, $constr, $params = null) {
		#/usr/share/haxe/std/php/_std/Type.hx:141: lines 141-142
		if (($e === null) || ($constr === null)) {
			#/usr/share/haxe/std/php/_std/Type.hx:142: characters 4-15
			return null;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:144: characters 3-43
		$phpName = $e->phpClassName;
		#/usr/share/haxe/std/php/_std/Type.hx:146: lines 146-148
		if (!in_array($constr, $phpName::__hx__list())) {
			#/usr/share/haxe/std/php/_std/Type.hx:147: characters 4-9
			throw HaxeException::thrown("No such constructor " . ($constr??'null'));
		}
		#/usr/share/haxe/std/php/_std/Type.hx:150: characters 3-92
		$paramsCounts = $phpName::__hx__paramsCount();
		#/usr/share/haxe/std/php/_std/Type.hx:151: lines 151-153
		if ((($params === null) && ($paramsCounts[$constr] !== 0)) || (($params !== null) && ($params->length !== $paramsCounts[$constr]))) {
			#/usr/share/haxe/std/php/_std/Type.hx:152: characters 4-9
			throw HaxeException::thrown("Provided parameters count does not match expected parameters count");
		}
		#/usr/share/haxe/std/php/_std/Type.hx:155: lines 155-160
		if ($params === null) {
			#/usr/share/haxe/std/php/_std/Type.hx:156: characters 4-45
			return $phpName::{$constr}();
		} else {
			#/usr/share/haxe/std/php/_std/Type.hx:158: characters 4-60
			$nativeArgs = $params->arr;
			#/usr/share/haxe/std/php/_std/Type.hx:159: characters 4-71
			return $phpName::{$constr}(...$nativeArgs);
		}
	}

	/**
	 * Creates an instance of class `cl`, using `args` as arguments to the
	 * class constructor.
	 * This function guarantees that the class constructor is called.
	 * Default values of constructors arguments are not guaranteed to be
	 * taken into account.
	 * If `cl` or `args` are null, or if the number of elements in `args` does
	 * not match the expected number of constructor arguments, or if any
	 * argument has an invalid type,  or if `cl` has no own constructor, the
	 * result is unspecified.
	 * In particular, default values of constructor arguments are not
	 * guaranteed to be taken into account.
	 * 
	 * @param Class $cl
	 * @param \Array_hx $args
	 * 
	 * @return mixed
	 */
	public static function createInstance ($cl, $args) {
		#/usr/share/haxe/std/php/_std/Type.hx:123: lines 123-124
		if (Boot::getClass('String') === $cl) {
			#/usr/share/haxe/std/php/_std/Type.hx:124: characters 4-18
			return ($args->arr[0] ?? null);
		}
		#/usr/share/haxe/std/php/_std/Type.hx:126: characters 3-57
		$nativeArgs = $args->arr;
		#/usr/share/haxe/std/php/_std/Type.hx:127: characters 27-53
		$tmp = $cl->phpClassName;
		#/usr/share/haxe/std/php/_std/Type.hx:127: characters 3-80
		return new $tmp(...$nativeArgs);
	}

	/**
	 * Recursively compares two enum instances `a` and `b` by value.
	 * Unlike `a == b`, this function performs a deep equality check on the
	 * arguments of the constructors, if exists.
	 * If `a` or `b` are null, the result is unspecified.
	 * 
	 * @param mixed $a
	 * @param mixed $b
	 * 
	 * @return bool
	 */
	public static function enumEq ($a, $b) {
		#/usr/share/haxe/std/php/_std/Type.hx:293: lines 293-294
		if (($a === $b)) {
			#/usr/share/haxe/std/php/_std/Type.hx:294: characters 4-15
			return true;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:295: lines 295-296
		if (($a === null) || ($b === null)) {
			#/usr/share/haxe/std/php/_std/Type.hx:296: characters 4-16
			return false;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:298: lines 298-321
		try {
			#/usr/share/haxe/std/php/_std/Type.hx:299: characters 30-63
			$tmp = get_class($b);
			#/usr/share/haxe/std/php/_std/Type.hx:299: lines 299-300
			if (!($a instanceof $tmp)) {
				#/usr/share/haxe/std/php/_std/Type.hx:300: characters 5-17
				return false;
			}
			#/usr/share/haxe/std/php/_std/Type.hx:301: lines 301-302
			if ($a->index !== $b->index) {
				#/usr/share/haxe/std/php/_std/Type.hx:302: characters 5-17
				return false;
			}
			#/usr/share/haxe/std/php/_std/Type.hx:304: characters 4-75
			$aParams = $a->params;
			#/usr/share/haxe/std/php/_std/Type.hx:305: characters 4-75
			$bParams = $b->params;
			#/usr/share/haxe/std/php/_std/Type.hx:306: characters 14-18
			$_g = 0;
			#/usr/share/haxe/std/php/_std/Type.hx:306: characters 18-39
			$_g1 = count($aParams);
			#/usr/share/haxe/std/php/_std/Type.hx:306: lines 306-316
			while ($_g < $_g1) {
				#/usr/share/haxe/std/php/_std/Type.hx:306: characters 14-39
				$i = $_g++;
				#/usr/share/haxe/std/php/_std/Type.hx:308: lines 308-315
				if (($aParams[$i] instanceof HxEnum)) {
					#/usr/share/haxe/std/php/_std/Type.hx:309: lines 309-311
					if (!Type::enumEq($aParams[$i], $bParams[$i])) {
						#/usr/share/haxe/std/php/_std/Type.hx:310: characters 7-19
						return false;
					}
				} else {
					#/usr/share/haxe/std/php/_std/Type.hx:313: characters 17-58
					$left = $aParams[$i];
					$right = $bParams[$i];
					#/usr/share/haxe/std/php/_std/Type.hx:313: lines 313-315
					if (!(((is_int($left) || is_float($left)) && (is_int($right) || is_float($right)) ? ($left == $right) : (($left instanceof HxClosure) && ($right instanceof HxClosure) ? $left->equals($right) : ($left === $right))))) {
						#/usr/share/haxe/std/php/_std/Type.hx:314: characters 6-18
						return false;
					}
				}
			}
			#/usr/share/haxe/std/php/_std/Type.hx:318: characters 4-15
			return true;
		} catch(\Throwable $_g) {
			#/usr/share/haxe/std/php/_std/Type.hx:320: characters 4-16
			return false;
		}
	}

	/**
	 * Returns the class of `o`, if `o` is a class instance.
	 * If `o` is null or of a different type, null is returned.
	 * In general, type parameter information cannot be obtained at runtime.
	 * 
	 * @param mixed $o
	 * 
	 * @return Class
	 */
	public static function getClass ($o) {
		#/usr/share/haxe/std/php/_std/Type.hx:43: lines 43-50
		if (is_object($o) && !($o instanceof HxClass) && !($o instanceof HxEnum)) {
			#/usr/share/haxe/std/php/_std/Type.hx:44: characters 4-54
			$cls = Boot::getClass(get_class($o));
			#/usr/share/haxe/std/php/_std/Type.hx:45: characters 11-54
			if ($cls === Boot::getClass(HxAnon::class)) {
				#/usr/share/haxe/std/php/_std/Type.hx:45: characters 38-42
				return null;
			} else {
				#/usr/share/haxe/std/php/_std/Type.hx:45: characters 45-53
				return $cls;
			}
		} else if (is_string($o)) {
			#/usr/share/haxe/std/php/_std/Type.hx:47: characters 4-22
			return Boot::getClass('String');
		} else {
			#/usr/share/haxe/std/php/_std/Type.hx:49: characters 4-15
			return null;
		}
	}

	/**
	 * Returns a list of static fields of class `c`.
	 * This does not include static fields of parent classes.
	 * The order of the fields in the returned Array is unspecified.
	 * If `c` is null, the result is unspecified.
	 * 
	 * @param Class $c
	 * 
	 * @return \Array_hx
	 */
	public static function getClassFields ($c) {
		#/usr/share/haxe/std/php/_std/Type.hx:226: lines 226-227
		if ($c === null) {
			#/usr/share/haxe/std/php/_std/Type.hx:227: characters 4-15
			return null;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:228: lines 228-229
		if ($c === Boot::getClass('String')) {
			#/usr/share/haxe/std/php/_std/Type.hx:229: characters 4-27
			return \Array_hx::wrap(["fromCharCode"]);
		}
		#/usr/share/haxe/std/php/_std/Type.hx:231: characters 3-43
		$phpName = $c->phpClassName;
		#/usr/share/haxe/std/php/_std/Type.hx:233: characters 3-49
		$reflection = new \ReflectionClass($phpName);
		#/usr/share/haxe/std/php/_std/Type.hx:235: characters 17-34
		$this1 = [];
		#/usr/share/haxe/std/php/_std/Type.hx:235: characters 3-35
		$methods = $this1;
		#/usr/share/haxe/std/php/_std/Type.hx:236: characters 13-62
		$data = $reflection->getMethods(\ReflectionMethod::IS_STATIC);
		$_g_current = 0;
		$_g_length = count($data);
		$_g_data = $data;
		#/usr/share/haxe/std/php/_std/Type.hx:236: lines 236-241
		while ($_g_current < $_g_length) {
			$m = $_g_data[$_g_current++];
			#/usr/share/haxe/std/php/_std/Type.hx:237: characters 4-27
			$name = $m->getName();
			#/usr/share/haxe/std/php/_std/Type.hx:238: lines 238-240
			if (!(($name === "__construct") || (HxString::indexOf($name, "__hx_") === 0)) && ($phpName === $m->getDeclaringClass()->getName())) {
				#/usr/share/haxe/std/php/_std/Type.hx:239: characters 5-29
				array_push($methods, $name);
			}
		}
		#/usr/share/haxe/std/php/_std/Type.hx:243: characters 20-37
		$this1 = [];
		#/usr/share/haxe/std/php/_std/Type.hx:243: characters 3-38
		$properties = $this1;
		#/usr/share/haxe/std/php/_std/Type.hx:244: characters 13-67
		$data = $reflection->getProperties(\ReflectionProperty::IS_STATIC);
		$_g1_current = 0;
		$_g1_length = count($data);
		$_g1_data = $data;
		#/usr/share/haxe/std/php/_std/Type.hx:244: lines 244-249
		while ($_g1_current < $_g1_length) {
			$p = $_g1_data[$_g1_current++];
			#/usr/share/haxe/std/php/_std/Type.hx:245: characters 4-27
			$name = $p->getName();
			#/usr/share/haxe/std/php/_std/Type.hx:246: lines 246-248
			if (!(($name === "__construct") || (HxString::indexOf($name, "__hx_") === 0)) && ($phpName === $p->getDeclaringClass()->getName())) {
				#/usr/share/haxe/std/php/_std/Type.hx:247: characters 5-32
				array_push($properties, $name);
			}
		}
		#/usr/share/haxe/std/php/_std/Type.hx:250: characters 3-13
		$properties = array_diff($properties, $methods);
		#/usr/share/haxe/std/php/_std/Type.hx:251: characters 3-56
		$fields = array_merge($properties, $methods);
		#/usr/share/haxe/std/php/_std/Type.hx:253: characters 3-44
		return \Array_hx::wrap($fields);
	}

	/**
	 * Returns the name of class `c`, including its path.
	 * If `c` is inside a package, the package structure is returned dot-
	 * separated, with another dot separating the class name:
	 * `pack1.pack2.(...).packN.ClassName`
	 * If `c` is a sub-type of a Haxe module, that module is not part of the
	 * package structure.
	 * If `c` has no package, the class name is returned.
	 * If `c` is null, the result is unspecified.
	 * The class name does not include any type parameters.
	 * 
	 * @param Class $c
	 * 
	 * @return string
	 */
	public static function getClassName ($c) {
		#/usr/share/haxe/std/php/_std/Type.hx:69: lines 69-70
		if ($c === null) {
			#/usr/share/haxe/std/php/_std/Type.hx:70: characters 4-15
			return null;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:71: characters 3-34
		return Boot::getHaxeName($c);
	}

	/**
	 * Returns a list of the names of all constructors of enum `e`.
	 * The order of the constructor names in the returned Array is preserved
	 * from the original syntax.
	 * If `e` is null, the result is unspecified.
	 * 
	 * @param Enum $e
	 * 
	 * @return \Array_hx
	 */
	public static function getEnumConstructs ($e) {
		#/usr/share/haxe/std/php/_std/Type.hx:257: lines 257-258
		if ($e === null) {
			#/usr/share/haxe/std/php/_std/Type.hx:258: characters 4-15
			return null;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:259: characters 3-66
		return \Array_hx::wrap($e->__hx__list());
	}

	/**
	 * Returns a list of the instance fields of class `c`, including
	 * inherited fields.
	 * This only includes fields which are known at compile-time. In
	 * particular, using `getInstanceFields(getClass(obj))` will not include
	 * any fields which were added to `obj` at runtime.
	 * The order of the fields in the returned Array is unspecified.
	 * If `c` is null, the result is unspecified.
	 * 
	 * @param Class $c
	 * 
	 * @return \Array_hx
	 */
	public static function getInstanceFields ($c) {
		#/usr/share/haxe/std/php/_std/Type.hx:189: lines 189-190
		if ($c === null) {
			#/usr/share/haxe/std/php/_std/Type.hx:190: characters 4-15
			return null;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:191: lines 191-195
		if ($c === Boot::getClass('String')) {
			#/usr/share/haxe/std/php/_std/Type.hx:192: lines 192-194
			return \Array_hx::wrap([
				"substr",
				"charAt",
				"charCodeAt",
				"indexOf",
				"lastIndexOf",
				"split",
				"toLowerCase",
				"toUpperCase",
				"toString",
				"length",
			]);
		}
		#/usr/share/haxe/std/php/_std/Type.hx:197: characters 3-67
		$reflection = new \ReflectionClass($c->phpClassName);
		#/usr/share/haxe/std/php/_std/Type.hx:199: characters 17-34
		$this1 = [];
		#/usr/share/haxe/std/php/_std/Type.hx:199: characters 3-35
		$methods = $this1;
		#/usr/share/haxe/std/php/_std/Type.hx:200: characters 18-41
		$data = $reflection->getMethods();
		$_g_current = 0;
		$_g_length = count($data);
		$_g_data = $data;
		#/usr/share/haxe/std/php/_std/Type.hx:200: lines 200-207
		while ($_g_current < $_g_length) {
			$method = $_g_data[$_g_current++];
			#/usr/share/haxe/std/php/_std/Type.hx:201: lines 201-206
			if (!$method->isStatic()) {
				#/usr/share/haxe/std/php/_std/Type.hx:202: characters 5-33
				$name = $method->getName();
				#/usr/share/haxe/std/php/_std/Type.hx:203: lines 203-205
				if (!(($name === "__construct") || (HxString::indexOf($name, "__hx_") === 0))) {
					#/usr/share/haxe/std/php/_std/Type.hx:204: characters 6-30
					array_push($methods, $name);
				}
			}
		}
		#/usr/share/haxe/std/php/_std/Type.hx:209: characters 20-37
		$this1 = [];
		#/usr/share/haxe/std/php/_std/Type.hx:209: characters 3-38
		$properties = $this1;
		#/usr/share/haxe/std/php/_std/Type.hx:210: characters 20-46
		$data = $reflection->getProperties();
		$_g1_current = 0;
		$_g1_length = count($data);
		$_g1_data = $data;
		#/usr/share/haxe/std/php/_std/Type.hx:210: lines 210-217
		while ($_g1_current < $_g1_length) {
			$property = $_g1_data[$_g1_current++];
			#/usr/share/haxe/std/php/_std/Type.hx:211: lines 211-216
			if (!$property->isStatic()) {
				#/usr/share/haxe/std/php/_std/Type.hx:212: characters 5-35
				$name = $property->getName();
				#/usr/share/haxe/std/php/_std/Type.hx:213: lines 213-215
				if (!(($name === "__construct") || (HxString::indexOf($name, "__hx_") === 0))) {
					#/usr/share/haxe/std/php/_std/Type.hx:214: characters 6-33
					array_push($properties, $name);
				}
			}
		}
		#/usr/share/haxe/std/php/_std/Type.hx:218: characters 3-13
		$properties = array_diff($properties, $methods);
		#/usr/share/haxe/std/php/_std/Type.hx:220: characters 3-56
		$fields = array_merge($properties, $methods);
		#/usr/share/haxe/std/php/_std/Type.hx:222: characters 3-44
		return \Array_hx::wrap($fields);
	}

	/**
	 * Returns the super-class of class `c`.
	 * If `c` has no super class, null is returned.
	 * If `c` is null, the result is unspecified.
	 * In general, type parameter information cannot be obtained at runtime.
	 * 
	 * @param Class $c
	 * 
	 * @return Class
	 */
	public static function getSuperClass ($c) {
		#/usr/share/haxe/std/php/_std/Type.hx:60: lines 60-61
		if ($c === null) {
			#/usr/share/haxe/std/php/_std/Type.hx:61: characters 4-15
			return null;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:62: characters 3-68
		$parentClass = get_parent_class($c->phpClassName);
		#/usr/share/haxe/std/php/_std/Type.hx:63: lines 63-64
		if (!$parentClass) {
			#/usr/share/haxe/std/php/_std/Type.hx:64: characters 4-15
			return null;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:65: characters 3-41
		return Boot::getClass($parentClass);
	}

	/**
	 * Resolves a class by name.
	 * If `name` is the path of an existing class, that class is returned.
	 * Otherwise null is returned.
	 * If `name` is null or the path to a different type, the result is
	 * unspecified.
	 * The class name must not include any type parameters.
	 * 
	 * @param string $name
	 * 
	 * @return Class
	 */
	public static function resolveClass ($name) {
		#/usr/share/haxe/std/php/_std/Type.hx:79: lines 79-80
		if ($name === null) {
			#/usr/share/haxe/std/php/_std/Type.hx:80: characters 4-15
			return null;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:81: lines 81-96
		if ($name === "Bool") {
			#/usr/share/haxe/std/php/_std/Type.hx:89: characters 5-21
			return Boot::getClass('Bool');
		} else if ($name === "Class") {
			#/usr/share/haxe/std/php/_std/Type.hx:93: characters 5-22
			return Boot::getClass('Class');
		} else if ($name === "Dynamic") {
			#/usr/share/haxe/std/php/_std/Type.hx:83: characters 5-24
			return Boot::getClass('Dynamic');
		} else if ($name === "Enum") {
			#/usr/share/haxe/std/php/_std/Type.hx:95: characters 5-21
			return Boot::getClass('Enum');
		} else if ($name === "Float") {
			#/usr/share/haxe/std/php/_std/Type.hx:87: characters 5-22
			return Boot::getClass('Float');
		} else if ($name === "Int") {
			#/usr/share/haxe/std/php/_std/Type.hx:85: characters 5-20
			return Boot::getClass('Int');
		} else if ($name === "String") {
			#/usr/share/haxe/std/php/_std/Type.hx:91: characters 5-18
			return Boot::getClass('String');
		}
		#/usr/share/haxe/std/php/_std/Type.hx:98: characters 3-40
		$phpClass = Boot::getPhpName($name);
		#/usr/share/haxe/std/php/_std/Type.hx:99: lines 99-100
		if (!class_exists($phpClass) && !interface_exists($phpClass)) {
			#/usr/share/haxe/std/php/_std/Type.hx:100: characters 4-15
			return null;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:102: characters 3-41
		$hxClass = Boot::getClass($phpClass);
		#/usr/share/haxe/std/php/_std/Type.hx:104: characters 3-22
		return $hxClass;
	}

	/**
	 * Resolves an enum by name.
	 * If `name` is the path of an existing enum, that enum is returned.
	 * Otherwise null is returned.
	 * If `name` is null the result is unspecified.
	 * If `name` is the path to a different type, null is returned.
	 * The enum name must not include any type parameters.
	 * 
	 * @param string $name
	 * 
	 * @return Enum
	 */
	public static function resolveEnum ($name) {
		#/usr/share/haxe/std/php/_std/Type.hx:108: lines 108-109
		if ($name === null) {
			#/usr/share/haxe/std/php/_std/Type.hx:109: characters 4-15
			return null;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:110: lines 110-111
		if ($name === "Bool") {
			#/usr/share/haxe/std/php/_std/Type.hx:111: characters 4-20
			return Boot::getClass('Bool');
		}
		#/usr/share/haxe/std/php/_std/Type.hx:113: characters 3-40
		$phpClass = Boot::getPhpName($name);
		#/usr/share/haxe/std/php/_std/Type.hx:114: lines 114-115
		if (!class_exists($phpClass)) {
			#/usr/share/haxe/std/php/_std/Type.hx:115: characters 4-15
			return null;
		}
		#/usr/share/haxe/std/php/_std/Type.hx:117: characters 3-41
		$hxClass = Boot::getClass($phpClass);
		#/usr/share/haxe/std/php/_std/Type.hx:119: characters 3-22
		return $hxClass;
	}

	/**
	 * Returns the runtime type of value `v`.
	 * The result corresponds to the type `v` has at runtime, which may vary
	 * per platform. Assumptions regarding this should be minimized to avoid
	 * surprises.
	 * 
	 * @param mixed $v
	 * 
	 * @return \ValueType
	 */
	public static function typeof ($v) {
		#/usr/share/haxe/std/php/_std/Type.hx:263: lines 263-264
		if ($v === null) {
			#/usr/share/haxe/std/php/_std/Type.hx:264: characters 4-16
			return \ValueType::TNull();
		}
		#/usr/share/haxe/std/php/_std/Type.hx:266: lines 266-278
		if (is_object($v)) {
			#/usr/share/haxe/std/php/_std/Type.hx:267: lines 267-268
			if (($v instanceof \Closure) || ($v instanceof HxClosure)) {
				#/usr/share/haxe/std/php/_std/Type.hx:268: characters 5-21
				return \ValueType::TFunction();
			}
			#/usr/share/haxe/std/php/_std/Type.hx:269: lines 269-270
			if (($v instanceof \StdClass)) {
				#/usr/share/haxe/std/php/_std/Type.hx:270: characters 5-19
				return \ValueType::TObject();
			}
			#/usr/share/haxe/std/php/_std/Type.hx:271: lines 271-272
			if (($v instanceof HxClass)) {
				#/usr/share/haxe/std/php/_std/Type.hx:272: characters 5-19
				return \ValueType::TObject();
			}
			#/usr/share/haxe/std/php/_std/Type.hx:274: characters 4-53
			$hxClass = Boot::getClass(get_class($v));
			#/usr/share/haxe/std/php/_std/Type.hx:275: lines 275-276
			if (($v instanceof HxEnum)) {
				#/usr/share/haxe/std/php/_std/Type.hx:276: characters 5-31
				return \ValueType::TEnum($hxClass);
			}
			#/usr/share/haxe/std/php/_std/Type.hx:277: characters 4-31
			return \ValueType::TClass($hxClass);
		}
		#/usr/share/haxe/std/php/_std/Type.hx:280: lines 280-281
		if (is_bool($v)) {
			#/usr/share/haxe/std/php/_std/Type.hx:281: characters 4-16
			return \ValueType::TBool();
		}
		#/usr/share/haxe/std/php/_std/Type.hx:282: lines 282-283
		if (is_int($v)) {
			#/usr/share/haxe/std/php/_std/Type.hx:283: characters 4-15
			return \ValueType::TInt();
		}
		#/usr/share/haxe/std/php/_std/Type.hx:284: lines 284-285
		if (is_float($v)) {
			#/usr/share/haxe/std/php/_std/Type.hx:285: characters 4-17
			return \ValueType::TFloat();
		}
		#/usr/share/haxe/std/php/_std/Type.hx:286: lines 286-287
		if (is_string($v)) {
			#/usr/share/haxe/std/php/_std/Type.hx:287: characters 4-25
			return \ValueType::TClass(Boot::getClass('String'));
		}
		#/usr/share/haxe/std/php/_std/Type.hx:289: characters 3-18
		return \ValueType::TUnknown();
	}
}

Boot::registerClass(Type::class, 'Type');
