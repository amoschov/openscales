package org.openscales.core.geometry
{
	import org.openscales.proj4as.ProjProjection;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	
	/**
	 * A Geometry is a description of a geographic object.
	 * Create an instance of this class with the Geometry constructor.
	 * This is a base class, typical geometry types are described by subclasses of this class.
	 */
	public class Geometry
	{
		
		private var _id:String = null;

	    private var _parent:Geometry = null;

	    protected var _bounds:Bounds = null;
		
		/**
		 * Geometry constructor
		 */
		public function Geometry() {
			this.id = Util.createUniqueID(getQualifiedClassName(this) + "_");
		}
		
		/**
		 * Destroys the geometry
		 */
		public function destroy():void {
			this.id = null;

        	this._bounds = null;
		}
		
		/**
		 * Method to convert the lon/lat (x/y) value of the geometry from a projection sysrtem to an other.
		 * 
		 * @param source The source projection
		 * @param dest The destination projection
		 */
		 public function transform(source:ProjProjection, dest:ProjProjection):void {
		 	
		 }
		
		
		/**
		 * Clones the geometry
		 */
		public function clone():Geometry {
			var geometryClass:Class = Class(getDefinitionByName(getQualifiedClassName(this)));
			var geometry:Geometry = new geometryClass();
	       
	        Util.applyDefaults(geometry, this);
	        
	        return geometry;
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
		 * <p>Extends geometry's bounds</p>
		 * 
		 * <p>If bounds are not defined yet, it initializes the bounds. If bounds are already defined,
		 * it extends them.</p>
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