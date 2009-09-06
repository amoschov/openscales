package org.openscales.core.geometry
{
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.Trace;
	import org.openscales.proj4as.ProjProjection;

	/**
	 * A Geometry is a description of a geographic object.
	 * Create an instance of this class with the Geometry constructor.
	 * This is a base class, typical geometry types are described by subclasses of this class.
	 */
	public class Geometry
	{
		/**
     	 * A unique identifier for this geometry.
     	 */
		private var _id:String = null;

		/**
     	 * This is set when a Geometry is added as component of another geometry
     	 */
		private var _parent:Geometry = null;
		
		/**
     	 * The bounds of this geometry
     	 */
		protected var _bounds:Bounds = null;

		/**
		 * Geometry constructor
		 */
		public function Geometry(id:String = null) {
			this._id = id;
		}

		/**
		 * Destroys the geometry
		 */
		public function destroy():void {
			this.id = null;

			this._bounds = null;
		}

		public function toShortString():String {
			return "";
		}

		/**
		 * Method to convert the lon/lat (x/y) value of the geometry from a projection system to an other.
		 *
		 * @param source The source projection
		 * @param dest The destination projection
		 */
		public function transform(source:ProjProjection, dest:ProjProjection):void {
		}

		/**
		 * Clear the geometry's bounds
		 */
		public function clearBounds():void {
			this._bounds = null;
			if (this._parent) {
				this._parent.clearBounds();
			} 
		}

		/**
		 * Extends geometry's bounds
		 *
		 * If bounds are not defined yet, it initializes the bounds. If bounds are already defined,
		 * it extends them.
		 *
		 * @param newBounds Bounds to extend gemetry's bounds
		 */
		public function extendBounds(newBounds:Bounds):void {
			if (this._bounds == null) {
				this._bounds = newBounds;
			} else {
				this._bounds.extendFromBounds(newBounds);
			}
		}

		public function get bounds():Bounds {
			if (this._bounds == null) {
				this.calculateBounds();
			}
			return this._bounds;
		}


		public function set bounds(value:Bounds):void {
			if (value) {
				this._bounds = value.clone();
			}
		}

		/**
		 * The definition of the bounding box of the geometry must be overrided
		 * in each sub class
		 */
		public function calculateBounds():void {
			this._bounds = null;
		}

		/**
		 * Determines if the feature is placed at the given point with a certain tolerance (or not).
		 *
		 * @param lonlat The given point
		 * @param toleranceLon The longitude tolerance
		 * @param toleranceLat The latitude tolerance
		 */
		public function atPoint(lonlat:LonLat, toleranceLon:Number, toleranceLat:Number):Boolean {
			var atPoint:Boolean = false;
			var bounds:Bounds = this.bounds;
			if ((bounds != null) && (lonlat != null)) {

				var dX:Number = (!isNaN(toleranceLon)) ? toleranceLon : 0;
				var dY:Number = (!isNaN(toleranceLat)) ? toleranceLat : 0;

				var toleranceBounds:Bounds = 
					new Bounds(this.bounds.left - dX,
					this.bounds.bottom - dY,
					this.bounds.right + dX,
					this.bounds.top + dY);

				atPoint = toleranceBounds.containsLonLat(lonlat);
			}
			return atPoint;
		}
		
		/**
     	 * Calculate the closest distance between two geometries (on the x-y plane).
     	 *
     	 * @param geometry The target geometry.
     	 *
     	 * 
     	 * @return The distance between this geometry and the target.
     	 *     If details is true, the return will be an object with distance,
     	 *     x0, y0, x1, and x2 properties.  The x0 and y0 properties represent
     	 *     the coordinates of the closest point on this geometry. The x1 and y1
     	 *     properties represent the coordinates of the closest point on the
     	 *     target geometry.
      	 */
    	public function distanceTo(geometry:Geometry):Number{
    		var distance:Number;
    		// TODO
    		return distance;
    	}
		
		/**
		 * Determine if the input geometry intersects this one.
		 * 
		 * @param geometry Any type of geometry.
		 * @return Boolean defining if the input geometry intersects this one.
		 */
		public function intersects(geometry:Geometry):Boolean {
			return false;
		}
    	
    	/**
 		 * Determine whether two line segments intersect or not.
 		 * This function is optimized for oriented segments so that x1 <= x2.
 		 *
 		 * @param seg1 Array representing a segment of two points ordered so
 		 *   that seg1.point1.x <= seg1.point2.x
 		 * @param seg2 Array representing a segment of two points ordered so
 		 *   that seg2.point1.x <= seg2.point2.x
 		 * @param tolerance if >0, two segments with a respective distance lower
 		 *   than this tolerance are considered intersecting
 		 * @return Boolean caracterizing if the two input segments intersect
 		 */
		static public function segmentsIntersect(seg1:Array, seg2:Array, tolerance:Number=0.0):Boolean {
			// Check the validity of the segments
			if ((seg1[1] as Point).x < (seg1[0] as Point).x) {
				Trace.error("segmentsIntersect : invalid seg1");
				return false;
			}
			if ((seg2[1] as Point).x < (seg2[0] as Point).x) {
				Trace.error("segmentsIntersect : invalid seg2");
				return false;
			}
			
			// Compute some useful oriented length needed later for computing
			//   the cross product of 2D-vectors centered in (0,0).
			// Compute the X-orientedLength and Y-orientedLength of the edge seg1			
			var x12_11:Number = ((seg1[1] as Point).x - (seg1[0] as Point).x);  // seg1.x2 - seg1.x1
			var y12_11:Number = ((seg1[1] as Point).y - (seg1[0] as Point).y);  // seg1.y2 - seg1.y1
			// Compute the X-orientedLength and Y-orientedLength of the edge seg2			
			var x22_21:Number = ((seg2[1] as Point).x - (seg2[0] as Point).x);  // seg2.x2 - seg2.x1
			var y22_21:Number = ((seg2[1] as Point).y - (seg2[0] as Point).y);  // seg2.y2 - seg2.y1
			// Compute the X-orientedLength and Y-orientedLength between the first vertex of each edge, named seg3			
			var x11_21:Number = ((seg1[0] as Point).x - (seg2[0] as Point).x);  // seg1.x1 - seg2.x1
			var y11_21:Number = ((seg1[0] as Point).y - (seg2[0] as Point).y);  // seg1.y1 - seg2.y1
			
			// Compute the cross product seg1 x seg2
			var d:Number = (x12_11 * y22_21) - (x22_21 * y12_11);
			// Compute the cross product seg2 x seg3
			var n1:Number = (x22_21 * y11_21) - (x11_21 * y22_21);
			// Compute the cross product seg1 x seg3
			var n2:Number = (x12_11 * y11_21) - (x11_21 * y12_11);
			
			// Why do we use cross products ? Let's explain with d = seg1 x seg2
			// d represents the signed area of the parallelogram defined by the
			//   two segments seg1 and seg2 translated to have the same origin.
			// If d==0, then seg1 and seg2 are colinear (same or opposite sense)
			// If d<0, then seg1 is in the direct sense from seg2
			// If d>0, then seg1 is in the indirect sens from seg2
			
			// Test if the two segments intersect themselves or not
			var intersection:Boolean = false;
			if (d == 0) {  // seg1 and seg2 are colinear and could be coincident
				if (n1 == 0 && n2 == 0) {  // coincident
					return true;
				}
         		// else there is no intersection but the Boolean to return will
         		//   depend on the tolerance management.
			} else {  // seg1 and seg2 are not colinear, an intersection could exist
				var along1:Number = n1 / d;
				var along2:Number = n2 / d;
				if ((along1 >= 0) && (along1 <= 1) && (along2 >=0) && (along2 <= 1)) {  // intersect
					return true;
         		}
         		// else there is no intersection but the Boolean to return will
         		//   depend on the tolerance management.
			}
			
			if (tolerance <= 0.0) {
				return false;
			}

			// The tolerance must be managed to test if an approximated
			//   intersection exists or not.
			Trace.error("segmentsIntersect NOK but tolerance should be tested : TODO");
			return false; // TODO
			
			/*var dist;
			// no calculated intersection, but segments could be within
			// the tolerance of one another
			var segs = [seg1, seg2];
			var source, target, x, y, p, result;
			// check segment endpoints for proximity to intersection
			// set intersection to first endpoint within the tolerance
			outer: for(var i=0; i<2; ++i) {
				source = segs[i];
				target = segs[(i+1)%2];
				for(var j=1; j<3; ++j) {
					p = {x: source["x"+j], y: source["y"+j]};
					result = distanceToSegment(p, target);
					if (result.distance < tolerance) {
						return true;
					}
				}
			}
			return false;*/
		 }
 
		/**
		 * Returns the geometry's length. Overrided by subclasses.
		 */
		public function get length():Number {
			return 0.0;
		}

		/**
		 * Returns the geometry's area. Overrided by subclasses.
		 */
		public function get area():Number {
			return 0.0;
		}

		public function get id():String {
			return this._id;
		}

		public function set id(value:String):void {
			this._id = value;
		}

		public function get parent():Geometry {
			return this._parent;
		}

		public function set parent(value:Geometry):void {
			this._parent = value;
		}
	}
}

