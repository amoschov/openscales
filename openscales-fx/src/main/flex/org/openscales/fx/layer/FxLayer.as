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
    
    protected var _maxResolution:String = null;
    
    protected var _numZoomLevels:String = null;

    protected var _fxmap:FxMap;

    public function FxLayer() {
		super();
		this.init();
	}

	public function init():void {
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
      
      public function set maxResolution(value:String):void {
          this._maxResolution = value;
      }
      
      public function get maxResolution():String {
          return this._maxResolution;
      }
      
      public function set numZoomLevels(value:String):void {
          this._numZoomLevels = value;
      }
      
      public function get numZoomLevels():String {
          return this._numZoomLevels;
      }
	  
	  public function set resolutions(value:String):void {
		 var resString:String = null;
		 var resNumberArray:Array = new Array();
		 for each (resString in value.split(",")) {
		 	resNumberArray.push(Number(resString));
		 }
		 this.layer.resolutions = resNumberArray;
	  }

  }
}