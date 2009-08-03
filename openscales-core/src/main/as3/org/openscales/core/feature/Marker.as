package org.openscales.core.feature
{
  import flash.display.Bitmap;
  
  import org.openscales.core.basetypes.LonLat;
  import org.openscales.core.basetypes.Pixel;
  import org.openscales.core.layer.Layer;

  /**
   * A Marker is an icon localized by a LonLat  
   *
   * Markers are generally added to a special layer called Markers.
   */
  public class Marker extends Feature
  {

      [Embed(source="/org/openscales/core/img/marker-blue.png")]
      private var _image:Class;
      
      private var _drawn:Boolean = false;
      

      /**
      * Marker constructor
      *
      */
      public function Marker(layer:Layer = null, lonlat:LonLat = null, data:Object=null) {
        super(layer, lonlat, data);
      }

       /**
        * Draw the marker
        *
        * @param px
        */
       override public function draw():void {
	        if (!this._drawn) {
	        	super.draw();
	        	var marker:Bitmap = new this._image();
	        	var px:Pixel = this.layer.map.getLayerPxFromLonLat(this.lonlat);
	        	marker.x = px.x - marker.width/2;
	        	marker.y = px.y - marker.height/2;
                this.addChild(marker);
				this._drawn = true;
			}
       }
       
       public function get image():Class {
		return this._image;
	   }

	    public function set image(value:Class):void {
	      this._image = value;
	    }
       
       
  }
}