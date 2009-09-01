package org.openscales.core.geometry
{	
	/**
	 * A Linear Ring is a special LineString which is closed. 
	 * It closes itself automatically on every addPoint/removePoint by adding a copy of the first point as the last point.
	 * Also, as it is the first in the line family to close itself, an area getter is 
	 * defined to calculate the enclosed area of the linearRing
	 */
	public class LinearRing extends LineString
	{

		public function LinearRing(points:Array = null) {
			super(points);
			this.componentTypes = ["org.openscales.core.geometry::LinearRing"];
		}

		override public function addComponent(point:Geometry, index:Number=NaN):Boolean {
			var added:Boolean = false;

			var lastPoint:Point = this.components[this.components.length-1];
			if(!isNaN(index) || !(point as Point).equals(lastPoint)) {
				added = super.addComponent(point, index);
			}

			return added;
		}
		
		/**
     	 * Test if a point is inside a linear ring.  For the case where a point
     	 *     is coincident with a linear ring edge, returns 1.  Otherwise,
     	 *     returns boolean.
     	 *
     	 * @param point
     	 *
     	 * @return True if the point is inside the linear ring. Otherwise false. 
     	 */
    	 public function containsPoint(point:Point):Boolean {
        	 //check openlayers if problems        	 
        	 var px:Number = point.x;
        	 var py:Number = point.y;
        	 var numSeg:int = this.components.length - 1;
        	 var start:Point, end:Point, x1:Number, y1:Number, x2:Number, y2:Number, cx:Number, cy:Number;
        	 var crosses:Number = 0;
        	 for(var i:int=0; i<numSeg; ++i) {
            	 start = this.components[i];
            	 x1 = start.x;
            	 y1 = start.y;
             	end = this.components[i + 1];
            	 x2 = end.x;
            	 y2 =end.y;
            
            	 /*
             	 * The following conditions enforce five edge-crossing rules:
             	 *    1. points coincident with edges are considered contained;
             	 *    2. an upward edge includes its starting endpoint, and
             	 *    excludes its final endpoint;
             	 *    3. a downward edge excludes its starting endpoint, and
             	 *    includes its final endpoint;
             	 *    4. horizontal edges are excluded; and
             	 *    5. the edge-ray intersection point must be strictly right
             	 *    of the point P.
             	 */
            	 if(y1 == y2) {
                	 // horizontal edge
                	 if(py == y1) {
                    	 // point on horizontal line
                    	 if(x1 <= x2 && (px >= x1 && px <= x2) || // right or vert
                       	 	x1 >= x2 && (px <= x1 && px >= x2)) { // left or vert
                        	 // point on edge
                       	 	 crosses = -1;
                       	  break;
                    	 }
                	 }
                	 // ignore other horizontal edges
                	 continue;
            	 }
            	 cx = getX(py, x1, y1, x2, y2);
            	 if(cx == px) {
                	 // point on line
                	 if(y1 < y2 && (py >= y1 && py <= y2) || // upward
                  	   y1 > y2 && (py <= y1 && py >= y2)) { // downward
                    	 // point on edge
                    	 crosses = -1;
                    	 break;
                	 }
            	 }
            	 if(cx <= px) {
                	 // no crossing to the right
                	 continue;
            	 }
            	 if(x1 != x2 && (cx < Math.min(x1, x2) || cx > Math.max(x1, x2))) {
                	 // no crossing
                	 continue;
            	 }
            	 if(y1 < y2 && (py >= y1 && py < y2) || // upward
               	 y1 > y2 && (py < y1 && py >= y2)) { // downward
                	 ++crosses;
            	 }
        	 }
        	 var contained:Boolean;
        	 if (crosses == -1){ contained = false;}
        	 else {contained=true;}

        	 return contained;
    	 }
		
		/**
		 * ???
		 */
		private function getX(y:Number, x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return (((x1 - x2) * y) + ((x2 * y1) - (x1 * y2))) / (y1 - y2);
		}
		
		/**
     	 * Test for instersection between this LinearRing and a geometry.
     	 * 
     	 * @param geometry the geometry (of any type) to intersect with
     	 * @return a boolean defining if an intersection exist or not
      	 */
		override public function intersects(geometry:Geometry):Boolean {
			if (geometry is Point) {
				return this.containsPoint((geometry as Point));
			}
			else if (geometry is LinearRing) { // Must be tested before LineString !!!
				return super.intersects(this);
			}
			else if (geometry is LineString) {
				return (geometry as LineString).intersects(this);
			}
			else {  // geometry is a multi-geometry
				var numSubGeometries:int = (geometry as Collection).components.length;
				for(var i:int=0; i<numSubGeometries; ++i) {
					if ((geometry as Collection).components[i].intersects(this)) {
						// The sub-geometry intersects this LinearRing, there is
						//   no need to continue the tests for all the other
						//   sub-geometries
						return true;
					}
				}
			}

    		// No sub-geometry intersects this LinearRing
			return false;
     	}

	}
}

