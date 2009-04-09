package org.openscales.core.feature
{
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.Icon;
	import org.openscales.core.Marker;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.popup.Anchored;
	import org.openscales.core.popup.Popup;
	
	/**
	 * Features are combinations of geography and attributes. The Feature
 	 * class specifically combines a marker and a lonlat.
	 */
	public class Feature
	{
		
	    public var layer:Layer = null;

	    public var id:String = null;
	    
	    public var lonlat:LonLat = null;

	    public var data:Object = null;
	    
	    private var marker:Marker = null;

	    public var popup:Popup = null;
	    
	    public var attributes:Object = null;
	    		
		public var selected:Boolean = false;
		
		public function Feature(layer:Layer, lonlat:LonLat, data:Object):void {
			this.layer = layer;
	        this.lonlat = lonlat;
	        if (data != null){
	        	this.data = data;
	        }
	        else{
	        	this.data = new Object();
	        }
	        
	        this.id = Util.createUniqueID(getQualifiedClassName(this) + "_"); 
		}
		
		public function destroy():void {
	        if ((this.layer != null) && (this.layer.map != null)) {
	            if (this.popup != null) {
	                this.layer.map.removePopup(this.popup);
	            }
	        }
	
	        this.layer = null;
	        this.id = null;
	        this.lonlat = null;
	        this.data = null;
	        if (this.marker != null) {
	            this.destroyMarker();
	            this.marker = null;
	        }
	        if (this.popup != null) {
	            this.destroyPopup();
	            this.popup = null;
	        }
		}
		
		public function onScreen():Boolean {
			var onScreen:Boolean = false;
	        if ((this.layer != null) && (this.layer.map != null)) {
	            var screenBounds:Bounds = this.layer.map.extent;
	            onScreen = screenBounds.containsLonLat(this.lonlat);
	        }    
	        return onScreen;
		}
		
		public function createMarker():Marker {
			var marker:Marker = null;
	        
	        if (this.lonlat != null) {
	            this.marker = new Marker();
	            this.marker.lonlat = this.lonlat;
	        }
	        return this.marker;
		}
		
		public function destroyMarker():void {
			this.marker.destroy();
		}
		
		public function createPopup(closeBox:Boolean = true):Popup {
			if (this.lonlat != null) {
            
	            var id:String = this.id + "_popup";
	            var anchor:Icon = this.marker;
	
	            this.popup = new Anchored(	id, 
	                                        this.lonlat,
	                                        this.data.popupSize,
	                                        this.data.popupContentHTML,
	                                        anchor, closeBox);                                        
                this.popup.feature = this;
	        } 
	        return this.popup;
		}
		
		public function destroyPopup():void {
			this.popup.destroy();
		}
		
	}
}