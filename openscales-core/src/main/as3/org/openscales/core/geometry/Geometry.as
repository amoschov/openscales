package org.openscales.core.geometry
{
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
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
			var bounds:Bounds = this._bounds;
			if (!bounds) {
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
			if (bounds) {
				this._bounds = value.clone();
			}
		}

		public function calculateBounds():void {

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
    		return distance;
    	}
    	
    	/**
 		 * Determine whether two line segments intersect.  Optionally calculates
 		 *     and returns the intersection point.  This function is optimized for
 		 *     cases where seg1.x2 >= seg2.x1 || seg2.x2 >= seg1.x1.  In those
 		 *     obvious cases where there is no intersection, the function should
 		 *     not be called.
 		 *
 		 * @param seg1 Array representing a segment of two points. The first point1 has
    	 * 		properties x1 (point1.x), y1 (point1.y) and the second point2 has properties 
    	 * 		x2 (point2.x), y2 (point2.y).  The start point is represented by x1 and y1.  The end point
 		 *     is represented by x2 and y2.  Start and end are ordered so that x1 < x2.
 		 * 
 		 * @param seg2 Array representing a segment of two points. The first point1 has
    	 * 		properties x1 (point1.x), y1 (point1.y) and the second point2 has properties 
    	 * 		x2 (point2.x), y2 (point2.y).  The start point is represented by x1 and y1.  The end point
 		 *     is represented by x2 and y2.  Start and end are ordered so that x1 < x2.
 		 * 
 		 * options Optional properties for calculating the intersection (not implement yet)
 		 *
 		 * Valid options: (not implement yet)
 		 * point - {Boolean} Return the intersection point.  If false, the actual
 		 *     intersection point will not be calculated.  If true and the segments
 		 *     intersect, the intersection point will be returned.  If true and
 		 *     the segments do not intersect, false will be returned.  If true and
 		 *     the segments are coincident, true will be returned.
  		 * tolerance - {Number} If a non-null value is provided, if the segments are
 		 *     within the tolerance distance, this will be considered an intersection.
 		 *     In addition, if the point option is true and the calculated intersection
 		 *     is within the tolerance distance of an end point, the endpoint will be
 		 *     returned instead of the calculated intersection.  Further, if the
 		 *     intersection is within the tolerance of endpoints on both segments, or
 		 *     if two segment endpoints are within the tolerance distance of eachother
 		 *     (but no intersection is otherwise calculated), an endpoint on the
 		 *     first segment provided will be returned.
 		 *
 		 * @return The two segments intersect. If the point argument is true, the return will 
 		 * 	   be the intersection point or false if none exists.  If point is true and the segments
 		 *     are coincident, return will be true (and the instersection is equal
 		 *     to the shorter segment).
 		 */
		 static public function segmentsIntersect(seg1:Array, seg2:Array/* , options */):Boolean {
    		 /* var point = options && options.point;
    		 var tolerance = options && options.tolerance; */
    		 var intersection:Boolean = false;
    		 var x11_21:Number = ((seg1[0] as Point).x - (seg2[0] as Point).x);		/* seg1.x1 - seg2.x1; */
    		 var y11_21:Number = ((seg1[0] as Point).y - (seg2[0] as Point).y);		/* seg1.y1 - seg2.y1; */
    		 var x12_11:Number = ((seg1[1] as Point).x - (seg1[0] as Point).x);		/* seg1.x2 - seg1.x1; */
    		 var y12_11:Number = ((seg1[1] as Point).y - (seg1[0] as Point).y);		/* seg1.y2 - seg1.y1; */
    		 var y22_21:Number = seg2.y2 - seg2.y1;
    		 var x22_21:Number = seg2.x2 - seg2.x1;
    		 var d:Number = (y22_21 * x12_11) - (x22_21 * y12_11);
    		 var n1:Number = (x22_21 * y11_21) - (y22_21 * x11_21);
    		 var n2:Number = (x12_11 * y11_21) - (y12_11 * x11_21);
    		 if(d == 0) {
        		 // parallel
        		 if(n1 == 0 && n2 == 0) {
            		 // coincident
            		 intersection = true;
        		 }
    		 } else {
        		 var along1:Number = n1 / d;
        		 var along2:Number = n2 / d;
        		 if(along1 >= 0 && along1 <= 1 && along2 >=0 && along2 <= 1) {
            		 // intersect
            		 /* if(!point) {
                		 intersection = true;
            		 } else {
                		 // calculate the intersection point
                		 var x = seg1.x1 + (along1 * x12_11);
                		 var y = seg1.y1 + (along1 * y12_11);
                		 intersection = new OpenLayers.Geometry.Point(x, y);
            		 } */
            		 intersection = true;
         		}
    		 }
    		 /* if(tolerance) {
        		 var dist;
        		 if(intersection) {
            	 	if(point) {
                		 var segs = [seg1, seg2];
                		 var seg, x, y;
                		 // check segment endpoints for proximity to intersection
                		 // set intersection to first endpoint within the tolerance
                		 outer: for(var i=0; i<2; ++i) {
                    		 seg = segs[i];
                    		 for(var j=1; j<3; ++j) {
                        		 x = seg["x" + j];
                        		 y = seg["y" + j];
                        		 dist = Math.sqrt(
                            		 Math.pow(x - intersection.x, 2) +
                            		 Math.pow(y - intersection.y, 2)
                        		 );
                        		 if(dist < tolerance) {
                            		 intersection.x = x;
                             		 intersection.y = y;
                            		 break outer;
                        	  	 }
                    		 }
                		 }
                
            		 }
        		 } else {
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
                    		 result = OpenLayers.Geometry.distanceToSegment(p, target);
                    		 if(result.distance < tolerance) {
                        		 if(point) {
                            		 intersection = new OpenLayers.Geometry.Point(p.x, p.y);
                        		 } else {
                            		 intersection = true;
                        		 }
                        		 break outer;
                    		 }
                		 }
            		}
        		 } 
    		 }*/
    		 return intersection;
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

