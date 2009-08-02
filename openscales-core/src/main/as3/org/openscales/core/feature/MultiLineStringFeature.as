package org.openscales.core.feature
{
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.MultiLineString;

	public class MultiLineStringFeature extends VectorFeature
	{
		public function MultiLineStringFeature(geometry:Geometry=null, data:Object=null, style:Style=null)
		{
			super(geometry, data, style);
		}
		
		public function get lineStrings():MultiLineString {
			return this.geometry as MultiLineString;
		}
		
		override public function draw():void {
			super.draw();
	        for (var i:int = 0; i < this.lineStrings.components.length; i++) {
	        	var lineString:LineString = this.lineStrings.components[i];
		        for (var j:int = 0; j < lineString.components.length; j++) {
					var point:Point = lineString.components[i];
					var x:Number = (point.x / this.layer.resolution + this.left);
		        	var y:Number = (this.top - point.y / this.layer.resolution);
					if (i==0) {
						this.graphics.moveTo(x, y);
					} else {
						this.graphics.lineTo(x, y); 
					}
				}
	        }
		}		
	}
}