package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.control.Control;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Point;
	
	public class Path extends org.openscales.core.handler.Point
	{
		
		public var line:Vector = null;
    
    	public var freehand:Boolean = false;

    	public var freehandToggle:String = "shiftKey";
    	
    	public function Path (control:Control, callbacks:Object, options:Object, attributes:Object = null):void {
    		super(control, callbacks, options);
    	}

		override public function createFeature():void {
			this.line = new Vector(new LineString());
			
			this.point = new Vector(new org.openscales.core.geometry.Point());
		}
		
		public function destoryFeature():void {
			this.line.destroy();
			this.point.destroy();
		}
		
		public function addPoint():void {
			var line:LineString = this.line.geometry as LineString;
			line.addComponent(this.point.geometry.clone(), line.components.length);
			this.callback("point", [this.point.geometry]);
		}
		
		public function freehandMode(evt:MouseEvent):Boolean {
			return (this.freehandToggle && evt[this.freehandToggle]) ? !this.freehand : this.freehand;
		}
		
		public function modifyFeature():void {
			
			var line:LineString = this.line.geometry as LineString;
			var p:org.openscales.core.geometry.Point = this.point.geometry as org.openscales.core.geometry.Point;
			
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
		
		override public function geometryClone():Object {
			return this.line.geometry.clone();
		}
		
		override public function mousedown(evt:MouseEvent):Boolean {
			var xy:Pixel = new Pixel(map.mouseX, map.mouseY);
	        if (this.lastDown && this.lastDown.equals(xy)) {
	            return false;
	        }
	        if(this.lastDown == null) {
	            this.createFeature();
	        }
	        this.mouseDown = true;
	        this.lastDown = xy;
	        var lonlat:LonLat = this.control.map.getLonLatFromPixel(xy);
	        var p:org.openscales.core.geometry.Point = this.point.geometry as org.openscales.core.geometry.Point;
	        p.x = lonlat.lon;
	        p.y = lonlat.lat;
	        if((this.lastUp == null) || !this.lastUp.equals(xy)) {
	            this.addPoint();
	        }
	        this.drawFeature();
	        this.drawing = true;
	        return false;
		}
		
		override public function mousemove(evt:MouseEvent):Boolean {
			var xy:Pixel = new Pixel(map.mouseX, map.mouseY);
			if(this.drawing) { 
	            var lonlat:LonLat = this.map.getLonLatFromPixel(xy);
	            var p:org.openscales.core.geometry.Point = this.point.geometry as org.openscales.core.geometry.Point;
	            p.x = lonlat.lon;
	            p.y = lonlat.lat;
	            if(this.mouseDown && this.freehandMode(evt)) {
	                this.addPoint();
	            } else {
	                this.modifyFeature();
	            }
	            this.drawFeature();
	        }
	        return true;
		}
		
		override public function mouseup(evt:MouseEvent):Boolean {
			var xy:Pixel = new Pixel(map.mouseX, map.mouseY);
			this.mouseDown = false;
	        if(this.drawing) {
	            if(this.freehandMode(evt)) {
	                this.finalize();
	            } else {
	                if(this.lastUp == null) {
	                   this.addPoint();
	                }
	                this.lastUp = xy;
	            }
	            return false;
	        }
	        return true;
		}
		
		override public function doubleclick(evt:MouseEvent):Boolean {
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