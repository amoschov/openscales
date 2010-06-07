package org.openscales.geometry
{
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.basetypes.Bounds;
	import org.openscales.proj4as.Proj4as;
	import org.openscales.proj4as.ProjPoint;
	import org.openscales.proj4as.ProjProjection;

	public class CollectionPoint extends Geometry implements ICollection
	{
		/**
		 * The component parts of this geometry
		 * 
		 */
		protected var _components:Vector.<Number> = null;
		
		/**
		 * An array of class names representing the types of
		 * components that the collection can include.  A null value means the
		 * component types are not restricted.
		 */
		private var _componentTypes:Vector.<String> = null;
		
		/**
		 * Creates a Geometry Collection
		 * the geometry is a vector of point which are stocked in vector.<Number>
		 * "even index" are x and "uneven index" are y
		 * exemple : 
		 * this._components[0] => first x
		 * this._components[1] => first y 
		 * this._components[2] => second x
		 * this._components[3] => second y
		 * .
		 * . 
		 * 
		 * @param components
		 */
		public function CollectionPoint(points:Vector.<Number>) {
			super();
			if (points != null) {
				this._components = points;
			}
			else{
				this._components = new Vector.<Number>();
			}
			this.clearBounds();
			this.componentTypes = new <String>["org.openscales.geometry::Point"];
		}
		
		/**
		 * Destroy the collection.
		 */
		override public function destroy():void {
			this._components.length = 0;
			this._components = null;
		}
		
		public function componentByIndex(i:int):Geometry {
			var j:uint = i * 2;
			return ((j<0)||(j>=this._components.length)) ? null : new Point(this._components[j],this._components[j+1]);
		}
		
		/**
		 * Getter and setter of the authorized types for the components
		 *   (children) of this collection
		 */
		public function get componentTypes():Vector.<String> {
			return this._componentTypes;
		}		
		public function set componentTypes(value:Vector.<String>):void {
			this._componentTypes = value;
		}
		
		/**
		 * Setter of the components (children) of this collection.
		 * The getter is not defined to avoid to return a untyped array.
		 * Use componentsLength() and componentByIndex(i) instead.
		 */
		public function set components(value:Vector.<Number>):void {
			this._components = (value==null) ? new Vector.<Number>() : value;
		}
		
		public function get components():Vector.<Number> {
			return this._components;
		}
		
		/**
		 * Number of Point in the collection
		 */		
		public function get componentsLength():int {
			return this._components.length/2;
		}
		/**
		 * TO get component clone
		 * */
		
		public function getcomponentsClone():Vector.<Number>{
			var componentsClone:Vector.<Number>=null;
			var componentslength:Number=this._components.length;
			if(componentslength<=0) return null;
			else componentsClone=new Vector.<Number>(componentslength);
			for(var i:int=0;i<componentslength;++i)	{
				componentsClone[i] = this._components[i];
			}
			return componentsClone;
		}
		
		/**
		 * To get this geometry clone
		 * */
		override public function clone():Geometry{		
			//All collection
			var Collectionclone:CollectionPoint=new CollectionPoint(null);
			var component:Vector.<Number>=this.getcomponentsClone();
			Collectionclone.addPoints(component);
			return Collectionclone;		
		}
		
		/**
		 * Get a string representing the components for this collection
		 * 
		 * @return A string representation of the components of this collection
		 */
		public function get componentsString():String {
			var strings:Vector.<String> = new Vector.<String>(this.componentsLength);
			var length:uint = this.componentsLength;
			var realIndex:uint;
			for(var i:int = 0; i < this.length; ++i) {
				realIndex= i*2;
				strings[i]= this._components[realIndex] + ", " + this._components[realIndex+1];
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
		 * Return an array of all the vertices (Point) of this geometry
		 */
		override public function toVertices():Vector.<Point> {
			var vertices:Vector.<Point> = new Vector.<Point>(this.componentsLength);
			var j:uint=0;
			var length:uint= this._components.length - 1;
			for(var i:int=0; i<length; i+=2) {
				vertices[j] = new Point(this._components[i],this._components[i+1]);
				j++
			}
			return vertices;
		}
		
		/**
		 * Recalculate the bounds by iterating through the components and 
		 * calling extendBounds() on each item.
		 */
		override public function calculateBounds():void {
			this._bounds = null;
			var length:uint = this._components.length;
			if (length > 0) {
				var left:Number = this._components[0];
				var bottom:Number = this._components[1];
				var right:Number = this._components[0];
				var top:Number = this._components[1];
				var tempNumber:Number;
				for (var i:int=2; i<length; i+=2) {
					tempNumber = this._components[i];
					left = (left < tempNumber) ? left :tempNumber;
					right = (right > tempNumber) ? right : tempNumber;
					tempNumber = this._components[i+1];
					bottom = (bottom < tempNumber) ? bottom : tempNumber;
					top = (top > tempNumber) ?top : tempNumber;
				}
				this._bounds = new Bounds(left,bottom,right,top);
			}
		}
		
		
		
		public function addPoints(components:Vector.<Number>):void {
			for(var i:int=0; i < components.length; i+=2) {
				this.addPoint(components[i],components[i+1]);
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
		public function addPoint(x:Number,y:Number, index:Number = NaN):Boolean {
			var added:Boolean = false;
			var realIndex:uint = index *2;
			if(isNaN(x) || isNaN(y)) return false;
				if(!isNaN(index) && (realIndex < this._components.length)) {
					var components1:Vector.<Number> = this._components.slice(0, realIndex);
					var components2:Vector.<Number> = this._components.slice(realIndex, this._components.length);
					components1.push(x);
					components1.push(y);
					this.components = components1.concat(components2);
				} else {
					this._components.push(x);
					this._components.push(y);
				}
				this.clearBounds();
				added = true;
			if (! added) {
				trace("collection.addComponent ERROR : impossible to add geometry, componentTypes="+this.componentTypes);
			}
			return added;
		}
		
		/**
		 * Add components to this geometry.
		 *
		 * @param components An array of geometries to add
		 */
		public function addComponents(components:Vector.<Geometry>):void {
			for(var i:int=0; i < components.length; ++i) {
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
			var realIndex:uint = index *2;
			if(!(component is Point)) return false;
			var point:Point = component as Point;
			if(component) {
					if(!isNaN(index) && (realIndex < this._components.length)) {
						var components1:Vector.<Number> = this._components.slice(0, realIndex);
						var components2:Vector.<Number> = this._components.slice(realIndex, this._components.length);
						components1.push(point.x);
						components1.push(point.y);
						this._components = components1.concat(components2);
					} else {
						this._components.push(point.x);
						this._components.push(point.y);
					}
					this.clearBounds();
					added = true;
    		}
			if (! added) {
				trace("collection.addComponent ERROR : impossible to add geometry, componentTypes="+this.componentTypes);
			}
			return added;
		}
		
		/**
		 * Remove components from this geometry.
		 *
		 * @param components The components to be removed
		 */
		public function removeComponents(components:Array):void {
			for (var i:int = 0; i < components.length; ++i) {
				this.removeComponent(components[i]);
			}
		}
		
		/**
		 * Remove a component from this geometry.
		 *
		 * @param component 
		 */
		public function removeComponent(component:Geometry):void {    
			if(!(component is Point)) return ;
			var point:Point= component as Point;
			var indice:uint;
			var length:uint= this._components.length - 1; 
			for(var i:uint= 0;i<length;i+=2){
			  if(this._components[i] == point.x ){
				  if(this._components[i+1] == point.y){
					  indice = i;
				  }
			  }
			}
			
			this._components.splice(indice,2);
			
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
			if(!(component is Point)) return false;
			
			var point:Point = component as Point;
			var realIndex:uint = index * 2;
			if ((realIndex<0) || (realIndex>=this._components.length)) {
				trace("Collection.replaceComponent ERROR : invalid index "+index);
				return false;
			}
			
			// All is ok, replace the specified component by the input one
			this._components[realIndex] = point.x;
			this._components[realIndex + 1] = point.y;
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
		for (var i:int = 0; i < this.componentsLength; ++i) {
		length += this.componentByIndex(i).getLength();
		}
		return length;
		}*/
		/**
		 * Method to convert the collection from a projection system to an other.
		 *
		 * @param source The source projection
		 * @param dest The destination projection
		 */
		override public function transform(source:ProjProjection, dest:ProjProjection):void {
			var p:ProjPoint;
			for(var i:int=0; i<this._components.length; i+=2) {
				p = new ProjPoint(this._components[i], this._components[i+1]);
				Proj4as.transform(source, dest, p);
				this._components[i] = p.x;
				this._components[i+1] = p.y;
			}
		}
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
			//all the point are an area of 0.0 so the sum is 0
			return 0.0;
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
		for(var i:int = 0; i < this.componentsLength; ++i) {
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
		 * Determine if the input geometry intersects this one.
		 *
		 * @param geom Any type of geometry.
		 *
		 * @return The input geometry intersects this one.
		 */
		override public function intersects(geom:Geometry):Boolean {
			var length:uint = this._components.length;
			for(var i:int=0; i<length; i+=2) {
				if (geom.intersects(new Point(this._components[i],this._components[i+1]))) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Test if a point is inside this geometry.
		 * 
		 * @param p the point to test
		 * @return a boolean defining if the point is inside or outside this geometry
		 */
		override public function containsPoint(p:Point):Boolean {
			for(var i:int=0; i<this.componentsLength; i+=2) {
				
				if(this._components[i] == p.x && this._components[i+1] == p.y){
					return true
				}
			}
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
	
		override public function distanceTo(geometry:Geometry, options:Object=null):Number{
			var edge:Boolean = !(options && options.edge === false);
			var details:Boolean = edge && options && options.details;
			var result:Number, best:Number;
			var distance:Number;
			var min:Number = Number.POSITIVE_INFINITY;
			var point:Point = new Point(0,0);
			var realIndex:int = 0;
			for(var i:int=0, len:int=this.componentsLength; i<len; ++i) {
				realIndex= i*2;
				result = new Point(this._components[realIndex],this._components[realIndex + 1]).distanceTo(geometry, options);
				if(result < min) {
					min = result;
					best = result;
					if(min == 0) {
						break;
					}
				}
			}
			return best;
		}	
		
	}
}