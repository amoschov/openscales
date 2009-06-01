package org.openscales.core.geometry
{
	import org.openscales.proj4as.ProjProjection;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Util;
	
	/**
	 * A Collection is exactly what it sounds like: A collection of different Geometries. 
	 * These are stored in the local parameter components (which can be passed as a parameter
	 * to the constructor).
	 * 
	 * As new geometries are added to the collection, they are NOT cloned. 
	 * When removing geometries, they need to be specified by reference
	 * (ie you have to pass in the exact geometry to be removed).
	 * 
	 * The getArea and getLength functions here merely iterate through the components,
	 * summing their respective areas and lengths.
	 * 
	 */	
	public class Collection extends Geometry
	{
		
		private var _components:Array = null;
		
    	private var _componentTypes:Array = null;
    	
    	public function Collection(components:Object):void {
    		super();
	        this.components = new Array();
	        if (components != null) {
	            this.addComponents(components);
	        }
    	}
    	
    	override public function destroy():void {
	        this.components.length = 0;
	        this.components = null;
    	}
		
		override public function clone():Geometry {
			var geometryClass:Class = Class(getDefinitionByName(getQualifiedClassName(this)));
			var geometry:Collection = new geometryClass();
	        for(var i:int=0; i<this.components.length; i++) {
	            geometry.addComponent(this.components[i].clone());
	        }
	        
	        Util.applyDefaults(geometry, this);
	        
	        return geometry;
		}
		
		public function getComponentsString():String {
			var strings:Array = [];
	        for(var i:int = 0; i < this.components.length; i++) {
	            strings.push(this.components[i].toShortString()); 
	        }
	        return strings.join(",");
		}
		
		override public function calculateBounds():void {
			this._bounds = null;
	        if ( !this.components || (this.components.length > 0)) {
	            this._bounds = this.components[0].getBounds();
	            for (var i:int = 1; i < this.components.length; i++) {
	                this.extendBounds(this.components[i].getBounds());
	            }
	        }
		}
		
		public function addComponents(components:Object):void {
			if(!(components is Array)) {
	            components = [components];
	        }
	        for(var i:int=0; i < components.length; i++) {
            	this.addComponent(components[i]);
	        }
		}
		
		public function addComponent(component:Object, index:Number = NaN):Boolean {
			var added:Boolean = false;
	        if(component) {
	            if(!(component is Array) && (this.componentTypes == null ||
	               (Util.indexOf(this.componentTypes, getQualifiedClassName(component)) > -1))) {
	
	                if(!isNaN(index) && (index < this.components.length)) {
	                    var components1:Array = this.components.slice(0, index);
	                    var components2:Array = this.components.slice(index, 
	                                                           this.components.length);
	                    components1.push(component);
	                    this.components = components1.concat(components2);
	                } else {
	                    this.components.push(component);
	                }
	                component.parent = this;
	                this.clearBounds();
	                added = true;
	            }
	        }
	        return added;
		}
		
		public function removeComponents(components:Object):void {
			if(!(components is Array)) {
	            components = [components];
	        }
	        for (var i:int = 0; i < components.length; i++) {
	            this.removeComponent(components[i]);
	        }
		}
		
		public function removeComponent(component:Object):void {    
	        Util.removeItem(this.components, component);
	        
	        this.clearBounds();
		}
		
		override public function get length():Number {
			var length:Number = 0.0;
	        for (var i:int = 0; i < this.components.length; i++) {
	            length += this.components[i].getLength();
	        }
	        return length;
		}
		
		override public function get area():Number {
	        var area:Number = 0.0;
	        for (var i:int = 0; i < this.components.length; i++) {
	            area += this.components[i].getArea();
	        }
	        return area;
		}
		
		public function move(x:Number, y:Number):void {
			for(var i:int = 0; i < this.components.length; i++) {
	            this.components[i].move(x, y);
	        }
		}
		
		public function equals(geometry:Object):Boolean {
			var equivalent:Boolean = true;
	        if(getQualifiedClassName(this) != getQualifiedClassName(geometry)) {
	            equivalent = false;
	        } else if(!(geometry.components is Array) ||
	                  (geometry.components.length != this.components.length)) {
	            equivalent = false;
	        } else {
	            for(var i:int=0; i<this.components.length; ++i) {
	                if(!this.components[i].equals(geometry.components[i])) {
	                    equivalent = false;
	                    break;
	                }
	            }
	        }
	        return equivalent;
		}
		
		 /**
		 * Method to convert the collection from a projection system to an other.
		 * 
		 * @param source The source projection
		 * @param dest The destination projection
		 */
		override public function transform(source:ProjProjection, dest:ProjProjection):void {
			if (this.components.length > 0) {
				for each (var geom:Geometry in this.components) {
					geom.transform(source, dest);
				}
			}
		}
		
		public function get components():Array {
			return this._components;
		}
		
		public function set components(value:Array):void {
			this._components = value;
		}
		
		public function get componentTypes():Array {
			return this._componentTypes;
		}
		
		public function set componentTypes(value:Array):void {
			this._componentTypes = value;
		}
	}
}