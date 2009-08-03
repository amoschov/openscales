package org.openscales.core.popup
{
  import flash.display.Sprite;
  
  import org.openscales.core.basetypes.Bounds;
  import org.openscales.core.basetypes.LonLat;
  import org.openscales.core.basetypes.Pixel;
  import org.openscales.core.basetypes.Size;

  /**
   * Anchored popup
   */
  public class Anchored extends Popup
  {
    /**
       * Relative position of the popup ("br", "tr", "tl" or "bl").
       * TODO : use an enum for that
       */
    private var _relativePosition:String = "";

    static public var BR:String = "br";
    static public var TR:String = "tr";
    static public var TL:String = "tl";
    static public var BL:String = "bl";

    private var _anchor:Sprite = null;

      public function Anchored(id:String, lonlat:LonLat, background:uint, border:Number, size:Size, contentHTML:String, anchor:Sprite, closeBox:Boolean) {
          super(id, lonlat, background, border, size, contentHTML, closeBox);

          this._anchor = anchor;
      }

      override public function draw(px:Pixel=null):void {
        if (px == null) {
              if ((this.lonlat != null) && (this.map != null)) {
                  px = this.map.getLayerPxFromLonLat(this.lonlat);
              }
          }

          this.relativePosition = this.calculateRelativePosition(px);

          super.draw(px);
      }

      public function calculateRelativePosition(px:Pixel):String {
          var lonlat:LonLat = this.map.getLonLatFromLayerPx(px);

          var extent:Bounds = this.map.extent;
          var quadrant:String = extent.determineQuadrant(lonlat);

          return Bounds.oppositeQuadrant(quadrant);
      }

      override public function set position(px:Pixel):void {
          var newPx:Pixel = this.calculateNewPx(px);
          super.position = newPx;
      }

      override public function set size(size:Size):void {
        super.size = size;

          if ((this.lonlat) && (this.map)) {
              var px:Pixel = this.map.getLayerPxFromLonLat(this.lonlat);
              this.position = px;
          }
      }

      public function calculateNewPx(px:Pixel):Pixel {
        var newPx:Pixel = px;

          var top:Boolean = (this.relativePosition == TR || this.relativePosition == TL);

          if(top){
            newPx.y += -this._anchor.height/2 - this.size.h;
          }
          else{
            newPx.y += this._anchor.height/2;
          }

          var left:Boolean = (this.relativePosition == BL || this.relativePosition == TL);

          if(left){
            newPx.x += -this._anchor.width/2 - this.size.w;
          }
          else{
            newPx.x += this._anchor.width/2;
          }

          return newPx;
      }

      public function get relativePosition():String {
          return this._relativePosition;
        }

        public function set relativePosition(value:String):void {
          this._relativePosition = value;
        }
  }
}
