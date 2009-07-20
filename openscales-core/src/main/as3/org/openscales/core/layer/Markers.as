package org.openscales.core.layer
{
  import org.openscales.core.Marker;
  import org.openscales.core.Util;
  import org.openscales.core.basetypes.Bounds;
  import org.openscales.core.basetypes.Pixel;

  /**
   * A layer composed of markers
   *
   * @author Bouiaw
   */
  public class Markers extends Layer
  {

    private var _markers:Array = null;

      private var _drawn:Boolean = false;

      /**
       * Create a Markers layer.
       *
       * @aram name
       * @param isBaseLayer
       * @param visible
       * @param projection
       * @param proxy
       */
      public function Markers(name:String, isBaseLayer:Boolean = false, visible:Boolean = true,
                  projection:String = null, proxy:String = null) {

        super(name, isBaseLayer, visible, projection, proxy);
        this.markers = [];

        // For better performances
        this.cacheAsBitmap = true;
      }

      override public function destroy(setNewBaseLayer:Boolean = true):void {
        this.clearMarkers();
        this.markers = null;
        super.destroy(setNewBaseLayer);
      }

      override public function set alpha(alpha:Number):void {
        if (alpha != this.alpha) {
              super.alpha = alpha;
              for (var i:int = 0; i < this.markers.length; i++) {
                //	this.markers[i].alpha(this.alpha);
                  this.markers[i].alpha = (this.alpha);
              }
          }
      }

      /**
       * moveTo
       *
       * @param bounds
       * @param zoomChanged
       * @param dragging
       */
      override public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean=false,resizing:Boolean=false):void {
        super.moveTo(bounds, zoomChanged, dragging,resizing);

          if (zoomChanged || !this.drawn) {
              for(var i:int=0; i < this.markers.length; i++) {
                  this.drawMarker(this.markers[i]);
              }
              this.drawn = true;
          }
      }

      public function addMarker(marker:Marker):void {
        this.markers.push(marker);
          if (this.map && this.map.extent) {
              marker.map = this.map;
              this.drawMarker(marker);
          }
      }

      public function removeMarker(marker:Marker):void {
          Util.removeItem(this.markers, marker);
          if ((marker != null) && (marker.parent == this) ) {
              marker.map = null;
              marker.destroy();
              this.removeChild(marker);
          }
      }

       /**
       * This method removes all markers from a layer. The markers are not
       * destroyed by this function, but are removed from the list of markers.
       */
      public function clearMarkers():void {
        if (this.markers != null) {
              while(this.markers.length > 0) {
                  this.removeMarker(this.markers[0]);
              }
          }
      }

      /**
       * Calculate the pixel location for the marker, create it, and
       *    add it
       *
       * @param marker
       */
      public function drawMarker(marker:Marker):void {
        var px:Pixel = this.map.getLayerPxFromLonLat(marker.lonlat);
          if (px == null) {
              marker.visible = false;
          } else {
              marker.draw(px);
              if (!marker.drawn) {
                  this.addChild(marker);
                  marker.drawn = true;
              }
          }
      }

      public function bringToFront(marker:Marker):void {
        this.setChildIndex(marker, this.numChildren-1);
      }

      /**
       * Calculates the max extent which includes all of the markers.
       *
       * @return bounds
       */
      public function getDataExtent():Bounds {
        var maxExtent:Bounds = null;

          if ( this.markers && (this.markers.length > 0)) {
              maxExtent = new Bounds();
              for(var i:int=0; i < this.markers.length; i++) {
                  var marker:Marker = this.markers[i];
                  maxExtent.extendFromLonLat(marker.lonlat);
              }
          }

          return maxExtent;
      }

      override public function calculateInRange():Boolean {
        return true;
      }

      //Getters and Setters
      public function get markers():Array {
        return this._markers;
      }

    public function set markers(value:Array):void {
        this._markers = value;
      }

      public function get drawn():Boolean {
        return this._drawn;
      }

    public function set drawn(value:Boolean):void {
        this._drawn = value;
      }
  }
}