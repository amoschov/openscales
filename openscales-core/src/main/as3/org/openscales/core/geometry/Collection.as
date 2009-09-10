package org.openscales.core.geometry
{
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Trace;
	import org.openscales.core.Util;
	import org.openscales.proj4as.ProjProjection;

	/**
	 * A Collection is exactly what it sounds like: A collection of different Geometries.
	 * These are stored in the local parameter components (which can be passed as a parameter
	 * to the constructor).
	 *
	 * The getArea and getLength functions here merely iterate through the components,
	 * summing their respective areas and lengths.
	 */	
	public class Collection extends Geometry
	{
		/**
     	 * The component parts of this geometry
     	 */
		private var _components:Array = null;
		
		/**
     	 * An array of class names representing the types of
     	 * components that the collection can include.  A null value means the
     	 * component types are not restricted.
     	 */
		private var _componentTypes:Array = null;
		
		/**
     	 * Creates a Geometry Collection
     	 *
     	 * @param components
     	 */
		public function Collection(components:Array) {
			super();
			this.components = new Array();
			if (components != null) {
				this.addComponents(components);
			}
		}
		
		/**
     	 * Destroy the collection.
     	 */
		override public function destroy():void {
			this._components.length = 0;
			this._components = null;
		}
		
		/**
		 * Getter and setter of the authorized types for the components
		 *   (children) of this collection
		 */
		public function get componentTypes():Array {
			return this._componentTypes;
		}		
		public function set componentTypes(value:Array):void {
			this._componentTypes = value;
		}

		/**
		 * Setter of the components (children) of this collection.
		 * The getter is not defined to avoid to return a untyped array.
		 * Use componentsLength() and componentByIndex(i) instead.
		 */
		/*private function get components():Array {
			return this._components;
		}*/		
		public function set components(value:Array):void {
			this._components = (value==null) ? new Array() : value;
		}

		/**
		 * Number of components in the collection
		 */		
		public function get componentsLength():int {
			return this._components.length;
		}
		
		/**
		 * Component of the specified index, casted to the Geometry type
		 */
		public function componentByIndex(i:int):Geometry {
			return ((i<0)||(i>=this._components.length)) ? null : (this._components[i] as Geometry);
		}


		/**
     	 * Get a string representing the components for this collection
     	 * 
     	 * @return A string representation of the components of this collection
      	 */
		public function get componentsString():String {
			var strings:Array = [];
			for(var i:int = 0; i < this.componentsLength; i++) {
				strings.push(this.componentByIndex(i).toShortString());
			}
			return strings.join(",");
		}
		
		/**
		 * 
		 */
		override public function toShortString():String {
			return componentsString;
		}

		/**
     	 * Recalculate the bounds by iterating through the components and 
     	 * calling extendBounds() on each item.
     	 */
		override public function calculateBounds():void {
			this._bounds = null;
			if (this.componentsLength > 0) {
				this._bounds = this.componentByIndex(0).bounds;
				for (var i:int=1; i<this.componentsLength; i++) {
					this.extendBounds(this.componentByIndex(i).bounds);
				}
			}
		}
	
		/**
     	 * Add components to this geometry.
     	 *
     	 * @param components An array of geometries to add
     	 */
		public function addComponents(components:Array):void {
			for(var i:int=0; i < components.length; i++) {
				this.addComponent(components[i]);
			}
		}
		
		/**
     	 * Add a new component (geometry) to the collection.  If this.componentTypes
     	 * is set, then the component class name must be in the componentTypes array.
     	 * The bounds cache is reset.
     	 * 
      	 * @param component A geometry to add
     	 * @param index Optional index into the array to insert the component
     	 *
     	 * @return The component geometry was successfully added
     	 */
		public function addComponent(component:Geometry, index:Number = NaN):Boolean {
			var added:Boolean = false;
			if(component) {
				if(!(component is Array) && (this.componentTypes == null ||
					(Util.indexOf(this.componentTypes, getQualifiedClassName(component)) > -1))) {

					if(!isNaN(index) && (index < this.componentsLength)) {
						var components1:Array = this._components.slice(0, index);
						var components2:Array = this._components.slice(index, this.componentsLength);
						components1.push(component);
						this.components = components1.concat(components2);
					} else {
						this._components.push(component);
					}
					
					component.parent = this;
					this.clearBounds();
					added = true;
				}
			}
			if (! added) {
				Trace.error("collection.addComponent ERROR : impossible to add geometry, componentTypes="+this.componentTypes);
			}
			return added;
		}

		/**
     	 * Remove components from this geometry.
     	 *
     	 * @param components The components to be removed
     	 */
		public function removeComponents(components:Array):void {
			for (var i:int = 0; i < components.length; i++) {
				this.removeComponent(components[i]);
			}
		}
		
		/**
     	 * Remove a component from this geometry.
     	 *
     	 * @param component 
     	 */
		public function removeComponent(component:Geometry):void {    
			Util.removeItem(this._components, component);
			this.clearBounds();
		}
		
		/**
     	 * replace the component of specified index by the input geometry.
     	 *
     	 * @param index the index of the component to replace
     	 * @param component the new component to use 
     	 */
		public function replaceComponent(index:int, component:Geometry):Boolean {
			// Test if the index is valid
			if ((i<0) || (i>=this._components.length)) {
				Trace.error("Collection.replaceComponent ERROR : invalid index "+index);
				return false;
			}
			// Test if the type of component is one of the allowed types
			var validComponentType:Boolean = false;
			for(var i:int=0; (!validComponentType) && (i<this.componentTypes.length); i++) {
				if (this.componentTypes[i] == getQualifiedClassName(component)) {
					validComponentType = true;
				}
			}
			if (! validComponentType) {
				Trace.error("Collection.replaceComponent ERROR : invalid component type "+getQualifiedClassName(component)+" for "+getQualifiedClassName(this));
				return false;
			}
			// All is ok, replace the specified component by the input one
			this._components[i] = component;
			this.clearBounds();
			return true;
		}
		
		/**
     	 * Calculate the length of this geometry
     	 *
     	 * @return The length of the geometry
      	 */
// TODO (in all classes)
		/*override public function get length():Number {
			var length:Number = 0.0;
			for (var i:int = 0; i < this.componentsLength; i++) {
				length += this.componentByIndex(i).getLength();
			}
			return length;
		}*/
		
		/**
		 * Calculate the approximate area of this geometry (the projection and
		 * the geodesic are not managed).
		 * 
		 * Be careful, if some components intersect themselves, the intersection
		 * area is added several times !
		 * Moreover, the auto-intersection of edges of each LinearRing is not
		 * managed.
		 * 
		 * Note how this function is overridden in LinearRing and in Polygon.
		 * 
		 * @return The area of the collection is defining by summing its parts.
		 */
		override public function get area():Number {
			var _area:Number = 0.0;
			for (var i:int=0; i<this.componentsLength; i++) {
				_area += this.componentByIndex(i).area;
			}
			return _area;
		}
		
		/**
     	 * Moves a geometry by the given displacement along positive x and y axes.
     	 *     This modifies the position of the geometry and clears the cached
     	 *     bounds.
      	 *
     	 * @param x Distance to move geometry in positive x direction. 
     	 * @param y Distance to move geometry in positive y direction.
     	 */
// TODO (in all classes)
		/*public function move(x:Number, y:Number):void {
			for(var i:int = 0; i < this.componentsLength; i++) {
				this.componentByIndex(i).move(x, y);
			}
		}*/
		
		/**
     	 * Rotate a geometry around some origin
     	 *
     	 * @param angle Rotation angle in degrees (measured counterclockwise
     	 *                 from the positive x-axis)
     	 * @param origin Center point for the rotation
     	 */
// TODO (in all classes)
   		/*public function rotate(angle:Number, origin:Point):void{
        	var i:Number=0;
        	var len:Number = this.componentsLength;
        	for(i; i<len; ++i) {
            	(this.components[i] as Geometry).rotate(angle, origin);
        	}
    	}*/
    	
    	/**
     	 * Resize a geometry relative to some origin.  Use this method to apply
     	 *     a uniform scaling to a geometry.
     	 *
     	 * @param scale Factor by which to scale the geometry.  A scale of 2
     	 *                 doubles the size of the geometry in each dimension
     	 *                 (lines, for example, will be twice as long, and polygons
     	 *                 will have four times the area).
     	 * @param origin Point of origin for resizing
     	 * @param ratio Optional x:y ratio for resizing.  Default ratio is 1.
      	 * 
     	 * @return The current geometry. 
     	 */
// TODO (in all classes)
    	/*public function resize(scale:Number, origin:Point, ratio:Number):Geometry {
        	var i:Number=0;
        	for(i; i<this.componentsLength; ++i) {
            	(this.components[i] as Geometry).resize(scale, origin, ratio);
        	}
        	return this;
    	}*/

		/** 
     	 * Determine whether another geometry is equivalent to this one.  Geometries
     	 *     are considered equivalent if all components have the same coordinates.
     	 * 
     	 * @params geom The geometry to test. 
     	 *
     	 * @return The supplied geometry is equivalent to this geometry.
     	 */
// TODO (in all classes)
     	/*public function equals(geom:Collection):Boolean {
			if(getQualifiedClassName(this) != getQualifiedClassName(geom)) {
				return false;
			} else if(geom.componentsLength != this.componentsLength) {
				return false;
			} else {
				for(var i:int=0; i<this.componentsLength; ++i) {
					if(! this.componentByIndex(i).equals(geom.componentByIndex(i))) {
						return false;
					}
				}
			}
			return true;
		}*/

		/**
		 * Method to convert the collection from a projection system to an other.
		 *
		 * @param source The source projection
		 * @param dest The destination projection
		 */
		override public function transform(source:ProjProjection, dest:ProjProjection):void {
			for(var i:int=0; i<this.componentsLength; i++) {
				this.componentByIndex(i).transform(source, dest);
			}
		}
		
		/**
    	* Determine if the input geometry intersects this one.
     	*
     	* @param geom Any type of geometry.
     	*
     	* @return The input geometry intersects this one.
     	*/
    	override public function intersects(geom:Geometry):Boolean {
			if (geom is Point) {
Trace.debug("Collection.intersects translated to Point.intersects");
				return (geom as Point).intersects(this);
			} else {
				for(var i:int=0; i<this.componentsLength; ++i) {
					if ((geom as Collection).intersects(this.componentByIndex(i))) {
Trace.debug("Collection.intersects true from component "+i);
						return true;
					}
				}
Trace.debug("Collection.intersects false for each component");
				return false;
			}
			// never used
			return false;
    	}
    	
    	/**
     	 * APIMethod: distanceTo
     	 * Calculate the closest distance between two geometries (on the x-y plane).
     	 *
     	 * Parameters:
     	 * geometry - {<OpenLayers.Geometry>} The target geometry.
     	 * options - {Object} Optional properties for configuring the distance
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
//TODO implement me
     	/* public function distanceTo(geometry, options) {
        	var edge = !(options && options.edge === false);
        	var details = edge && options && options.details;
        	var result, best;
        	var min = Number.POSITIVE_INFINITY;
        	for(var i=0, len=this.componentsLength; i<len; ++i) {
            	result = this.componentByIndex(i).distanceTo(geometry, options);
            	distance = details ? result.distance : result;
            	if(distance < min) {
                	min = distance;
                	best = result;
                	if(min == 0) {
                    	break;
                	}
            	}
        	}
        	return best;
    	} */	
		
	}
}

