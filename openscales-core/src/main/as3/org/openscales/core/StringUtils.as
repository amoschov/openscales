package org.openscales.core
{
	public class StringUtils
	{
		
		public static function startsWith(sStart:String):Boolean {
			return (sStart.substr(0,sStart.length) == sStart);
		}
		
		public static function contains(str:String):Boolean {
			return (indexOf(str) != -1);
		}
		
		public static function indexOf(object:Object):int {
			 for (var i:int = 0; i < length; i++)
			     if (StringUtils[i] == object) return i;
			 return -1;
		}
		
		public static function camelize(str:String):String {
			var oStringList:Array = str.split('-');
		    if (oStringList.length == 1) return oStringList[0];
		
		    var camelizedString:String = indexOf('-') == 0
		      ? oStringList[0].charAt(0).toUpperCase() + oStringList[0].substring(1)
		      : oStringList[0];
		
			var len:int = oStringList.length;
		    for (var i:int = 1; i < len; i++) {
		      var s:String = oStringList[i];
		      camelizedString += s.charAt(0).toUpperCase() + s.substring(1);
		    }
		
		    return camelizedString;
		}
		
		public static function trim(str:String):String {
			var pattern:RegExp = new RegExp("^\\s*(.*?)\\s*$", "g");
			return str.replace(pattern, '$1');
		}
	}
}