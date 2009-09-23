package org.openscales.core
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.xml.XMLNode;

	import org.openscales.core.StringUtils;

	public class Util
	{

		public function Util() {

		}

		/**
		 * Copy all properties of a source object to a destination object.
		 * Modifies the passed in destination object.
		 *
		 * @param destination The object that will be modified
		 * @param source The object with properties to be set on the destination
		 *
		 * @return The destination object
		 */
		public static function extend(destination:Object, source:Object):Object {
			for (var property:String in source) {
				destination[property] = source[property];
			}
			return destination;
		}

		/**
		 * Remove an item of an array
		 *
		 * @param array the array containing items
		 * @param item item to remove
		 *
		 * @return the new array
		 */
		public static function removeItem(array:Array, item:Object):Array {
			for(var i:int=0; i < array.length; i++) {
				if(array[i] == item) {
					array.splice(i,1);
				}
			}
			return array;
		}

		/**
		 * Get the index of an object in an array
		 *
		 * @param array array containning items
		 * @param obj Item that we find index
		 *
		 * @return index of the item
		 */
		public static function indexOf(array:Array, obj:Object):int {
			for(var i:int=0; i < array.length; i++) {
				if (array[i] == obj) return i;
			}
			return -1;
		}

		/**
		 * Normalise scale
		 *
		 * @param scale
		 *
		 * @return return a normalized scale value, in 1 / X format
		 */
		public static function normalizeScale(scale:Number):Number {
			var normScale:Number = (scale > 1.0) ? (1.0 / scale)
				: scale;
			return normScale;
		}

		/**
		 * Store all the keys of the Object in uppercase
		 *
		 * @param object
		 *
		 * @return a new Object with all the same keys but uppercased
		 */
		public static function upperCaseObject(object:Object):Object {
			var uObject:Object = new Object();
			for (var key:String in object) {
				uObject[key.toUpperCase()] = object[key];
			}
			return uObject;
		}

		/**
		 * Get parameter
		 *
		 * @param params
		 *
		 * @return A concatenation of the properties of an object in http parameter notation
		 */
		public static function getParameterString(params:Object):String {
			var paramsArray:Array = new Array();

			for (var key:String in params) {
				var value:Object = params[key];
				if ((value != null) && (typeof value != 'function')) {
					var encodedValue:Object;
					if (typeof value == 'object' && value.constructor == Array) {
						/* value is an array; encode items and separate with "," */
						var encodedItemArray:Array = new Array();
						for (var itemIndex:int=0; itemIndex<value.length; itemIndex++) {
							encodedItemArray.push(encodeURIComponent(value[itemIndex]));
						}
						encodedValue = encodedItemArray.join(",");
					}
					else {
						/* value is a string; simply encode */
						encodedValue = encodeURIComponent(value.toString());
					}
					paramsArray.push(encodeURIComponent(key) + "=" + encodedValue);
				}
			}

			return paramsArray.join("&");
		}

		/**
		 * Get Ags
		 *
		 * @param url
		 *
		 * @return An object of key/value pairs from the query string
		 */
		public static function getArgs(url:String = null):Object {
			if (url == null) {
				url = "";
			}
			var query:String = (url.indexOf('?') != -1) ? url.substring(url.indexOf('?') + 1)
				: '';

			var args:Object = new Object();
			var pairs:Array = query.split(/[&;]/);
			for(var i:int = 0; i < pairs.length; ++i) {
				var keyValue:Array = pairs[i].split(/=/);
				if(keyValue.length == 2) {
					args[decodeURIComponent(keyValue[0])] =
						decodeURIComponent(keyValue[1]);
				}
			}
			return args;
		}

		public static function pagePosition(forElement:Object):Array {

			var element:Object = forElement;
			var globalPoint:Point = element.localToGlobal(new Point(0, 0));

			return [globalPoint.x, globalPoint.y];
		}

		public static function mouseLeft(evt:MouseEvent, can:DisplayObject):Boolean {
			var target:Object = evt.currentTarget

			while (target != can && target != null) {
				target = target.parent;
			}

			return (target != can);
		}

		/**
		 * Convert decimal degrees number into sexagecimal degrees string.
		 *
		 * @param dec decimal degrees.
		 * @param locals the axis direction (N, S) or (E, W). If undefined, null or empty, the leading
		 *               minus will prefix the decimal degrees string.
		 * @param numDigits number of figures in tenth of second.
		 *
		 * @return the sexagecimal value whose syntax conforms with dmsToDeg() function.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9
		 * @author didier.richard@ign.fr
		 */
		public static function degToDMS ( dec:Number, locals:Array= null, numDigits:Number= 1) : String {
			var positive_degrees:Number= Math.abs(dec);
			var degrees:Number= Math.round(positive_degrees + 0.5) - 1;
			var decimal_part:Number= 60*(positive_degrees - degrees);
			var minutes:Number= Math.round(decimal_part + 0.5) - 1;
			decimal_part= 60*(decimal_part - minutes);
			var seconds:Number= Math.round(decimal_part + 0.5) - 1;
			if (isNaN(numDigits) || numDigits<0) {
				numDigits= 1;
			}
			var k:Number= Math.pow(10, numDigits);
			var remains:Number= k * (decimal_part - seconds);
			remains= Math.round(remains + 0.5) - 1;
			if (remains>=k) {
				seconds= seconds+1;
				remains= 0;
			}
			if (seconds==60) {
				minutes= minutes+1;
				seconds= 0;
			}
			if (minutes==60) {
				degrees= degrees+1;
				minutes= 0;
			}
			var dir:String= "";
			if (locals && (locals is Array) && locals.length==2) {
				dir= " " + (dec > 0 ? locals[0] : locals[1]);
			} else {
				if (dec<0) {
					degrees= -1*degrees;
				}
			}

			var s:String= StringUtils.sprintf("%4d° %02d' %02d", degrees, minutes, seconds) +
				(numDigits>0?
				StringUtils.sprintf(".%0*d", numDigits, remains)
				:   "") +
				"\"" +
				dir;
			return s;
		}

		/**
		 * Convert a string representation of a sexagecimal degrees into a numeric representation of
		 * decimal degrees.
		 *
		 * @param dms a sexagecimal value. The supported syntax is :
		 * <listing version="3.0">
		 *    \s?-?(\d{1,3})[.,°d]?\s?(\d{0,2})[']?\s?(\d{0,2})[.,]?(\d{0,})(?:["]|[']{2})?
		 *    |
		 *    \s?(\d{1,3})[.,°d]?\s?(\d{0,2})[']?\s?(\d{0,2})[.,]?(\d{0,})(?:["]|[']{2})?\s?([NSEW])?
		 * </listing>
		 *
		 * @return the decimal value or NaN if error occurs.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9
		 * @author didier.richard@ign.fr
		 */
		public static function dmsToDeg ( dms:String ) : Number {
			if (dms==null) {
				return NaN;
			}
			var neg:Number= dms.match(/(^\s?-)|(\s?[SW]\s?$)/)!=null? -1.0 : 1.0;
			dms= dms.replace(/(^\s?-)|(\s?[NSEW]\s?)$/,'');
			dms= dms.replace(/\s/g,'');
			var parts:Array=
				dms.match(/(\d{1,3})[.,°d]?(\d{0,2})[']?(\d{0,2})[.,]?(\d{0,})(?:["]|[']{2})?/);
			if (parts==null) {
				return NaN;
			}
			// parts:
			// 0 : degrees
			// 1 : degrees
			// 2 : minutes
			// 3 : seconds
			// 4 : fractions of seconds
			var d:Number= parseFloat(parts[1]?         parts[1]  : "0.0");
			var m:Number= parseFloat(parts[2]?         parts[2]  : "0.0");
			var s:Number= parseFloat(parts[3]?         parts[3]  : "0.0");
			var r:Number= parseFloat(parts[4]? ("0." + parts[4]) : "0.0");
			var dec:Number= (d + (m/60.0) + (s/3600.0) + (r/3600.0))*neg;
			return dec;
		}

		/**
		 * Return sqrt(x<sup>2</sup> +y<sup>2</sup>) without intermediate overflow or underflow.
		 * Special cases:<ul>
		 * <li>If either argument is infinite, then the result is positive infinity.</li>
		 * <li>If either argument is NaN and neither argument is infinite, then the result is NaN.</li>
		 * </ul>
		 * The computed result must be within 1 ulp of the exact result. If one parameter is held
		 * constant, the results must be semi-monotonic in the other parameter.
		 *
		 * @param x a value.
		 * @param y a value.
		 *
		 * @return sqrt(x<sup>2</sup> +y<sup>2</sup>) without intermediate overflow or underflow.
		 */
		public function hypot ( x:Number, y:Number ) : Number {
			if (!isFinite(x) || !isFinite(y)) {
				return Infinity;
			}
			if (isNaN(x) || isNaN(y)) {
				return NaN;
			}
			x= Math.abs(x);
			y= Math.abs(y);
			var r:Number, q:Number;
			if (x>y) {
				r= y/x;
				q= x;
			} else if (y>0.0) {
				r= x/y;
				q= y;
			} else {
				return 0.0;
			}
			if (r==Number.MIN_VALUE) {
				return q;
			}
			r*=r;
			if (r==Number.MIN_VALUE) {
				return q;
			}
			r= q*Math.sqrt(1.0+r*r);
			return r;
		}

	}

}

