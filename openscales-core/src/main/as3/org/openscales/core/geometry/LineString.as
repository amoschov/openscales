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
		
		/**
     	 * Test for instersection between two geometries.  This is a cheapo
     	 *     implementation of the Bently-Ottmann algorigithm.  It doesn't
     	 *     really keep track of a sweep line data structure.  It is closer
     	 *     to the brute force method, except that segments are sorted and
     	 *     potential intersections are only calculated when bounding boxes
     	 *     intersect.
     	 *
     	 * Parameters:
     	 * geometry - {<OpenLayers.Geometry>}
     	 *
      	 * Returns:
     	 * {Boolean} The input geometry intersects this geometry.
      	 */
    	 override public function intersects(geometry:Geometry):Boolean {
        	 var intersect:Boolean = false;
        		if(geometry is LineString || geometry is LinearRing || geometry is Point){
            		// cut the input line in segements
            		var segs1:Array = this.getSortedSegments();
            		
            		// cut the geometry in segement. If it's a point, only one segment containing 2 same points
            		var segs2:Array = new Array();
            		if(geometry is Point) {
                		segs2[1] = (geometry as Point);
                		segs2[2] = (geometry as Point);
            		}
            		else{
                		segs2 = (geometry as LineString).getSortedSegments();
            		}
            		
            		var seg1:Array, seg1x1:Number, seg1x2:Number, seg1y1:Number, seg1y2:Number, seg2:Array, seg2y1:Number, seg2y2:Number;
            		// sweep right
            		var i:Number=0, len:Number=segs1.length;
            		for(i; i<len; ++i) {
                		seg1 = segs1[i];
                		seg1x1 = (seg1[0] as Point).x;  /* seg1.x1; */
                		seg1x2 = (seg1[0] as Point).y;  /* seg1.x2; */
                		seg1y1 = (seg1[1] as Point).x;  /* seg1.y1; */
                		seg1y2 = (seg1[1] as Point).y;  /* seg1.y2; */
                		
                		for(var j:Number=0, jlen:Number=segs2.length; j<jlen; ++j) {
                    		seg2 = segs2[j];
                    		if((seg2[0] as Point).x > seg1x2){
                      		 // seg1 still left of seg2
                        		break;
                    		}
                    		if((seg2[1] as Point).x < seg1x1) {
                    		    // seg2 still left of seg1
                    		    continue;
                   		 	}
                  		  	seg2y1 = (seg2[0] as Point).y;  /* seg2.y1; */
                  		  	seg2y2 = (seg2[1] as Point).y;  /* seg2.y2; */
                  		  	if(Math.min(seg2y1, seg2y2) > Math.max(seg1y1, seg1y2)) {
                     		   	// seg2 above seg1
                    		    continue;
                   		 	}
                   		 	if(Math.max(seg2y1, seg2y2) < Math.min(seg1y1, seg1y2)) {
                   		     	// seg2 below seg1
                   		     	continue;
                   		 	}
                   		 	if(Geometry.segmentsIntersect(seg1, seg2)) {
                   		     	intersect = true;
                   		 	}
               		 	}
               		 	if(intersect){break;}
            		}
        		}
        		else{
            		intersect = (geometry as Collection).intersects(this);
        		}
        		return intersect;
    		}   
    		
    		/**
    		 * Cut the line in different segments, and sort them
    		 * 
    		 * @return An array of segment. Segment contains 2 points. The first point1 has
    		 * 		properties x1 (point1.x), y1 (point1.y) and the second point2 has properties 
    		 * 		x2 (point2.x), y2 (point2.y).  The start point is represented by x1 and y1.
    		 *      The end point is represented by x2 and y2.  Start and end are ordered so that x1 < x2.
    		 */
    		 public function getSortedSegments():Array {
        		var numSeg:Number = this.components.length - 1;
        		var segments:Array = new Array(numSeg);
        		var point1:Point, point2:Point;
        		for(var i:Number=0; i<numSeg; ++i) {
            		point1 = this.components[i];
            		point2 = this.components[i + 1];
            		if(point1.x < point2.x){
                		segments[i] = new Array(2);
                		segments[i][0]=point1;
                		segments[i][1]=point2;
            		}
            		else {
                		segments[i] = new Array(2);
                		segments[i][0]=point2;
                		segments[i][1]=point1;
            		}
        		}
        		return segments;
    		} 
	}
}

