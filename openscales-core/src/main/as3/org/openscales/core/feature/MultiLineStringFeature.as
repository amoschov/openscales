package org.openscales.core.feature
{
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.MultiLineString;

	/**
	 * Feature used to draw a MultiLineString geometry on FeatureLayer
	 */
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
			
			// Regardless to the style, a MultiLineString is never filled
			this.graphics.endFill();
			
			// Variable declaration before for loop to improve performances
			var p:Pixel = null;
			var lineString:LineString = null;
			var j:int = 0;
			
			for (var i:int = 0; i < this.lineStrings.components.length; i++) {
				lineString = this.lineStrings.components[i];
				for (j = 0; j < lineString.components.length; j++) {
					p = this.getLayerPxFromPoint(lineString.components[j]);

					if (j==0) {
						this.graphics.moveTo(p.x, p.y);
					} else {
						this.graphics.lineTo(p.x, p.y); 
					}
				}
			}
		}		
	}
}

