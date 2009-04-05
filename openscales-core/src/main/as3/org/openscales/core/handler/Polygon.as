package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.control.Control;
	import org.openscales.core.feature.Vector;
	import org.openscales.commons.geometry.Geometry;
	import org.openscales.commons.geometry.LineString;
	import org.openscales.commons.geometry.LinearRing;
	
	public class Polygon extends Path
	{
		
		public var polygon:Vector = null;
		
		public function Polygon(control:Control, callbacks:Object, options:Object, attributes:Object = null):void {
			super(control, callbacks, options);
		}
		
		override public function createFeature():void {
	        this.polygon = new Vector(new org.openscales.commons.geometry.Polygon());
	        this.line = new Vector(new LinearRing());
	        var p:org.openscales.commons.geometry.Polygon = this.polygon.geometry as org.openscales.commons.geometry.Polygon;
	        p.addComponent(this.line.geometry);
	        this.point = new Vector(new org.openscales.commons.geometry.Point());
		}
		
		override public function destoryFeature():void {
			this.polygon.destroy();
	        this.point.destroy();
		}
		
		override protected function modifyFeature():void {
			var line:LineString = this.line.geometry as LineString;
			var p:org.openscales.commons.geometry.Point = this.point.geometry as org.openscales.commons.geometry.Point;
			var index:int = line.components.length - 2;
			
	        line.components[index].x = p.x;
	        line.components[index].y = p.y;
		}
		
		override public function drawFeature():void {
			this.layer.drawFeature(this.polygon, this.style);
	        this.layer.drawFeature(this.point, this.style);
		}
		
		override public function geometryClone():Geometry {
			return this.polygon.geometry.clone();
		}
		
		override protected function mouseDoubleClick(evt:MouseEvent):Boolean {
			if(!this.freehandMode(evt)) {
				var line:LineString = this.line.geometry as LineString;
	            var index:int = line.components.length - 2;
	            line.removeComponent(line.components[index]);
	            this.finalize();
	        }
	        return false;
		}
		
	}
}