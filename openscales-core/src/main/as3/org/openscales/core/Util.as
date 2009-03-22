package org.openscales.core
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.xml.XMLNode;
	
	import mx.containers.Canvas;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	
	public class Util
	{
		
		private static var lastSeqID:Number = 0;
		private var viewRequestID:Number = 0;
		private var canvas:Canvas = null;
		public static var MISSING_TILE_URL:String = "http://openstreetmap.org/openlayers/img/404.png";
		
		public function Util(canvas:Canvas = null):void {
			this.canvas = canvas;
		}
		
		public function getElement(element:Object = null):Object {
			var elements:Array = new Array();

		    for (var i:int = 0; i < arguments.length; i++) {
		        var element:Object = arguments[i];
		        if (element is String) {
		            element = this.canvas.parentApplication.getChildByName(String(element));
		        }
		        if (arguments.length == 1) {
		            return element;
		        }
		        elements.push(element);
		    }
		    return elements;
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
		
	private static function modifyFlexElement(element:Object, id:String, px:Pixel, sz:Size, position:String = null, border:String = null, overflow:String = null, opacity:Number = NaN):void {
		    if (id != null) {
		        element.id = id;
		    }
		    if (px != null) {
		        element.x = px.x;
		        element.y = px.y;
		    }
		    if (sz != null) {
		        element.width = sz.w;
		        element.height = sz.h;
		    }
		    if (position != null) {
		        element.style.position = position;
		    }
		    if (border != null) {
		        element.style.border = border;
		    }
		    if (overflow != null) {
		        element.style.overflow = overflow;
		    }
		    if (opacity) {
		      //  element.style.opacity = opacity;
		      //  element.style.filter = 'alpha(opacity=' + (opacity * 100) + ')';
		        element.alpha = opacity;
		    }
		}
	 			
		 public static function createCanvas(id:String = null, px:Pixel = null, sz:Size = null, source:Object = null, position:String = null, border:String = null, overflow:String = null, opacity:Number = NaN):CanvasOL {
			var canvas:CanvasOL = new CanvasOL();
			canvas.clipContent = false;
			canvas.horizontalScrollPolicy = "off";
			canvas.verticalScrollPolicy = "off";
			
			if (source != null) {
				var img:ImageOL = new ImageOL();
				img.source = source;
				canvas.addChild(img);
			}
			
			if (id != null) {
				id = Util.createUniqueID("OpenLayersCanvas");
			}
			
			if (position != null) {
				position = "absolute";
			}
			
			Util.modifyFlexElement(canvas, id, px, sz, position, border, overflow, opacity);
			
			return canvas;
		} 
		
		public static function createImage(id:String, px:Pixel, sz:Size, source:Object, position:String, border:String, opacity:Number = NaN, delayDisplay:Boolean = false):ImageOL {
			var image:ImageOL = new ImageOL();

		    if (!id) {
		        id = Util.createUniqueID("OpenLayersDiv");
		    }
		    if (!position) {
		        position = "relative";
		    }

		    modifyFlexElement(image, id, px, sz, position, 
		                                     border, null, opacity);
		    
		    image.style.alt = id;
		    image.galleryImg = "no";
		    if (source) {
		        image.source = source;
		    }

		    return image;
		}
		
		public static function modifyAlphaImageCanvas(canvas:Object, id:String, px:Pixel, sz:Size = null, source:Object = null, position:String = null, border:String = null, sizing:String = null, opacity:Number = NaN):void {
			modifyFlexElement(canvas, id, px, sz);
			
			var img:ImageOL = canvas.getChildAt(0) as ImageOL;
			
			if (source != null) {
				img.source = source;
			}
			
			modifyFlexElement(img, canvas.id + "_innerImage", null, sz, "relative", border);
			
			if (opacity) {
				//canvas.style.opacity = opacity;
				//canvas.style.filter = "alpha(opacity=" + (opacity * 100) + ")";
				img.alpha = opacity;
			}
		}
		
		public static function createAlphaImageCanvas(id:String, px:Pixel = null, sz:Size = null, source:Object = null, position:String = null, border:String = null, sizing:String = "scale", opacity:Number = NaN, delayDisplay:Boolean = false):CanvasOL {
			var canvas:CanvasOL = Util.createCanvas();
		    var img:ImageOL = Util.createImage(null, null, null, source, null, null, 
		                                          opacity, false);
		    canvas.addChild(img);
		
		    Util.modifyAlphaImageCanvas(canvas, id, px, sz, source, position, 
		                                        border, sizing, opacity);
		    
		    return canvas;
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
		
		public static var INCHES_PER_UNIT:Object = { 
		    'inches': 1.0,
		    'ft': 12.0,
		    'mi': 63360.0,
		    'm': 39.3701,
		    'km': 39370.1,
		    'dd': 4374754
		};
		INCHES_PER_UNIT["in"] = INCHES_PER_UNIT.inches;
		INCHES_PER_UNIT["degrees"] = INCHES_PER_UNIT.dd;
		
		public static var DOTS_PER_INCH:int = 72;
		
		public function normalizeScale(scale:Number):Number {
		    var normScale:Number = (scale > 1.0) ? (1.0 / scale) 
                              : scale;
		    return normScale;
		}
		
		public function getResolutionFromScale(scale:Number, units:String = null):Number {
			
		    if (units == null) {
		        units = "degrees";
		    }
		
		    var normScale:Number = this.normalizeScale(scale);
		
		    var resolution:Number = 1 / (normScale * Util.INCHES_PER_UNIT[units]
		                                    * Util.DOTS_PER_INCH);
		    return resolution;
		}
		
		public static function getScaleFromResolution(resolution:Number, units:String):Number {
			if (units == null) {
		        units = "degrees";
		    }
		
		    var scale:Number = resolution * Util.INCHES_PER_UNIT[units] *
		                    Util.DOTS_PER_INCH;
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
		          encodedValue = encodeURIComponent(value as String);
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
		
		public static function getXmlNodeValue(node:XMLNode):String {
			var val:String = null;
		    val = node.nodeValue;
		    return val;
		}
		
		public static function getImagesLocation():String {
			return "org/openscales/core/img/";
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
		
		public static function bringCanvasToFront(inCanvas:CanvasOL, container:CanvasOL):int {
			var zPos:int = container.getChildIndex(inCanvas);
			container.setChildIndex(inCanvas, container.numChildren - 1);
			return zPos;
		}
		
		public static function putCanvasBack(inCanvas:CanvasOL, container:CanvasOL, zPos:int):void {
			container.setChildIndex(inCanvas, zPos);
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