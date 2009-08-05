package org.openscales.fx.popup
{
  import com.gskinner.motion.GTweeny;
  
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.utils.getQualifiedClassName;
  
  import mx.containers.TitleWindow;
  import mx.controls.Image;
  import mx.core.UIComponent;
  import mx.events.CloseEvent;
  
  import org.openscales.core.Map;
  import org.openscales.core.Util;
  import org.openscales.core.basetypes.LonLat;
  import org.openscales.core.basetypes.Pixel;
  import org.openscales.core.basetypes.Size;
  import org.openscales.core.feature.Feature;
  import org.openscales.fx.FxMap;

  public class FxPopup extends UIComponent
  {

    public static var WIDTH:Number = 300;
    public static var HEIGHT:Number = 300;

      private var _id:String = "";
      private var _lonlat:LonLat = null;
      private var _size:Size = null;
      private var _fxmap:FxMap = null;
      private var _map:Map = null;
      private var _content:UIComponent = null;
      private var _feature:Feature = null;
      private var _closeBox:Boolean;

      [Embed(source="/org/openscales/fx/img/close.gif")]
        private var _closeImg:Class;

      public function FxPopup(lonlat:LonLat, size:Size = null, content:UIComponent = null, closeBox:Boolean = true) {
          this.lonlat = lonlat;
          this.closeBox = closeBox;

          if (content is TitleWindow) {
            TitleWindow(content).showCloseButton = this.closeBox;
            TitleWindow(content).addEventListener(CloseEvent.CLOSE,closePopup);
          }

          this._content = content;
          this.addChild(this.content);

          if (size != null){
            this._size = size;
          }
          else{
            this.size = new Size(FxPopup.WIDTH,FxPopup.HEIGHT);
          }
      }

      public function closePopup(evt:Event):void {
          var target:Sprite = (evt.target as Sprite);
          target.removeEventListener(evt.type, closePopup);
            destroy();
            evt.stopPropagation();
        }

      public function destroy():void {
        while (this.numChildren>0) {
          this.removeChildAt(0);
        }
        this.content = null;
        if (this.feature != null) {
           this.feature.destroyPopup();
           this.feature = null;
          }
        if (this.fxmap != null) {
          this.fxmap.removePopup(this);
          this.fxmap = null;
        }
      }

      public function draw(px:Pixel = null):void {
        if (px == null) {
              if ((this.lonlat != null) && (this.map != null)) {
                  px = this.map.getMapPxFromLonLat(this.lonlat);
              }
          }

          this.position = px;

      this.width = this.size.w;
      this.height = this.size.h;

      if (this._content != null) {
        this._content.width = this.size.w;
        this._content.height = this.size.h;
      }

      if (!(this.content is TitleWindow)) {

              var closeImg:Image = new Image();
              closeImg.id = this.id + "_close";
              closeImg.source = this._closeImg;
              closeImg.width = 17;
              closeImg.height = 17;
              closeImg.x = this.size.w - closeImg.width - 3;
              closeImg.y = 3;

              this.addChild(closeImg);

              closeImg.addEventListener(MouseEvent.CLICK, closePopup);
         }
        this.alpha = 0;
        var tween:GTweeny = new GTweeny(this, 0.5, {alpha:1});
      }

      //Getters and Setters
    public function set position(px:Pixel):void {

      if (px != null) {
              this.x = px.x;
              this.y = px.y;
          }
    }

    public function get position():Pixel {
      return new Pixel(this.x, this.y);
    }

    public function get size():Size {
      return this._size;

    }
    public function set size(size:Size):void {
      if (size != null) {
              this._size = size;
            this.width = this.size.w;
            this.height = this.size.h;

          if (this._content != null) {
            this._content.width = this.size.w;
            this._content.height = this.size.h;
          }
          }
    }

    public function get content():UIComponent {
      return this._content;

    }
    public function set content(value:UIComponent):void {
      this._content = value;
    }

    public function get fxmap():FxMap {
      return this._fxmap;

    }
    public function set fxmap(value:FxMap):void {
      this._fxmap = value;
      if (value != null){
      this._map = value.map;
      } else{
        this._map = null
      }
    }

    public function get map():Map {
      return this._map;

    }
    public function set map(value:Map):void {
      this._map = value;
    }

    public function get lonlat():LonLat {
      return this._lonlat;
    }
    public function set lonlat(value:LonLat):void {
      this._lonlat = value;
    }

    public function get feature():Feature {
      return this._feature;
    }
    public function set feature(value:Feature):void {
      this._feature = value;
    }

    public function get closeBox():Boolean{
      return this._closeBox;
    }
    public function set closeBox(value:Boolean):void{
      this._closeBox = value;
    }
  }
}
