package org.openscales.core.geometry
{
	import org.openscales.proj4as.ProjProjection;
		
	/**
 	 * Class: OpenLayers.Geometry.LineString
 	 * A LineString is a Curve which, once two points have been added to it, can 
 	 * never be less than two points long.
	 */

	public class LineString extends Curve
	{

		public function LineString(points:Array = null) {
			super(points);
		}

		override public function removeComponent(point:Geometry):void {
			if ( this.components && (this.components.length > 2)) {
				super.removeComponent(point);
			}
		}
		
		public function getPointAt(index:Number):Point {

			if(index >= 0 && index < this.components.length) {
				return this.components[index];
			}
			else {
				return null;
			}
		}

		public function getLastPoint():Point {
			return this.getPointAt(this.components.length - 1);
		}
		/**
		 * Method to convert the multipoint (x/y) from a projection system to an other.
		 *
		 * @param source The source projection
		 * @param dest The destination projection
		 * @param allPoints if allPoints is equal to true we transform the linestring two point if it's false we only transform  the last point we use it for example in the case of MultiLineString
		 *  
		 */
		 public function transformLineString(source:ProjProjection, dest:ProjProjection, allPoints:Boolean=true):void {
			if (this.components.length > 0) {
					if(allPoints)
					{
						for each (var p:Point in this.components) {
							p.transform(source, dest);
							}
					}
					else
					{
						//There is only two point in a Linestring
						this.components[1].transform(source, dest);
					}
				}	
			}
	}
}

