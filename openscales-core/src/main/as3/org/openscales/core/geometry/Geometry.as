package org.openscales.core.geometry
{
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.format.WKT;
	
	public class Geometry
	{
		
		public var id:String = null;

	    public var parent:Geometry = null;

	    public var bounds:Bounds = null;
		
		public function Geometry():void {
			this.id = Util.createUniqueID(getQualifiedClassName(this) + "_");
		}
		
		public function destroy():void {
			this.id = null;

        	this.bounds = null;
		}
		
		public function setBounds(bounds:Bounds):void {
			if (bounds) {
	            this.bounds = bounds.clone();
	        }
		}
		
		public function clearBounds():void {
	        this.bounds = null;
	        if (this.parent) {
	            this.parent.clearBounds();
	        }   
		}
		
		public function extendBounds(newBounds:Bounds):void {
			var bounds:Bounds = this.getBounds();
	        if (!bounds) {
	            this.setBounds(newBounds);
	        } else {
	            this.bounds.extend(newBounds);
	        }
		}
		
		public function getBounds():Bounds {
			if (this.bounds == null) {
	            this.calculateBounds();
	        }
	        return this.bounds;
		}
		
		public function calculateBounds():void {
			
		}
		
		public function atPoint(lonlat:LonLat, toleranceLon:Number, toleranceLat:Number):Boolean {
			var atPoint:Boolean = false;
	        var bounds:Bounds = this.getBounds();
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
		
		public function getLength():Number {
			return 0.0;
		}
		
		public function getArea():Number {
			return 0.0;
		}
		
		public function toString():String {
			return new WKT().write(
	            new Vector(this)
	        ).toString();
		}
	}
}