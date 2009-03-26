package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.control.Control;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.layer.Vector;

	public class Point extends Handler
	{
		
		public var point:org.openscales.core.feature.Vector = null;

    	public var layer:org.openscales.core.layer.Vector = null;

    	public var drawing:Boolean = false;

    	public var mouseDown:Boolean = false;

    	public var lastDown:Pixel = null;

    	public var lastUp:Pixel = null;

		public function Point(control:Control = null, callbacks:Object = null, options:Object = null):void {
			this.style = Util.extend(org.openscales.core.feature.Vector.style['default'], {});

       		super(control, callbacks, options);
		}
		
		override public function activate(evt:MouseEvent = null):Boolean {
			if(!super.activate()) {
	            return false;
	        }
	        var options:Object = {displayInLayerSwitcher: false};
	        this.layer = new org.openscales.core.layer.Vector("Point", options);
	        this.map.addLayer(this.layer);
	        
	        return true;
		}
		
		public function createFeature():void {
	        this.point = new org.openscales.core.feature.Vector(
                                      new org.openscales.core.geometry.Point());
		}
		
		override public function deactivate(evt:MouseEvent = null):Boolean {
			if(!super.deactivate()) {
		        return false;
		    }
		    if(this.drawing) {
		        this.cancel();
		    }
		    this.map.removeLayer(this.layer, false);
		    this.layer.destroy();
		    return true;
		}
		
		public function destroyFeature():void {
			this.point.destroy();
		}
		
		public function finalize():void {
			this.layer.renderer.clear();
	        this.callback("done", [this.geometryClone()]);
	        this.destroyFeature();
	        this.drawing = false;
	        this.mouseDown = false;
	        this.lastDown = null;
	        this.lastUp = null;
		}
		
		public function cancel():void {
			this.layer.renderer.clear();
	        this.callback("cancel", [this.geometryClone()]);
	        this.destroyFeature();
	        this.drawing = false;
	        this.mouseDown = false;
	        this.lastDown = null;
	        this.lastUp = null;
		}
		
		public function doubleclick(evt:MouseEvent):Boolean {
			evt.stopPropagation();
	        return false;
		}
		
		public function drawFeature():void {
			this.layer.drawFeature(this.point, this.style);
		}
		
		public function geometryClone():Object {
			return this.point.geometry.clone();
		}
		
		public function mousedown(evt:MouseEvent):Boolean {
		    if(!this.checkModifiers(evt)) {
	            return true;
	        }
	        var xy:Pixel = new Pixel(evt.stageX, evt.stageY)
	        if(this.lastDown && this.lastDown.equals(xy)) {
	            return true;
	        }
	        if(this.lastDown == null) {
	            this.createFeature();
	        }
	        this.lastDown = xy;
	        this.drawing = true;
	        var lonlat:LonLat = this.map.getLonLatFromPixel(xy);
	        var p:org.openscales.core.geometry.Point = this.point.geometry as org.openscales.core.geometry.Point;
	        p.x = lonlat.lon;
	        p.y = lonlat.lat;
	        this.drawFeature();
	        return false;
		}
		
		public function mousemove(evt:MouseEvent):Boolean {
			if(this.drawing) {
				var xy:Pixel = new Pixel(evt.stageX, evt.stageY);
	            var lonlat:LonLat = this.map.getLonLatFromPixel(xy);
	            var p:org.openscales.core.geometry.Point = this.point.geometry as org.openscales.core.geometry.Point;
	            p.x = lonlat.lon;
	            p.y = lonlat.lat;
	            this.drawFeature();
	        }
	        return true;
		}
		
		public function mouseup(evt:MouseEvent):Boolean {
			if(this.drawing) {
	            this.finalize();
	            return false;
	        } else {
	            return true;
	        }
		}

	}
}