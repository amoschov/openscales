package org.openscales.core.geometry
{
	import org.openscales.core.Trace;
	import org.openscales.proj4as.ProjProjection;
		
	/**
	 * A LineString is a is a MultiPoint (2 vertices min), whose points are
	 * assumed to be connected.
	 */
	public class LineString extends MultiPoint
	{
		/**
		 * LineString constructor
		 * 
		 * @param vertices Array of two or more points
		 */
		public function LineString(vertices:Array) {
			// Check if all the components to add are Points
			var validVertices:Boolean = true;
			if (vertices) {
				for(var i:int=0; i<vertices.length; i++) {
					if (! (vertices[i] is Point)) {
						Trace.error("LineString constructor ERROR : invalid parameter " + i);
						validVertices = false;
						vertices = null;
					}
				}
			}
			// Check if almost two vertices are defined.
			// If one (or more) vertex is invalid, this condition is not tested
			if (validVertices) {
				if (vertices && (vertices.length < 2)) {
					Trace.warning("LineString constructor WARNING : too few vertices (" + vertices.length + ")");
				}
			}
			// Initialize the object
			super(vertices);
		}
		
		/**
		 * Add vertices to the end of the LineString
		 * 
		 * @param vertices the array of vertices to add
		 */
		override public function addComponents(vertices:Array):void {
			// Check if all the components to add are Points
			for(var i:int=0; i<vertices.length; i++) {
				if (! (vertices[i] is Point)) {
					Trace.error("LineString.addComponents ERROR : invalid parameter " + i);
					return;
				}
			}
			// Add the vertices to the LineString
			super.addComponents(vertices);
		}
		
		/**
		 * Remove a vertex of the LineString.
		 * 
		 * @param vertex the vertex of the LineString to remove
		 */
		override public function removeComponent(vertex:Geometry):void {
			// Check if the geometry to remove is a Point
			if (! (vertex is Point)) {
				Trace.error("LineString.removeComponent ERROR : invalid parameter");
				return; 
			}
			// Check if this object will stay a LineString after the removing
			//   (2 vertices min) and try to remove this Collection's component
			if (this.components.length > 2) {
				super.removeComponent(vertex);
			} else {
				Trace.error("LineString.removeComponent ERROR : too few components (" + this.components.length + ")"); 
			}
		}
		
		/**
		 * @param index the index of the attended vertex
		 * @return the vertex requested or null for an invalid index
		 */
		public function getPointAt(index:Number):Point {
			// Return null for an invalid request
			if ((index<0) || (index>=this.components.length)) {
				return null;
			}
			return this.components[index];
		}
		
		/**
		 * @return the last vertex of the LineString
		 */
		public function getLastPoint():Point {
			return this.getPointAt(this.components.length - 1);
		}
		
		/**
		 * Length getter which iterates through the vertices summing the
		 * distances of each edges.
		 */
		override public function get length():Number {
			var length:Number = 0.0;
			if (this.components.length > 1) {
				for(var i:int=1; i<this.components.length; i++) {
					length += this.components[i-1].distanceTo(this.components[i]);
				}
			}
			return length;
		}

		/**
		 * Method to convert the multipoint (x/y) from a projection system to an other.
		 * 
		 * @param source The source projection
		 * @param dest The destination projection
		 * @param allPoints if allPoints is equal to true we transform the
		 *   linestring two point. If it's false we only transform the last point.
		 *   We use it for example in the case of MultiLineString
		 */
		public function transformLineString(source:ProjProjection, dest:ProjProjection, allPoints:Boolean=true):void {
// FixMe : I think it's a bad backport from OpenLayers !!!
			if (this.components.length > 0) {
				if (allPoints) {
					for each (var p:Point in this.components) {
						p.transform(source, dest);
					}
				} else {
					// There is only two point in a Linestring
					this.components[1].transform(source, dest);
				}
			}	
		}
		
		/**
     	 * Test for instersection between this LineString and a geometry.
     	 * 
     	 * This is a cheapo implementation of the Bentley-Ottmann algorithm but
     	 * it doesn't really keep track of a sweep line data structure.
     	 * It is closer to the brute force method, except that segments are
     	 * X-sorted and potential intersections are only calculated when their
     	 * bounding boxes intersect.
     	 * 
     	 * @param geometry the geometry (of any type) to intersect with
     	 * @return a boolean defining if an intersection exist or not
      	 */
		override public function intersects(geometry:Geometry):Boolean {
			// Treat the geometry as a collection if it is not a simple point,
			// a simple polyline or a simple polygon
			if ( ! ((geometry is Point) || (geometry is LineString) || (geometry is LinearRing)) ) {
Trace.debug("Linestring:intersects - collection");
				return (geometry as Collection).intersects(this);
			}
// TODO : deeply test for the intersection with a point
			
			// The geometry to intersect is a simple Point, a simple polyline or
			//   a simple polygon.
			// First, check if the bounding boxes of the two geometries intersect
			if (! this.bounds.intersectsBounds(geometry.bounds)) {
Trace.debug("Linestring:intersects - NOK from BBOX");
				return false;
			}
			
			// To test if an intersection exists, it is necessary to cut this
			//   line string and the geometry in segments. The segments are
			//   oriented so that x1 <= x2 (but we does not known if y1 <= y2
			//   or not).
			var segs1:Array = this.getXsortedSegments();
			var segs2:Array = (geometry is Point) ? [(geometry as Point),(geometry as Point)] : (geometry as LineString).getXsortedSegments();
			
			var seg1:Array, seg1y1:Number, seg1y2:Number, seg1yMin:Number, seg1yMax:Number;
			var seg2:Array, seg2y1:Number, seg2y2:Number, seg2yMin:Number, seg2yMax:Number;
			// Loop over each segment of this lineString
    		for(var i:int=0; i<segs1.length; ++i) {
				seg1 = segs1[i];
				// Loop over each segment of the requested geometry
				for(var j:int=0; j<segs2.length; ++j) {
					// Before to really test the intersection between the two
					//    segments, we will test the intersection between their
					//    respective bounding boxes in four steps.
					seg2 = segs2[j];
					// If the most left vertex of seg2 is at the right of the
					//   most right vertex of seg1, there is no intersection
					if ((seg2[0] as Point).x > (seg1[1] as Point).x) {
                		continue;
            		}
					// If the most right vertex of seg2 is at the left of the
					//   most left vertex of seg1, there is no intersection
            		if ((seg2[1] as Point).x < (seg1[0] as Point).x) {
            		    // seg2 still left of seg1
            		    continue;
           		 	}
           		 	// To perform similar tests along Y-axis, it is necessary to
           		 	//   order the vertices of each segment
					seg1y1 = (seg1[0] as Point).y;
					seg1y2 = (seg1[1] as Point).y;
          		  	seg2y1 = (seg2[0] as Point).y;
          		  	seg2y2 = (seg2[1] as Point).y;
          		  	seg1yMin = Math.min(seg1y1, seg1y2);
          		  	seg1yMax = Math.max(seg1y1, seg1y2);
          		  	seg2yMin = Math.min(seg2y1, seg2y2);
          		  	seg2yMax = Math.max(seg2y1, seg2y2);
					// If the most bottom vertex of seg2 is above the most top
					//   vertex of seg1, there is no intersection
					if (seg2yMin > seg1yMax) {
						continue;
					}
					// If the most top vertex of seg2 is below the most bottom
					//   vertex of seg1, there is no intersection
					if (seg2yMax < seg1yMin) {
						continue;
					}
					// Now it sure that the bounding box of the two segments
					//   intersect themselves, so we have to perform the real
					//   intersection test of the two segments
					if (Geometry.segmentsIntersect(seg1, seg2)) {
						// These two segments intersect, there is no need to
						//   continue the tests for all the other couples of
						//   segments
Trace.debug("Linestring:intersects - OK for segments " + i + " and " + j);
						return true;
					}
				}
    		}
    		
    		// All the couples of segment have been testes, there is no intersection
Trace.debug("Linestring:intersects - NOK");
    		return false;
		}
		   
		/**
		 * Cut the LineString in an array of segments and each of them is sorted
		 * along X-axis to have seg[i].p1.x <= seg[i].p2.x
		 * There is (of course) no sort along Y-axis.
		 * 
		 * @return Array of X-sorted segments
		 */
		private function getXsortedSegments():Array {
			var point1:Point, point2:Point;
			var numSegs:int = this.components.length-1;
			var segments:Array = new Array(numSegs);
			for(var i:int=0; i<numSegs; ++i) {
				point1 = this.components[i];
				point2 = this.components[i+1];
				segments[i] = (point2.x < point1.x) ? [point2,point1] : [point1,point2];
			}
			return segments;
		}
		
	}
}
