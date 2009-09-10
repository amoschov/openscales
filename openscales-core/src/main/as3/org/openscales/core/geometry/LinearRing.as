package org.openscales.core.geometry
{
	import org.openscales.core.basetypes.LonLat;
		
	/**
	 * A Linear Ring is a special LineString which is closed. 
	 * It closes itself automatically on every addPoint/removePoint by adding a
	 * copy of the first point as the last point.
	 * Also, as it is the first in the line family to close itself, an area
	 * getter is defined to calculate the enclosed area of the linearRing.
	 */
	public class LinearRing extends LineString
	{
		import org.openscales.core.Trace;

		public function LinearRing(points:Array = null) {
			super(points);
		}

		override public function addComponent(point:Geometry, index:Number=NaN):Boolean {
			var added:Boolean = false;
			var lastPoint:Point = (this.componentByIndex(this.componentsLength-1) as Point);
			if (!isNaN(index) || !(point as Point).equals(lastPoint)) {
				added = super.addComponent(point, index);
			}
			return added;
		}
		
		/**
     	 * Test if a point is inside a linear ring.
     	 * For the case where a point is coincident with a linear ring edge,
     	 * returns 1.  Otherwise, returns boolean.
     	 *
     	 * @param point
     	 *
     	 * @return True if the point is inside the linear ring. Otherwise false. 
     	 */
    	 /*public function containsPoint(p:Point):Boolean {
    	 	// If the point is not inside the bounding box of the LinearRing, it
    	 	// can not be in the LinearRing.
    	 	if (! this.bounds.containsLonLat(new LonLat(p.x, p.y))) {
    	 		return false;
    	 	}
    	 	
			var p1:Point, p2:Point, cx:Number;
			var crosses:int = 0;			
			p1 = (this.componentByIndex(0) as Point);
			for(var i:int=1; i<this.componentsLength; i++, p1=p2) {
				p2 = (this.componentByIndex(i) as Point);
            
            	//
             	// The following conditions enforce five edge-crossing rules:
             	//    1. points coincident with edges are considered contained;
             	//    2. an upward edge includes its starting endpoint, and
             	//    excludes its final endpoint;
             	//    3. a downward edge excludes its starting endpoint, and
             	//    includes its final endpoint;
             	//    4. horizontal edges are excluded; and
             	//    5. the edge-ray intersection point must be strictly right
             	//    of the point P.
				// Is the current edge horizontal ?
				if (p1.y == p2.y) {
					// Is the input point on the same horizontal line ?
					if (p.y == p1.y) {
						// Is the input point on the edge ?
						if ((p1.x <= p2.x && p.x >= p1.x && p.x <= p2.x)
						  ||(p2.x >= p1.x && p.x >= p2.x && p.x <= p1.x)) {
							// A point on a edge is inside the LinearRing
							return true;
						}
						// The input point is not on the edge
					}
					// The input point is not on the horizontal line
					// The current edge is not discriminant
					continue;
				}
				
				// ???
				cx = getX(p.y, p1, p2);
				// Is the input point on the same line ?
				if (cx == p.x) {
					// Is the input point on the edge ?
					if ((p1.y < p2.y && p.y >= p1.y && p.y <= p2.y)    // upward
					 || (p2.y < p1.y && p.y >= p2.y && p.y <= p1.y)) { // backward
// FixMe : et si p1.y==p2.y ?
						// A point on a edge is inside the LinearRing
						return true;
					}
				}
				// The input point is not on the line
				// Is ???
				if (cx < p.x) {
					// no crossing to the right
					continue;
				}
				// Is ???
				if (p1.x != p2.x && (cx < Math.min(p1.x, p2.x) || cx > Math.max(p1.x, p2.x))) {
					// no crossing
					continue;
				}
				
				// Is ???
				if ((p1.y < p2.y && p.y >= p1.y && p.y < p2.y)    // upward
				 || (p2.y < p1.y && p.y >= p2.y && p.y < p1.y)) { // backward
				 	// ???
					++crosses;
				}
			}
			
			var contained:Boolean;
			if (crosses == -1) {
				contained = false;
			} else {
				contained=true;
			}
			
Trace.debug("LinearRing.containsPoint "+contained);
			return contained;
		}*/
    	 
		/**
		 * ???
		 */
		/*private function getX(y:Number, p1:Point, p2:Point):Number {
			return ((p1.x-p2.x)*y + p2.x*p1.y - p1.x*p2.y) / (p1.y-p2.y);
		}*/
		
		/**
     	 * Test if a point is inside a linear ring.
     	 * Two major methods are used for this test : "crossing number" or
     	 * "winding number". There are both discussed at
     	 * http://softsurfer.com/Archive/algorithm_0103/algorithm_0103.htm
     	 * 
     	 * This function is an implementation of the "winding number" algorithm
     	 * that uses the Geometry.isLeftOrRigh function.
     	 * 
     	 * @param p the point to test
     	 * @return
     	 */
		public function containsPoint(p:Point):Boolean {
			// If the point is not inside the bounding box of the LinearRing, it
			// can not be in the LinearRing.
			if (! this.bounds.containsLonLat(new LonLat(p.x, p.y))) {
Trace.debug("LinearRing.containsPoint false from BBOX");
				return false;
			}
			
			var wn:int = 0; // the winding number
			var p0:Point = (this.componentByIndex(0) as Point); // first vertex of the current edge
			var p1:Point;  // second vertex of the current edge
			for(var i:int=1; i<this.componentsLength; i++, p0=p1) {
				p1 = (this.componentByIndex(i) as Point);
				if (p0.y <= p.y) {
					if (p1.y > p.y) {
						if (Geometry.isLeftOrRight(p, p0, p1) > 0) {
							wn++;
						}
					}
				} else {
					if (p1.y <= p.y) {
						if (Geometry.isLeftOrRight(p, p0, p1) < 0) {
							wn--;
						}
					}
				}
			}
Trace.debug("LinearRing.containsPoint "+(wn != 0));
			return (wn != 0);
		}
		
		/**
     	 * Test for instersection between this LinearRing and a geometry.
     	 * 
     	 * @param geom the geometry (of any type) to intersect with
     	 * @return a boolean defining if an intersection exist or not
      	 */
		override public function intersects(geom:Geometry):Boolean {
			if (geom is Point) {
Trace.debug("LinearRing:intersects with a Point");
				return this.containsPoint(geom as Point);
			}
			else if (geom is LinearRing) {
				// LinearRing must be tested before LineString !!!
Trace.debug("LinearRing:intersects with a LinearRing");
				return super.intersects(geom);
			}
			else if (geom is LineString) {
Trace.debug("LinearRing:intersects with a LineString");
				return (geom as LineString).intersects(this);
			}
			else {  // geom is a multi-geometry
Trace.debug("LinearRing:intersects with a multi-geometry");
				var numSubGeometries:int = (geom as Collection).componentsLength;
				for(var i:int=0; i<numSubGeometries; ++i) {
					if ((geom as Collection).componentByIndex(i).intersects(this)) {
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
		
		/**
		 * Calculate the approximate area enclosed by this LinearRing (the
		 * projection and the geodesic are not managed).
		 * 
		 * The auto-intersection of edges of the LinearRing is not managed yet.
		 */
		override public function get area():Number {
			return 0.0;  // TODO, FixMe
		}

	}
}

