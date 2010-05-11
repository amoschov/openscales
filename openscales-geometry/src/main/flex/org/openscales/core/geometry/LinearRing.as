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
		public function LinearRing(points:Vector.<Geometry> = null) {
			super(points);
		}

		override public function addComponent(point:Geometry, index:Number=NaN):Boolean {
			var added:Boolean = false;
			var lastPoint:Point = (this._components[this.componentsLength-1] as Point);
			if (!isNaN(index) || !(point as Point).equals(lastPoint)) {
				added = super.addComponent(point, index);
			}
			return added;
		}
		
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
		 * @return a boolean defining if the point is inside or outside this geometry
     	 */
		override public function containsPoint(p:Point):Boolean {
			// If the point is not inside the bounding box of the LinearRing, it
			// can not be in the LinearRing.
			if (! this.bounds.containsLonLat(new LonLat(p.x, p.y))) {
				return false;
			}
			
			var wn:int = 0; // the winding number-
			var p0:Point; // first vertex of the current edge
			var p1:Point;  // second vertex of the current edge
			for(var i:int=0; i<this.componentsLength; i++) {
				p0 = (this._components[i] as Point);
				if(i==this.componentsLength-1) {
					p1 = (this._components[0] as Point);
				} else {
					p1 = (this._components[i + 1] as Point);
				}
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
			return (wn != 0);
		}
		
		/**
		 * Test if a MultiPoint (and so a LineString or a LinearRing) is inside
		 * a linear ring or not.
		 */
		public function containsMultiPoint(mp:MultiPoint):Boolean {
			for(var i:int=0; i<mp.componentsLength; i++) {
				if (! this._components[mp.componentByIndex(i)]) {
					return false;
				}
			}
			return true;
		}
			
		/**
     	 * Test for instersection between this LinearRing and a geometry.
     	 * 
     	 * @param geom the geometry (of any type) to intersect with
     	 * @return a boolean defining if an intersection exist or not
      	 */
		override public function intersects(geom:Geometry):Boolean {
			if (geom is Point) {
				return this.containsPoint(geom as Point);
			}
			else if (geom is LinearRing) {
				// LinearRing must be tested before LineString !!!
				return super.intersects(geom);
			}
			else if (geom is LineString) {
				return (geom as LineString).intersects(this);
			}
			else {  // geom is a multi-geometry
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
		
		/**
		 * To get this geometry clone
		 * */
		override public function clone():Geometry{
			var LinearRingClone:LinearRing=new LinearRing();
			var component:Vector.<Geometry>=this.getcomponentsClone();
			LinearRingClone.addComponents(component);
			return LinearRingClone;
		}
	}
}

