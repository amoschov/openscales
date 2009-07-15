package org.openscales.fx.feature
{
  import flash.display.Sprite;
  import flash.utils.getQualifiedClassName;

  import org.openscales.core.Icon;
  import org.openscales.core.Marker;
  import org.openscales.core.Util;
  import org.openscales.core.basetypes.LonLat;
  import org.openscales.core.basetypes.Pixel;
  import org.openscales.core.basetypes.Size;
  import org.openscales.core.feature.Feature;
  import org.openscales.core.layer.Layer;
  import org.openscales.core.popup.Popup;
  import org.openscales.fx.FxMap;
  import org.openscales.fx.layer.FxLayer;
  import org.openscales.fx.popup.FxAnchored;
  import org.openscales.fx.popup.FxPopup;

  /**
   * Features are combinations of geography and attributes. The Feature
    * class specifically combines a marker and a lonlat.
   */
  public class FxFeature
  {
    private var _id:String= null;

      private var _feature:Feature = null;

      private var _fxmap:FxMap = null;

      private var _popup:FxPopup = null;

    /**
     * Constructor class
     *
     * @param layer The layer containing the feature.
     * @param lonlat The lonlat position of the feature.
     * @param data
     */
    public function FxFeature(layer:Sprite, lonlat:LonLat, data:Object=null, map:FxMap=null) {
      this.id = Util.createUniqueID(getQualifiedClassName(this) + "_");

      if (layer is FxLayer){
        this.fxmap = (layer as FxLayer).fxmap;
        this.feature = new Feature((layer as FxLayer).getInstance(), lonlat, data);
      }
      else if (layer is Layer){
          this.fxmap = map;
          this.feature = new Feature((layer as Layer), lonlat, data);
      }

    }

    /**
     * Method to destroy a the feature instance.
     */
    public function destroy():void {
          if (this.fxmap != null) {
              if (this.popup != null) {
                  this.fxmap.removePopup(this.popup);
              }
          }

          this.feature.destroy();

          if (this.popup != null) {
              this.destroyPopup();
              this.popup = null;
          }
    }

    /**
     * Determines if the feature is visible on the screen
     */
    public function onScreen():Boolean {
      if (this.feature != null)
        return this.feature.onScreen()
      else
        return false;
    }

    /**
     * Create a marker for the feature instance and returns it.
     *
     * @return The created marker
     */
    public function createMarker(url:String = null, size:Size = null, offset:Pixel = null, calculateOffset:Function = null):Marker {
      if (this.feature != null)
        return this.feature.createMarker(url, size, offset, calculateOffset);
      else
        return null;
    }

    /**
     * Destroys the feature's marker
     */
    public function destroyMarker():void {
      if (this.feature != null)
        this.feature.destroyMarker();
    }

    /**
     * Creates a popup for the feature
     *
     * @param closeBox
     * @return The created popup
     */
    public function createPopup(closeBox:Boolean=true):Sprite {
      if (this.lonlat != null) {

              var id:String = this.id + "_popup";
              var anchor:Icon = this.marker;

              if (this.data.popupContent != null) {
                this.popup = new FxAnchored(	id,
                                          this.lonlat,
                                          this.data.popupSize,
                                          this.data.popupContent,
                                          anchor,closeBox);

                (this.popup as FxPopup).feature = this;
              } else if (this.data.popupContentHTML != null) {
                this.feature.createPopup(closeBox);
              }
          }
          return this.popup;
    }

    /**
     * Destroys the popup
     */
    public function destroyPopup():void {
      if (this.popup is FxPopup){
        (this.popup as FxPopup).feature = null;
        (this.popup as FxPopup).destroy();
      }
      else if (this.popup is Popup){
        (this.popup as Popup).feature = null;
        (this.popup as Popup).destroy();
      }
      this.popup = null;
    }

    public function get id():String {
      return this._id;
    }

    public function set id(value:String):void {
      this._id = value;
    }

    public function get fxmap():FxMap {
      return this._fxmap;
    }

    public function set fxmap(value:FxMap):void {
      this._fxmap = value;
    }

    public function get feature():Feature {
      return this._feature;
    }

    public function set feature(value:Feature):void {
      this._feature = value;
    }

    public function get popup():Sprite {
      if (this._popup != null)
        return this._popup;
      else if (this.feature != null)
        return this.feature.popup
      else
        return null;
    }

    public function set popup(value:Sprite):void {
      this._popup = value as FxPopup;
    }

    public function get layer():Layer {
      if (this.feature != null)
        return this.feature.layer;
      else
        return null;
    }

    public function get lonlat():LonLat {
      if (this.feature != null)
        return this.feature.lonlat;
      else
        return null;
    }

    public function get data():Object {
      if (this.feature != null)
        return this.feature.data;
      else
        return null;
    }

    public function get marker():Marker {
      if (this.feature != null)
        return this.feature.marker;
      else
        return null;
    }

    public function get attributes():Object {
      if (this.feature != null)
        return this.feature.attributes;
      else
        return null;
    }

    public function get selected():Boolean {
      if (this.feature != null)
        return this.feature.selected;
      else
        return false;
    }

  }
}
