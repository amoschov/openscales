package org.openscales.fx.layer
{
  import flash.display.DisplayObject;
  
  import org.openscales.core.feature.Style;
  import org.openscales.core.layer.Layer;
  import org.openscales.core.layer.ogc.WFS;
  import org.openscales.core.layer.params.ogc.WFSParams;
  import org.openscales.fx.feature.FxStyle;
  import org.openscales.proj4as.ProjProjection;

  public class FxWFS extends FxLayer
  {
    private var _url:String;

    private var _params:WFSParams;

    private var _style:Style;

    private var _minZoomLevel:Number;

    private var _isBaseLayer:Boolean;

    private var _projection:String;

    private var _useCapabilities:Boolean = false;
    
    private var _capabilitiesVersion:String = "1.1.0";


    public function FxWFS()
    {
      this._params = new WFSParams("");
      this._isBaseLayer = false;
            super();
    }

    override public function init():void {
            this._layer = new WFS("", "", this._params, this._isBaseLayer, true, this._projection,null,_useCapabilities);
    }

    override protected function createChildren():void
    {
      super.createChildren();

      for(var i:int=0; i < this.rawChildren.numChildren ; i++) {
        var child:DisplayObject = this.rawChildren.getChildAt(i);
        if(child is FxStyle) {
          this._style = (child as FxStyle).style;
        }
      }
    }

    override public function get layer():Layer {
      if (this._style != null)
          (this._layer as WFS).style = this._style;

      if (this._projection != null)
          (this._layer as WFS).projection = new ProjProjection(this._projection);

      (this._layer as WFS).url = this._url;
      (this._layer as WFS).params = this._params;
      (this._layer as WFS).useCapabilities = this._useCapabilities;
      (this._layer as WFS).capabilitiesVersion = this._capabilitiesVersion;

      return this._layer;
    }

    public function set url(value:String):void {
        this._url = value;
      }

      public function set params(value:WFSParams):void {
        this._params = value;
      }

    public function set typename(value:String):void {
        this._params.typename = value;
      }

      public function set srs(value:String):void {
        if (value != null) {
          this._params.srs = value;
          this._projection = value;
        }
      }

      public function set version(value:String):void {
        this._params.version = value;
      }

      public function set useCapabilities(value:Boolean):void {
        this._useCapabilities = value;
      }
      
      public function set capabilitiesVersion(value:String):void {
        this._capabilitiesVersion = value;
      }
      
      public function get capabilitiesVersion():String {
        return this.capabilitiesVersion;
      }

  }
}