package org.openscales.core.feature
{
  import flash.utils.getQualifiedClassName;
  
  import org.openscales.core.Icon;
  import org.openscales.core.Marker;
  import org.openscales.core.Util;
  import org.openscales.core.basetypes.Bounds;
  import org.openscales.core.basetypes.LonLat;
  import org.openscales.core.basetypes.Pixel;
  import org.openscales.core.basetypes.Size;
  import org.openscales.core.events.FeatureEvent;
  import org.openscales.core.layer.Layer;
  import org.openscales.core.popup.Anchored;
  import org.openscales.core.popup.Popup;
  import flash.display.Sprite;
  import org.openscales.core.geometry.Geometry;
  import flash.events.MouseEvent;
  import org.openscales.core.events.SpriteCursorEvent;
  import org.openscales.core.events.FeatureEvent;
  
  	/**
	 * Features use the Geometry classes as geometry description.
	 * They have an ‘attributes’ property, which is the data object, and a ‘style’ property.
	 */
  public class Feature extends Sprite
  {

      private var _layer:Layer = null;

      private var _lonlat:LonLat = null;

      private var _data:Object = null;

      private var _marker:Marker = null;

      private var _popup:Popup = null;

      private var _attributes:Object = null;

      private var _selected:Boolean = false;
	

    /**
     * Constructor class
     *
     * @param layer The layer containing the feature.
     * @param lonlat The lonlat position of the feature.
     * @param data
     */
    public function Feature(layer:Layer = null, lonlat:LonLat = null, data:Object=null) {
      	  this.layer = layer;
          this.lonlat = lonlat;
          if (data != null){
            this.data = data;
          }
          else{
            this.data = new Object();
          }
          
          this.lonlat = null;
	      this.attributes = new Object();
	      if (data) {
	          this.attributes = Util.extend(this.attributes, data);
	      }	    
		
    }

    /**
     * Method to destroy a the feature instance.
     */
    public function destroy():void {
          this.layer = null;
          this.name = null;
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

    /**
     * Determines if the feature is visible on the screen
     */
    public function onScreen():Boolean {
      var onScreen:Boolean = false;
          if ((this.layer != null) && (this.layer.map != null)) {
              var screenBounds:Bounds = this.layer.map.extent;
              onScreen = screenBounds.containsLonLat(this.lonlat);
          }
          return onScreen;
    }

    /**
     * Create a marker for the feature instance and returns it.
     *
     * @return The created marker
     */
    public function createMarker(url:String = null, size:Size = null, offset:Pixel = null, calculateOffset:Function = null):Marker {
      var marker:Marker = null;

          if (this.lonlat != null) {
              this.marker = new Marker(url, size, offset, calculateOffset);
              this.marker.lonlat = this.lonlat;
              this.marker.feature = this;
              if (this.popup != null)
                this.marker.popup = this.popup;
          }
          return this.marker;
    }

    /**
     * Destroys the feature's marker
     */
    public function destroyMarker():void {
      this.marker.feature = null;
      this.marker.destroy();
      this.marker = null;
    }

    /**
     * Creates a popup for the feature
     *
     * @param closeBox
     * @return The created popup
     */
    public function createPopup(closeBox:Boolean=true):Popup {
      if (this.lonlat != null) {

              var id:String = this.name + "_popup";
              var anchor:Icon = this._marker;

              this.popup = new Anchored(	id,
                                          this.lonlat,
                                          this.data.popupBackground,
                                          this.data.popupBorder,
                                          this.data.popupSize,
                                          this.data.popupContentHTML,
                                          anchor,closeBox);

                this.popup.feature = this;
                if (this.marker != null)
                  this.marker.popup = this.popup;
          }
          return this.popup;
    }

    /**
     * Destroys the popup
     */
    public function destroyPopup():void {
      this.popup.feature = null;
      this.popup.destroy();
      this.popup = null;
        if (this.marker != null)
          this.marker.popup = null;

    }  
	
    public function get layer():Layer {
      return this._layer;
    }

    public function set layer(value:Layer):void {
    	this._layer = value;
      	if(this._layer != null) {
	      	this.addEventListener(MouseEvent.MOUSE_OVER, this.OnMouseHover);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.OnMouseOut);
			this.addEventListener(MouseEvent.CLICK, this.onMouseClick);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, this.onMouseDoubleClick);	
			this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);	
			this.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
			
			this._layer.addEventListener(SpriteCursorEvent.SPRITECURSOR_HIDE_HAND, hideHand);
			this._layer.addEventListener(SpriteCursorEvent.SPRITECURSOR_SHOW_HAND, showHand);
      }
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

    public function get marker():Marker {
      return this._marker;
    }

    public function set marker(value:Marker):void {
      this._marker = value;
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
		
		/**
		 * Events Management
		 * 
		 */
		 public function OnMouseHover(pevt:MouseEvent):void
		 {
		 	this.buttonMode=true;
		 	this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_OVER,this));
		 }
		  public function OnMouseOut(pevt:MouseEvent):void
		 {
		 	this.buttonMode=false;
		 	this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_OUT,this));
		 }
		 public function onMouseClick(pevt:MouseEvent):void
		 {
		 	this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_CLICK,this,pevt.ctrlKey));
		 }
		  public function onMouseDoubleClick(pevt:MouseEvent):void
		 {
		 	this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DOUBLECLICK,this));
		 }
		 
		 public function onMouseDown(pevt:MouseEvent):void
		 {
		 	/* this.buttonMode=true; */
		 	this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEDOWN,this));
		 }
		 
		  public function onMouseUp(pevt:MouseEvent):void
		 {
		 	/* this.buttonMode=false; */
		 	this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEUP,this,pevt.ctrlKey));
		 }
		 
		 public function OnMouseMove(pevt:MouseEvent):void
		 {
		 	this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEMOVE,this));
		 }
		 
		 private function hideHand(event:SpriteCursorEvent):void{
			this.useHandCursor=false;
		}
		private function showHand(event:SpriteCursorEvent):void{
			this.useHandCursor = true;
		}
		
  }
}
