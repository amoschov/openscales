package org.openscales.core.basetypes
{
	import org.openscales.core.Util;
	import org.openscales.core.StringUtils;
	
	public class Element
	{
		
		public function Element():void {
		}
		
		public static function visible(element:Object):Boolean {
    		return new Util().getElement(element).style.display != "none";
		}
		
		public static function toggle(arguments:Object):void {
			for (var i:int = 0; i < arguments.length; i++) {
				var element:Object = new Util().getElement(arguments[i]);
				Element[Element.visible(element) ? 'hide' : 'show'](element);
		    }
		}
		
		public static function hide(arguments:Object):void {
			for (var i:int = 0; i < arguments.length; i++) {
				var element:Object = new Util().getElement(arguments[i]);
				element.visible = false;
			}
		}

  		public static function show(arguments:Object):void {
			for (var i :int= 0; i < arguments.length; i++) {
				var element:Object = new Util().getElement(arguments[i]);
				element.visible = true;
			}
		}

  		public function remove(element:Object):void {
		    element = new Util().getElement(element);
		    element.parent.removeChild(element);
  		}

		public function getHeight(element:Object):Number {
			element = new Util().getElement(element);
			return element.height;
		}

		public static function getDimensions(element:Object):Object {
		    element = new Util().getElement(element);
		    if (Element.getStyle(element, 'display') != 'none')
		      return {width: element.offsetWidth, height: element.offsetHeight};
		
		    var originalVisibility:String = element.style.visibility;
		    var originalPosition:String = element.style.position;
		    element.style.visibility = "hidden";
		    element.style.position = "absolute";
		    element.style.display = "";
		    var originalWidth:Number = element.width;
		    var originalHeight:Number = element.height;
		    element.style.display = "none";
		    element.style.position = originalPosition;
		    element.style.visibility = originalVisibility;
		    return {width: originalWidth, height: originalHeight};
  		}

  		public static function getStyle(element:Object, style:String):Boolean {
		    element = new Util().getElement(element);
		    var value:String = element.style[StringUtils.camelize(style)];
		
		    return value == "auto" ? false : value;
		}
	}
}