package org.openscales {
	import flash.system.Capabilities;

	/**
	 * Some string utilities.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public final class StringUtils {

		/**
		 * The regexp for triming a string : /^\s*(.*?)\s*$/g
		 * <p>the ? quantifier indicates the RegExp engine to take the shortest matching string (so,
		 * not comprising the ending white spaces)</p>
		 * @private
		 */
		private static const _TRIMRX:RegExp=/^\s*(.*?)\s*$/g;

		/**
		 * The regexp form parsing format for sprintf :
		 * /%%|%(\d+\$)?([-+#0 ]*)(\*\d+\$|\*|\d+)?(\.(\*\d+\$|\*|\d+))?([scboxXuidfegEG])/g
		 * <p>The inner matching sub-strings are :
		 * <ul>
		 * <li>(\d+\$)? : format parameter index</li>
		 * <li>([-+#0 ]*) : flags</li>
		 * <li>(\*\d+\$|\*|\d+)? : minimum width</li>
		 * <li>(\.(\*\d+\$|\*|\d+))? : precision</li>
		 * <li>([scboxXuidfegEG]) : size</li>
		 * </ul></p>s
		 * @private
		 */
		private static const _SPRINTF:RegExp=/%%|%(\d+\$)?([-+#0 ]*)(\*\d+\$|\*|\d+)?(\.(\*\d+\$|\*|\d+))?([scboxXuidfegEG])/g;

		/**
		 * Test whether a string starts with another string.
		 *
		 * @param str The string to test.
		 * @param sub The substring to look for.
		 *
		 * @return The first string starts with the second.
		 */
		public static function startsWith(str:String, sub:String):Boolean {
			return str.indexOf(sub) == 0;
		}

		/**
		 * Test whether a string contains another string.
		 *
		 * @param str The string to test.
		 * @param sub The substring to look for.
		 *
		 * @return The first string contains the second.
		 */
		public static function contains(str:String, sub:String):Boolean {
			return str.indexOf(sub) != -1;
		}

		/**
		 * Camel-case a hyphenated string.
		 *     Ex. "chicken-head" becomes "chickenHead", and
		 *     "-chicken-head" becomes "ChickenHead".
		 *
		 * @param str The string to be camelized.  The original is not modified.
		 *
		 * @return The string, camelized
		 */
		public static function camelize(str:String):String {
			var oStringList:Array=str.split("-");
			var camelizedString:String=oStringList[0];

			var s:String;
			for (var i:Number=1, len:Number=oStringList.length; i < len; i++) {
				s=oStringList[i];
				camelizedString+=s.charAt(0).toUpperCase() + s.substring(1);
			}
			return camelizedString;
		}

		/**
		 * Delete leading and ending series of white spaces.
		 *
		 * @example
		 * <listing version="3.0">
		 * Trace.log("["+StringUtils.trim(String("\t \tx y z \t "))+"]");
		 * // renders:[x y z]
		 * </listing>
		 *
		 * @param s the string to trim.
		 *
		 * @return a new string.
		 */
		public static function trim(s:String):String {
			return s != null ? s.replace(_TRIMRX, "$1") : null;
		}

		/**
		 * Given a string with tokens in the form ${token}, return a string with tokens replaced with
		 * properties from the given context object.  Represent a literal "${" by doubling it, e.g.
		 * "${${". Represent a literal "}" by doubling it, e.g. "}}".
		 * <p>This is a port of OpenLayers.BaseType.js format().</p>
		 *
		 * @example
		 * <listing version="3.0">
		 * Trace.log("["+StringUtils.format(String("${{token}}=${token}"),{token:"item"})+"]");
		 * // renders:[${token}=item]
		 * </listing>
		 *
		 * @param template A string with tokens to be replaced.  A templatehas the form "literal
		 *                 ${token}" where the token will be replaced by the value of
		 *                 context["token"].
		 * @param context An object with properties corresponding to the tokens in the
		 *                format string. If no context, the template is returned unchanged.
		 * @param args arguments to pass to any functions found in the context.  If a context
		 *             property is a function, the token will be replaced by the return from the
		 *             function called with these arguments.
		 *
		 * @return a string with tokens replaced with properties from the given context object.
		 */
		public static function format(template:String, context:Object, args:Array=null):String {
			if (template == null) {
				return null;
			}
			if (context == null) {
				return new String(template);
			}
			var tokens:Array=template.split("${");
			var item:String, last:Number, replacement:*;
			for (var i:Number=1, n:Number=tokens.length; i < n; i++) {
				item=tokens[i];
				last=item.indexOf("}");
				if (last > 0) {
					if (item.indexOf("}}") == last) {
						tokens[i]=item.substring(0, last) + item.substring(last + 1);
					} else {
						replacement=context[item.substring(0, last)];
						if (replacement is Function) {
							tokens[i]=args != null ? replacement.apply(null, args) : replacement();
						} else {
							tokens[i]=replacement;
						}
						tokens[i]+=item.substring(++last);
					}
				} else {
					tokens[i]="${" + item;
				}
			}
			return tokens.join("");
		}

		/**
		 * Pad a string.
		 *
		 * @param str the string to pad.
		 * @param len the final length to get.
		 * @param chr the character to use for padding.
		 * @param leftJustify pad to left or right.
		 *
		 * @return the padded string.
		 * @private
		 */
		private static function _pad(str:String, len:Number, chr:String, leftJustify:Boolean):String {
			var padding:String=str.length >= len ? "" : new Array((1 + len - str.length) >>> 0).join(chr);
			return leftJustify ? str + padding : padding + str;
		}

		/**
		 * Justify a string.
		 *
		 * @param value the string to justify.
		 * @param prefix the prefix to apply.
		 * @param leftJustify pad to left or right.
		 * @param minWidth the minimum length of justification.
		 * @param zeroPad use "0" as character padding.
		 *
		 * @return the justified string.
		 * @private
		 */
		private static function _justify(value:String, prefix:String, leftJustify:Boolean, minWidth:Number, zeroPad:Boolean):String {
			var diff:Number=minWidth - value.length;
			if (diff > 0) {
				if (leftJustify || !zeroPad) {
					value=StringUtils._pad(value, minWidth, " ", leftJustify);
				} else {
					value=value.slice(0, prefix.length) + StringUtils._pad("", diff, "0", true) + value.slice(prefix.length);
				}
			}
			return value;
		}

		/**
		 * Format a number.
		 *
		 * @param value the number to format.
		 * @param base the base for formatting ("2", "8", "16").
		 * @param prefix apply base prefix.
		 * @param leftJustify pad to left or right.
		 * @param minWidth the minimum length of justification.
		 * @param precision the number of decimals.
		 * @param zeroPad use "0" as character padding.
		 *
		 * @return the formatted number as a string.
		 * @private
		 */
		private static function _formatBaseX(value:Number, base:String, prefix:Boolean, leftJustify:Boolean, minWidth:Number, precision:Number, zeroPad:Boolean):String {
			// Note: casts negative numbers to positive ones
			var nmbr:Number=value >>> 0;
			var sprefix:String;
			if (!prefix || nmbr == 0) {
				sprefix="";
			} else {
				sprefix={"2": "0b", "8": "0", "16": "0x"}[base] || "";
			}
			var svalue:String=sprefix + StringUtils._pad(nmbr.toString(parseInt(base)), precision || 0, "0", false);
			return StringUtils._justify(svalue, sprefix, leftJustify, minWidth, zeroPad);
		}

		/**
		 * Format a string.
		 *
		 * @param value the string to format.
		 * @param leftJustify pad to left or right.
		 * @param minWidth the minimum length of justification.
		 * @param precision the length to get.
		 * @param zeroPad use "0" as character padding.
		 *
		 * @return the formatted string.
		 * @private
		 */
		private static function _formatString(value:String, leftJustify:Boolean, minWidth:Number, precision:Number, zeroPad:Boolean):String {
			if (!isNaN(precision)) {
				value=value.slice(0, precision);
			}
			return StringUtils._justify(value, "", leftJustify, minWidth, zeroPad);
		}

		/**
		 * Formatting output function, Perl's sprintf based, handling padding, truncation,
		 * floating-point numbers, left/right alignment and re-ordered arguments functionalities.
		 *
		 * @param format string that containts the text to format.
		 * @param args depending on the format string, the function may expect a sequence of
		 *             additional arguments, each containing a value.
		 *
		 * @return The formatted string.
		 *
		 * @see http://hexmen.com/blog/2007/03/printf-sprintf/ for original work
		 * @see http://perldoc.perl.org/functions/sprintf.html
		 */
		public static function sprintf(format:String, ... args):String {
			var i:Number=0;
			return format.replace(_SPRINTF,
				//
				// Replacement function for the sprintf regexp.
				// <p>The arguments are :<ul>
				// <li>The matching portion of the string;</li>
				// <li>Any captured parenthetical group matches are provided as the next
				//     arguments :<ul>
				//      <li>(\d+\$)? : format parameter index</li>
				//      <li>([-+#0 ]*) : flags</li>
				//      <li>(\*\d+\$|\*|\d+)? : minimum width</li>
				//      <li>(\.(\*\d+\$|\*|\d+))? : precision</li>
				//      <li>([scboxXuidfegEG]) : size</li>
				// </ul></li>
				// <li>The index position in the string where the match begins;</li>
				// <li>The complete string.</li>
				// </ul></p>
				//
				// @return the replaced matching portion of the string.
				//
				function():String {
					var subStr:String=arguments[0];
					if (subStr == "%%") {
						return "%";
					}
					// parse flags
					var valueIndex:String=arguments[1];
					var flags:String=arguments[2];
					var minWidth:String=arguments[3];
					var precision:String=arguments[5]; //due to (\.(\*\d+\$|\*|\d+))? 2 groups!
					var type:String=arguments[6];
					var leftJustify:Boolean=false, positivePrefix:String="", prefix:String="", zeroPad:Boolean=false, prefixBaseX:Boolean=false, nmbr:Number, lflags:Number=flags != null ? flags.length : 0;
					if (lflags > 0) {
						for (var j:Number=0; j < lflags; j++) {
							switch (flags.charAt(j)) {
								case " ":
									positivePrefix=" ";
									break;
								case "+":
									positivePrefix="+";
									break;
								case "-":
									leftJustify=true;
									break;
								case "0":
									zeroPad=true;
									break;
								case "#":
									prefixBaseX=true;
									break;
							}
						}
					}
					// parameters may be null, undefined, empty-string or real valued
					// we want to ignore null, undefined and empty-string values
					if (!minWidth) {
						minWidth="0";
					} else if (minWidth == "*") {
						minWidth=args[i++];
					} else if (minWidth.charAt(0) == "*") {
						minWidth=args[parseInt(minWidth.slice(1, -1)) - 1];
					}
					var mW:Number=parseInt(minWidth);
					// Note: undocumented perl feature:
					if (mW < 0) {
						mW=-mW;
						leftJustify=true;
					}
					if (!isFinite(mW)) {
						var msg:String;
						switch (Capabilities.language) {
							case "fr":
								msg="sprintf: (minimum-)width doit être définie.";
								break;
							case "en":
							default:
								msg="sprintf: (minimum-)width must be finite";
								break;
						}
						throw new Error(msg);
					}
					if (!precision) {
						precision="fFeE".indexOf(type) > -1 ? "6" : (type == "d") ? "0" : undefined;
					} else if (precision == "*") {
						precision=args[i++];
					} else if (precision.charAt(0) == "*") {
						precision=args[parseInt(precision.slice(1, -1)) - 1];
					}
					var decimals:Number=parseInt(precision);
					//if (isNaN(decimals)) { decimals= 0; }
					// grab value using valueIndex if required?
					var value:String=valueIndex ? args[parseInt(valueIndex.slice(0, -1)) - 1] : args[i++];
					switch (type) {
						case "s":
							return StringUtils._formatString(String(value), leftJustify, mW, decimals, zeroPad);
						case "c":
							return StringUtils._formatString(String.fromCharCode(parseInt(value)), leftJustify, mW, decimals, zeroPad);
						case "b":
							return StringUtils._formatBaseX(parseInt(value), "2", prefixBaseX, leftJustify, mW, decimals, zeroPad);
						case "o":
							return StringUtils._formatBaseX(parseInt(value), "8", prefixBaseX, leftJustify, mW, decimals, zeroPad);
						case "x":
							return StringUtils._formatBaseX(parseInt(value), "16", prefixBaseX, leftJustify, mW, decimals, zeroPad);
						case "X":
							return StringUtils._formatBaseX(parseInt(value), "16", prefixBaseX, leftJustify, mW, decimals, zeroPad).toUpperCase();
						case "u":
							return StringUtils._formatBaseX(parseInt(value), "10", prefixBaseX, leftJustify, mW, decimals, zeroPad);
						case "i":
						case "d":  {
							nmbr=parseInt(value);
							prefix=nmbr < 0 ? "-" : positivePrefix;
							value=prefix + StringUtils._pad(String(Math.abs(nmbr)), decimals, "0", false);
							return StringUtils._justify(value, prefix, leftJustify, mW, zeroPad);
						}
						case "e":
						case "E":
						case "f":
						case "F":
						case "g":
						case "G":  {
							if (isNaN(decimals)) {
								decimals=(type == "g" || type == "G" ? 4 : 6);
							}
							if (decimals <= 0) {
								decimals=(type == "g" || type == "G" ? 1 : 0);
							}
							if (decimals > 20) {
								decimals=(type == "g" || type == "G" ? 21 : 20);
							}
							nmbr=parseFloat(value);
							prefix=nmbr < 0 ? "-" : positivePrefix;
							var method:String=["toExponential", "toFixed", "toPrecision"]["efg".indexOf(type.toLowerCase())];
							var textTransform:String=["valueOf", "toUpperCase"]["eEfFgG".indexOf(type) % 2];
							value=prefix + Math.abs(nmbr)[method](decimals);
							return StringUtils._justify(value, prefix, leftJustify, mW, zeroPad)[textTransform]();
						}
						default:
							return subStr;
					}
				});
		}

	}

}
