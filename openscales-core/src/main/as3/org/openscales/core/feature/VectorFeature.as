package org.openscales.core.feature
{
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.geometry.Geometry;
	
	/**
	 * Vector features use the Geometry classes as geometry description.
	 * They have an ‘attributes’ property, which is the data object, and a ‘style’ property,
	 * the default values of which are defined in the OpenLayers.Feature.Vector.style objects
	 */
	public class VectorFeature extends Feature
	{
		
	    private var _geometry:Geometry = null;

	    private var _state:String = null;
	    
	    private var _style:Style = null;
	    
	    private var _originalStyle:Style = null;
		
		public function VectorFeature(geometry:Geometry = null, data:Object = null, style:Style = null):void {
			super(null, null, data);
	        this.lonlat = null;
	        this.geometry = geometry;
	        this.state = null;
	        this.attributes = new Object();
	        if (data) {
	            this.attributes = Util.extend(this.attributes, data);
	        }
	        this.style = style ? style : null; 
		}
		
		override public function destroy():void {
			if (this.layer) {
	            //this.layer.destroy();
	            this.layer = null;
	        }
	            
	        this.geometry = null;
	        //super.destroy();
		}
		
		public function clone(obj:Object):Object {
			if (obj == null) {
	            obj = new VectorFeature(this.geometry.clone(),this.data , this.style);
	        } 
	        
	        Util.applyDefaults(obj, this);
	        
	        return obj;
		}
		
		override public function onScreen():Boolean {
			return false;
		}
		
		public function atPoint(lonlat:LonLat, toleranceLon:Number, toleranceLat:Number):Boolean {
			var atPoint:Boolean = false;
	        if(this.geometry) {
	            atPoint = this.geometry.atPoint(lonlat, toleranceLon, 
	                                                    toleranceLat);
	        }
	        return atPoint;
		}
		
		public function toState(state:String):void {
			if (state == State.UPDATE) {
	            switch (this.state) {
	                case State.UNKNOWN:
	                case State.DELETE:
	                    this.state = state;
	                    break;
	                case State.UPDATE:
	                case State.INSERT:
	                    break;
	            }
	        } else if (state == State.INSERT) {
	            switch (this.state) {
	                case State.UNKNOWN:
	                    break;
	                default:
	                    this.state = state;
	                    break;
	            }
	        } else if (state == State.DELETE) {
	            switch (this.state) {
	                case State.INSERT:
	                    break;
	                case State.DELETE:
	                    break;
	                case State.UNKNOWN:
	                case State.UPDATE:
	                    this.state = state;
	                    break;
	            }
	        } else if (state == State.UNKNOWN) {
	            this.state = state;
	        }
		}
		
		public function get geometry():Geometry {
			return this._geometry;
		}
		
		public function set geometry(value:Geometry):void {
			this._geometry = value;
		}
		
		public function get state():String {
			return this._state;
		}
		
		public function set state(value:String):void {
			this._state = value;
		}
		
		public function get style():Style {
			return this._style;
		}
		
		public function set style(value:Style):void {
			this._style = value;
		}
		
		public function get originalStyle():Style {
			return this._originalStyle;
		}
		
		public function set originalStyle(value:Style):void {
			this._originalStyle = value;
		}
	}
}