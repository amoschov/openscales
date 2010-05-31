package org.openscales.geometry
{
	import flash.utils.getQualifiedClassName;
	/**
	 * A Polygon is a collection of Geometry LinearRings defining a Mathematical
	 * Polygon (the first LinearRing) with holes (the potential others LinearRings).
	 */
	public class Polygon extends Collection
	{
		/**
     	 * Constructor for a Polygon geometry. 
     	 * The first ring (components[0]) is the outer bounds of the polygon and 
     	 * all subsequent rings (component[1..n]) are internal holes.
     	 *
     	 * @param rings the polygon and its holes
     	*/
    	public function Polygon(rings:Vector.<Geometry>) {
			// Check if all the components to add are LinearRing
			var validRings:Boolean = true;
			if (rings) {
				for(var i:int=0; i<rings.length; ++i) {
					if ((rings[i]==undefined) || (! (rings[i] is LinearRing))) {
						validRings = false;
						rings = null;
						break;
					}
				}
			}
			// Check if almost one ring is defined.
			// If one (or more) ring is invalid, this condition is not tested
			if (validRings) {
				if (rings && (rings.length < 1)) {
				}
			}
			// Initialize the object
			super(rings);
    		this.componentTypes = new <String>["org.openscales.geometry::LinearRing"];
		}
		
		/**
		 * Component of the specified index, casted to the LinearRing type
		 */
// TODO: how to do that in AS3 ?
		/*override public function componentByIndex(i:int):LinearRing {
			return (super.componentByIndex(i) as LinearRing);
		}*/
		
		/**
		 *  
		 */
		override public function toShortString():String {
			var s:String = "(";
			for(var i:int=0; i<this.componentsLength; ++i) {
				s = s + this._components[i].toShortString();
			}
			return s + ")";
		}
		
		/**
		 * Calculate the approximate area of this geometry (the projection and
		 * the geodesic are not managed).
		 * 
		 * Be careful, if some components intersect themselves, the intersection
		 * area is substracted several times !
		 * Moreover, the auto-intersection of edges of each LinearRing is not
		 * managed.
		 * 
		 * @return The area of the collection is defining by substracting the
		 * areas of the internal holes to the area of the outer ring.
		 */
		override public function get area():Number {
        	if (this.componentsLength < 1) {
        		return 0.0;
        	}
			var _area:Number = (this._components[0] as LinearRing).area;
        	for (var i:int=1; i<this.componentsLength; ++i) {
            	_area -= (this._components[i] as LinearRing).area;
        	}
        	if (_area < 0) {
         	}
       		return Math.max(_area, 0.0);
    	}
		
		/**
     	 * Test if a point is inside this geometry.
     	 * 
     	 * @param p the point to test
		 * @return a boolean defining if the point is inside or outside this geometry
     	 */
		override public function containsPoint(p:Point):Boolean {
			return this.isPointInPolygon(p);
		}
		
		/**
		 * Test if a point is inside a polygon.
		 * A point on a polygon edge is considered inside.
		 * A point on at least one of the holes is considered outside except if
		 * the manageHoles parameter is set to false.
		 * 
		 * @param point the point to test
		 * @param manageHoles a boolean defining if the test must manage the
		 * holes (default) or not.
		 * @return a boolean defining if the point is inside or outside this geometry
		 */
		public function isPointInPolygon(point:Point, manageHoles:Boolean=true):Boolean {
			// Stop if the polygon is void
			if (this.componentsLength < 1) {
					return false;
			}
			
			// Test if the point is inside the outer ring
			if (! (this._components[0] as LinearRing).containsPoint(point)) {
				return false;
			}
			
			// The point is inside the outer ring. So, if the holes have not to
			// be managed, the polygon contains the point.
			if (! manageHoles) {
				return true;
			}
			
			// If the point is inside one of the holes, it is outside the
			// polygon.
			for(var i:int=1; i<this.componentsLength; ++i) {
				if ((this._components[i] as LinearRing).containsPoint(point)) {
					return false;
				}
			}
			
			// The point is inside the outer ring but outside of all the holes.
			// So the point is definitively inside the polygon.
        	return true;
		}
		
    	/**
     	* Determine if the input geometry intersects this one.
     	*
     	* @param geom Any type of geometry.
     	*
     	* @return The input geometry intersects this one.
     	*/
    	override public function intersects(geom:Geometry):Boolean{
			// Stop if the polygon is void
			if (this.componentsLength < 1) {
				return false;
			}
			
			var i:int;
			if (geom is Point) {
				return this.containsPoint(geom as Point);
			}
			else if ((geom is LinearRing) || (geom is LineString)) {
				// LinearRing should be tested before LineString if a different
				//   action should be made for each case..
				// Test for the intersection of each LinearRing of tis Polygon
				//   with the geometry (LineString or LinearRing)
				for(i=0; i<this.componentsLength; ++i) {
					if ((geom as LineString).intersects(this._components[i])) {
						return true;
					}
				}
				// None of the LinearRings of this Polygon intersects with the
				//  input geometry. An intersection exists in two cases:
				//  1) if the input geomety is whole contained in the first
				//    LinearRing but not in one of the holes represented by the
				//    others LinearRings.
				//  2) if the input geometry is a LinearRing (not a LineString)
				//    and this polygon is whole contained in it.
				//  Test only one vertex is sufficient in the two cases since
				//  there is no intersection.
				return this.containsPoint((geom as LineString).componentByIndex(0) as Point)
					|| ((geom is LinearRing) && (geom as LinearRing).containsPoint((this._components[0] as LinearRing).componentByIndex(0) as Point));
			}
			else if (getQualifiedClassName(geom) == "org.openscales.geometry::Polygon") {
				// Two holed polygons intersect if and only if one of them
				//  intersects with the outer LinearRing of the other polygon
				//  without being fully included in one of its holes.
				if (! this.intersects((geom as Polygon).componentByIndex(0))) {
					return false;
				} else {
					// An intersection seems to exist but we have to check if
					// the outer LinearRing of this polygon is not fully
					// included in one of the holes of the input polygon.
					var outerLR:LinearRing = this._components[0] as LinearRing;
					var geomHole:LinearRing;
					for(i=1; i<(geom as Polygon).componentsLength; ++i) {
						geomHole = (geom as Polygon).componentByIndex(i) as LinearRing;
						if (geomHole.containsMultiPoint(outerLR as MultiPoint)) {
							return false;
						}
					}
					return true;
				}
			}
			else if(getQualifiedClassName(geom) == "org.openscales.geometry::MultiPoint"){
				return (geom as MultiPoint).intersects(this);
			} {  // geom is a multi-geometry
				return (geom as Collection).intersects(this);
			}
    	}

    	/*
     	* Calculate the closest distance between two geometries (on the x-y plane).
     	*
     	* Parameters:
     	* @geom:Geometry - The target geometry.
     	* @options:Object - Optional properties for configuring the distance
     	*     calculation.
     	*
     	* Valid options:
     	* details - {Boolean} Return details from the distance calculation.
     	*     Default is false.
     	* edge - {Boolean} Calculate the distance from this geometry to the
     	*     nearest edge of the target geometry.  Default is true.  If true,
     	*     calling distanceTo from a geometry that is wholly contained within
     	*     the target will result in a non-zero distance.  If false, whenever
     	*     geometries intersect, calling distanceTo will return 0.  If false,
     	*     details cannot be returned.
     	*
     	* Returns:
     	* {Number | Object} The distance between this geometry and the target.
     	*     If details is true, the return will be an object with distance,
     	*     x0, y0, x1, and y1 properties.  The x0 and y0 properties represent
     	*     the coordinates of the closest point on this geometry. The x1 and y1
     	*     properties represent the coordinates of the closest point on the
     	*     target geometry.
     	*/
    	// TODO : backport from OpenLayers not finish
    	
    	/* private function distanceTo(geom:Geometry, options:Object) {
        	var edge = !(options && options.edge === false); // === compare value and type
        	var result;
        	// this is the case where we might not be looking for distance to edge
        	if(!edge && this.intersects(geom)) {
           		result = 0;
        	}
        	else{result = OpenLayers.Geometry.Collection.prototype.distanceTo.apply(this, [geom, options]);
        	}
        	return result;
    	} */
	

		
		/**
		 * To get this geometry clone
		 * */
		override public function clone():Geometry{
			var PolygonClone:Polygon=new Polygon(null);
			var component:Vector.<Geometry>=this.getcomponentsClone();
			PolygonClone.addComponents(component);
			return PolygonClone;
		}
	}
}