package org.openscales.core.feature
{
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Icon;
	import org.openscales.core.Marker;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.popup.Anchored;
	import org.openscales.core.popup.Popup;
	
	/**
	 * Features are combinations of geography and attributes. The Feature
 	 * class specifically combines a marker and a lonlat.
	 */
	public class Feature
	{
		private var _id:String= null;
	    
	    private var _layer:Layer = null;
	    
	    private var _lonlat:LonLat = null;

	    private var _data:Object = null;
	    
	    private var _marker:Marker = null;

	    private var _popup:Popup = null;
	    
	    private var _attributes:Object = null;
	    		
		private var _selected:Boolean = false;
		
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
	        if (this._marker != null) {
	            this.destroyMarker();
	            this._marker = null;
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
	            this._marker = new Marker();
	            this._marker.lonlat = this.lonlat;
	        }
	        return this._marker;
		}
		
		public function destroyMarker():void {
			this._marker.destroy();
		}
		
		public function createPopup(closeBox:Boolean = true):Popup {
			if (this.lonlat != null) {
            
	            var id:String = this.id + "_popup";
	            var anchor:Icon = this._marker;
	
	            this.popup = new Anchored(	id, 
	                                        this.lonlat,
	                                        this.data.popupSize,
	                                        this.data.popupContentHTML,
	                                        this._marker,
	                                        closeBox);

                this.popup.feature = this;
	        } 
	        return this.popup;
		}
		
		public function destroyPopup():void {
			this.popup.destroy();
		}
		
		public function get id():String {
			return this._id;
		}
		
		public function set id(value:String):void {
			this._id = value;
		}
		
		public function get layer():Layer {
			return this._layer;
		}
		
		public function set layer(value:Layer):void {
			this._layer = value;
		}
		
		public function get lonlat():LonLat {
			return this._lonlat;
		}
		
		public function set lonlat(value:LonLat):void {
			this._lonlat = value;
		}
		
		public function get data():Object {
			return this._data;
		}
		
		public function set data(value:Object):void {
			this._data = value;
		}
		
		public function get popup():Popup {
			return this._popup;
		}
		
		public function set popup(value:Popup):void {
			this._popup = value;
		}
		
		public function get attributes():Object {
			return this._attributes;
		}
		
		public function set attributes(value:Object):void {
			this._attributes = value;
		}
		
		public function get selected():Boolean {
			return this._selected;
		}
		
		public function set selected(value:Boolean):void {
			this._selected = value;
		}
		
	}
}