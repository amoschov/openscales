package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	
	import org.openscales.commons.basetypes.LonLat;
	import org.openscales.commons.basetypes.Pixel;
	import org.openscales.core.control.Control;
	import org.openscales.core.feature.Vector;
	import org.openscales.commons.geometry.Geometry;
	import org.openscales.commons.geometry.LineString;
	import org.openscales.commons.geometry.Point;
	
	public class Path extends org.openscales.core.handler.Point
	{
		
		public var line:Vector = null;
    
    	public var freehand:Boolean = false;

    	public var freehandToggle:String = "shiftKey";
    	
    	public function Path (control:Control, options:Object, attributes:Object = null):void {
    		super(control, options);
    	}

		override public function createFeature():void {
			this.line = new Vector(new LineString());
			
			this.point = new Vector(new org.openscales.commons.geometry.Point());
		}
		
		public function destoryFeature():void {
			this.line.destroy();
			this.point.destroy();
		}
		
		public function add():void {
			var line:LineString = this.line.geometry as LineString;
			line.addComponent(this.point.geometry.clone(), line.components.length);
			this.addPoint(this.point.geometry);
		}
		
		/**
		 * callback function addPoint(geometry:Geometry):void
		 */
		public var addPoint:Function = null;
			
		public function freehandMode(evt:MouseEvent):Boolean {
			return (this.freehandToggle && evt[this.freehandToggle]) ? !this.freehand : this.freehand;
		}
		
		protected function modifyFeature():void {
			
			var line:LineString = this.line.geometry as LineString;
			var p:org.openscales.commons.geometry.Point = this.point.geometry as org.openscales.commons.geometry.Point;
			
			if(line) {
				var index:int = line.components.length - 1;
	        	line.components[index].x = p.x;
	        	line.components[index].y = p.y;
	  		}
		}
		
		override public function drawFeature():void {
			this.layer.drawFeature(this.line, this.style);
			this.layer.drawFeature(this.point, this.style);
		}
		
		override public function geometryClone():Geometry {
			return this.line.geometry.clone();
		}
		
		override protected function mouseDown(evt:MouseEvent):Boolean {
			var xy:Pixel = new Pixel(map.mouseX, map.mouseY);
	        if (this.lastDown && this.lastDown.equals(xy)) {
	            return false;
	        }
	        if(this.lastDown == null) {
	            this.createFeature();
	        }
	        this.isMouseDown = true;
	        this.lastDown = xy;
	        var lonlat:LonLat = this.control.map.getLonLatFromPixel(xy);
	        var p:org.openscales.commons.geometry.Point = this.point.geometry as org.openscales.commons.geometry.Point;
	        p.x = lonlat.lon;
	        p.y = lonlat.lat;
	        if((this.lastUp == null) || !this.lastUp.equals(xy)) {
	            this.add();
	        }
	        this.drawFeature();
	        this.drawing = true;
	        return false;
		}
		
		override protected function mouseMove(evt:MouseEvent):Boolean {
			var xy:Pixel = new Pixel(map.mouseX, map.mouseY);
			if(this.drawing) { 
	            var lonlat:LonLat = this.map.getLonLatFromPixel(xy);
	            var p:org.openscales.commons.geometry.Point = this.point.geometry as org.openscales.commons.geometry.Point;
	            p.x = lonlat.lon;
	            p.y = lonlat.lat;
	            if(this.isMouseDown && this.freehandMode(evt)) {
	                this.add();
	            } else {
	                this.modifyFeature();
	            }
	            this.drawFeature();
	        }
	        return true;
		}
		
		override protected function mouseUp(evt:MouseEvent):Boolean {
			var xy:Pixel = new Pixel(map.mouseX, map.mouseY);
			this.isMouseDown = false;
	        if(this.drawing) {
	            if(this.freehandMode(evt)) {
	                this.finalize();
	            } else {
	                if(this.lastUp == null) {
	                   this.add();
	                }
	                this.lastUp = xy;
	            }
	            return false;
	        }
	        return true;
		}
		
		override protected function mouseDoubleClick(evt:MouseEvent):Boolean {
			if(!this.freehandMode(evt)) {
	            var line:LineString = this.line.geometry as LineString;
	            var index:int = line.components.length - 1;
	            line.removeComponent(line.components[index]);
	            this.finalize();
	        }
	        return false;
		}

	}
}