package org.openscales.core.feature
{
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.geometry.Geometry;
	
	public class Vector extends Feature
	{
		
		public var fid:String = null;

	    // TODO : types Geometry ?
	    public var geometry:Object = null;

	    public var state:String = null;
	    
	    public var style:Object = null;
	    
	    public var originalStyle:Object = null;
	    
	    public static var style:Object = {'default': {
		        fillColor: 0x00ff00,
		        fillOpacity: 0.4, 
		        hoverFillColor: "white",
		        hoverFillOpacity: 0.8,
		        strokeColor: 0x00ff00,
		        strokeOpacity: 1,
		        strokeWidth: 4,
		        strokeLinecap: "round",
		        hoverStrokeColor: "red",
		        hoverStrokeOpacity: 1,
		        hoverStrokeWidth: 0.2,
		        pointRadius: 6,
		        hoverPointRadius: 1,
		        hoverPointUnit: "%",
		        pointerEvents: "visiblePainted"
		    },
		    'select': {
		        fillColor: 0x00ff00,
		        fillOpacity: 0.4, 
		        hoverFillColor: "white",
		        hoverFillOpacity: 0.8,
		        strokeColor: 0xff0000,
		        strokeOpacity: 1,
		        strokeWidth: 2,
		        strokeLinecap: "round",
		        hoverStrokeColor: "red",
		        hoverStrokeOpacity: 1,
		        hoverStrokeWidth: 0.2,
		        pointRadius: 6,
		        hoverPointRadius: 1,
		        hoverPointUnit: "%",
		        pointerEvents: "visiblePainted",
		        cursor: "pointer"
		    },
		    'temporary': {
		        fillColor: "yellow",
		        fillOpacity: 0.2, 
		        hoverFillColor: "white",
		        hoverFillOpacity: 0.8,
		        strokeColor: "yellow",
		        strokeOpacity: 1,
		        strokeLinecap: "round",
		        strokeWidth: 4,
		        hoverStrokeColor: "red",
		        hoverStrokeOpacity: 1,
		        hoverStrokeWidth: 0.2,
		        pointRadius: 6,
		        hoverPointRadius: 1,
		        hoverPointUnit: "%",
		        pointerEvents: "visiblePainted"
		    }
	    };
		
		public function Vector(geometry:Geometry = null, data:Object = null, style:Object = null):void {
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
	            obj = new Feature(null, this.geometry.clone(), this.data);
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
	}
}