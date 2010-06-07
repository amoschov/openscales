package org.openscales.geometry
{
	import org.openscales.basetypes.Bounds;
	import org.openscales.basetypes.LonLat;
	import org.openscales.proj4as.ProjProjection;


	/**
	 * A Geometry is a description of a geographic object.
	 * Create an instance of this class with the Geometry constructor.
	 * This is a base class, typical geometry types are described by subclasses of this class.
	 */
	public class Geometry 
	{
		/**
     	 * The bounds of this geometry
		 * 
     	 */
		protected var _bounds:Bounds = null;
		
		/**
		 * projection of the geometry 
		 */
		protected var _projection:String = "EPSG:4326";
		/**
		 * Destroys the geometry
		 */
		public function destroy():void {
			this._bounds = null;
		}
		
		/**
		 * To get this geometry clone
		 * */
		public function clone():Geometry{
			return null;
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
		 * Return an array of all the vertices (Point) of this geometry
		 */
		public function toVertices():Vector.<Point> {
			return new Vector.<Geometry>;
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
		 public function distanceTo(geometry:Geometry, options:Object=null):Number{
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
		public function intersects(geom:Geometry):Boolean {
			return false;
		}
		
		/**
		 * Determine if the input geometry is fully contained in this one.
		 * 
		 * @param geometry Any type of geometry.
		 * @param assertIntersection if the intersection has already been tested
		 * it is better to not retest it by setting this parameter to "true"
		 * @return Boolean defining if the input geometry is contained or not.
		 */
		public function contains(geom:Geometry, assertIntersection:Boolean=false):Boolean {
			// If the two geometries doesn't intersect themselves, the input
			// geometry cannot be contained in this one.
			if ((! assertIntersection) && (! this.intersects(geom))) {
				return false;
			}
			// The two geometries intersect, so the inclusion may be tested by
			// using the containsPoint for each vertex of the input geometry.
			var vertices:Vector.<Point> = geom.toVertices();
			if (vertices.length == 0) {
				return false;
			}
			for each(var vertex:Point in vertices) {
				if (! this.containsPoint(vertex)) {
					return false;
				}
			}
			return true;
		}
		
		/**
     	 * Test if a point is inside this geometry.
     	 * 
     	 * @param p the point to test
		 * @return a boolean defining if the point is inside or outside this geometry
     	 */
		public function containsPoint(p:Point):Boolean {
			return false;
		}
		
		/**
		 * Returns the geometry's length. Overrided by subclasses.
		 */
		public function get projection():String {
			return this._projection;
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

		public function set projection(value:String):void {
			this._projection = value;
		}
		
	}
}

