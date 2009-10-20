package org.openscales.fx.layer
{
  import mx.core.Container;
  
  import org.openscales.core.Map;
  import org.openscales.core.basetypes.Bounds;
  import org.openscales.core.layer.Layer;
  import org.openscales.fx.FxMap;

  public class FxLayer extends Container
  {
    protected var _layer:Layer;

    protected var _fxmap:FxMap;

    public function FxLayer()
    {
      this.init();
      super();
    }

    public function init():void {

		maxZoomLevel = 0; // set default value for backwards compatibility
    }

    public function get layer():Layer {
      return this._layer;
    }

    public function getInstance():Layer {
      return this.layer;
    }

    public function get fxmap():FxMap {
      return this._fxmap;
    }

    public function set fxmap(value:FxMap):void {
      this._fxmap = value;
    }

    public function get map():Map {
      if (this.layer != null)
        return this.layer.map;
      else
        return null;
    }

      public override function set name(value:String):void {
        if(this.layer != null)
          this.layer.name = value;
      }

      public function set isBaseLayer(value:Boolean):void {
        if(this.layer != null)
          this.layer.isBaseLayer = value;
      }

      public function set isFixed(value:Boolean):void {
        if(this.layer != null)
          this.layer.isFixed = value;
      }
      
      public function set minZoomLevel(value:Number):void {
        if(this.layer != null)
          this.layer.minZoomLevel = value;
      }
      
      public function set maxZoomLevel(value:Number):void {
        if(this.layer != null)
          this.layer.maxZoomLevel = value;
      }

      public function set minResolution(value:Number):void {
        if(this.layer != null)
          this.layer.minResolution = value;
      }

      public function set maxResolution(value:Number):void {
        if(this.layer != null)
          this.layer.maxResolution = value;
      }

      public function set numZoomLevels(value:Number):void {
        if(this.layer != null)
          this.layer.numZoomLevels = value;
      }

      public function set maxExtent(value:String):void {
        if(this.layer != null)
          this.layer.maxExtent = Bounds.getBoundsFromString(value);
      }
      
      public function set proxy(value:String):void {
      	if(this.layer != null)
      		this.layer.proxy = value;
      }

      override public function set visible(value:Boolean):void {
        if(this.layer != null)
          this.layer.visible = value;
      }
	  
	  public function set resolutions(value:String):void {
		 this.layer.resolutions = value.split(",");
	  }

  }
}