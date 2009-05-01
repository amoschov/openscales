package org.openscales.core
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.xml.XMLNode;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Unit;
	
	public class Util
	{
		
		private static var lastSeqID:Number = 0;
		private var viewRequestID:Number = 0;
		public static var MISSING_TILE_URL:String = "http://openstreetmap.org/openlayers/img/404.png";
		
		public function Util() {
			
		}
	
		public static function extend(destination:Object, source:Object):Object {
		    for (var property:String in source) {
		      destination[property] = source[property];
		    }
		    return destination;
		}
		
		public static function removeItem(array:Array, item:Object):Array {
			for(var i:int=0; i < array.length; i++) {
		        if(array[i] == item) {
		            array.splice(i,1);
		        }
		    }
		    return array;
		}
		
		public static function clearArray(array:Array):void {
			array.length = 0;
		}
		
		public static function indexOf(array:Array, obj:Object):int {
			for(var i:int=0; i < array.length; i++) {
		        if (array[i] == obj) return i;
		    }
		    return -1; 
		}
		
		public static function createUniqueID(prefix:String):String {
			if (prefix == null) {
		        prefix = "id_";
		    }
		    lastSeqID += 1; 
		    return prefix + lastSeqID; 
		}
		
		public function pagePosition(forElement:Object):Array {
			var valueT:Number = 0, valueL:Number = 0;

		    var element:Object = forElement;
		    
		    var pt:Point = new Point(element.x, element.y);
		    pt = element.localToGlobal(pt);
		    valueT = pt.x;
		    valueT = pt.y;
		
		    return [valueL, valueT];
		}
			
		public function normalizeScale(scale:Number):Number {
		    var normScale:Number = (scale > 1.0) ? (1.0 / scale) 
                              : scale;
		    return normScale;
		}
		
		public function getResolutionFromScale(scale:Number, units:String = null):Number {
			
		    if (units == null) {
		        units = Unit.DEGREE;
		    }
		
		    var normScale:Number = this.normalizeScale(scale);
		
		    var resolution:Number = 1 / (normScale * Unit.getInchesPerUnit(units)
		                                    * Unit.DOTS_PER_INCH);
		    return resolution;
		}
		
		public static function getScaleFromResolution(resolution:Number, units:String):Number {
			if (units == null) {
		        units = Unit.DEGREE;
		    }
		
		    var scale:Number = resolution * Unit.getInchesPerUnit(units) *
		                    Unit.DOTS_PER_INCH;
		    return scale;
		}
		
		public static function upperCaseObject(object:Object):Object {
			var uObject:Object = new Object();
		    for (var key:String in object) {
		        uObject[key.toUpperCase()] = object[key];
		    }
		    return uObject;
		}
		
		public static function applyDefaults(toO:Object, fromO:Object):void {
		    for (var key:String in fromO) {
		        if (toO[key] == null) {
		            toO[key] = fromO[key];
		        }
		    }
		}
		
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
		
		public static function getBBOXStringFromUrl(url:String):String {
			var startpos:int = url.indexOf("BBOX=") + 5;
			if (startpos < 5) {
				startpos = url.indexOf("bbox=") + 5;
			}
			var endpos:int = url.indexOf("%26", startpos);
			if (endpos < 0) {
				endpos = url.length;
			}
			var tempbbox:String = url.substring(startpos, endpos);
			var tempbboxArr:Array = tempbbox.split("%2C");
			return tempbboxArr[0] + "," + tempbboxArr[1] + " " + tempbboxArr[2] + "," + tempbboxArr[3];
		}
		
		public static function getBBOXStringFromBounds(bounds:Bounds):String {
			return bounds.left + "," + bounds.bottom + " " + bounds.right + "," + bounds.top;
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
		
	}
}