package org.openscales.core
{
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.layer.Vector;
	
	public class Control
	{
		
		public static var TYPE_BUTTON:int = 1;
		public static var TYPE_TOGGLE:int = 2;
		public static var TYPE_TOOL:int = 3;
		public static var TYPES:Array = new Array(TYPE_BUTTON, TYPE_TOGGLE, TYPE_TOOL);
		
		public var id:String = null;
		public var map:Map = null;
		public var canvas:CanvasOL = null;
		public var type:Array = null;
		public var displayClass:String = "";
		public var active:Boolean = false;
		public var position:Pixel = null;
		public var outsideCanvas:CanvasOL = null;
		public var handler:Handler = null;
		public var layer:Vector = null;
		public var layerZPos:int;
		public var keyMask:int;
		
		public function Control(options:Object = null):void {
			
			this.displayClass = getQualifiedClassName(this).split('::')[1];
			this.position = new Pixel(0,0);
			
			Util.extend(this, options);
			
			this.id = Util.createUniqueID(getQualifiedClassName(this) + "_");
		}
		
		public function destroy():void {  
	        this.map = null;
		}
		
		public function setMap(map:Map):void {
			this.map = map;
	        if (this.handler) {
	            this.handler.setMap(map);
	        }
		}
		
		public function draw(px:Pixel = null, toSuper:Boolean = false):CanvasOL {
			if (this.canvas == null) {
	            this.canvas = Util.createCanvas();
	            this.canvas.id = this.id;
	            this.canvas.name = this.displayClass;
	            this.canvas.clipContent = true;
	        }
	        if (px != null) {
	            this.position = px.clone();
	        }
	        this.moveTo(this.position);        
	        return this.canvas;
		}
		
		public function moveTo(px:Pixel):void {
			if ((px != null) && (this.canvas != null)) {
	            this.canvas.x = px.x;
	            this.canvas.y = px.y;
	        }
		}
		
		public function activate():Boolean {
			if (this.active) {
	            return false;
	        }
	        if (this.handler) {
	        	this.handler.activate();
	        }
	        this.active = true;
	        return true;
		}
		
		public function deactivate():Boolean {
	        if (this.active) {
	            if (this.handler) {
	                this.handler.deactivate();
	            }
	            this.active = false;
	            return true;
	        }
	        return false;
		}
				
	}
}