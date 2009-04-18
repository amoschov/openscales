package org.openscales.core.geometry
{
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
		
		public function Geometry():void {
			this.id = Util.createUniqueID(getQualifiedClassName(this) + "_");
		}
		
		public function destroy():void {
			this.id = null;

        	this._bounds = null;
		}
		
		public function clone():Geometry {
			var geometryClass:Class = Class(getDefinitionByName(getQualifiedClassName(this)));
			var geometry:Geometry = new geometryClass();
	       
	        Util.applyDefaults(geometry, this);
	        
	        return geometry;
		}
		
		public function clearBounds():void {
	        this._bounds = null;
	        if (this._parent) {
	            this._parent.clearBounds();
	        } 
		}
		
		public function extendBounds(newBounds:Bounds):void {
			var bounds:Bounds = this._bounds;
	        if (!bounds) {
	            this._bounds = newBounds;
	        } else {
	            this._bounds.extend(newBounds);
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
		
		public function get length():Number {
			return 0.0;
		}
		
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