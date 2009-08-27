package org.openscales.fx {

  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.events.Event;
  
  import mx.core.Container;
  import mx.core.UIComponent;
  import mx.events.FlexEvent;
  import mx.events.ResizeEvent;
  
  import org.openscales.component.control.Control;
  import org.openscales.core.Map;
  import org.openscales.core.basetypes.Bounds;
  import org.openscales.core.basetypes.LonLat;
  import org.openscales.core.basetypes.Size;
  import org.openscales.core.control.IControl;
  import org.openscales.core.events.MapEvent;
  import org.openscales.core.popup.Popup;
  import org.openscales.fx.control.FxControl;
  import org.openscales.fx.handler.FxHandler;
  import org.openscales.fx.layer.FxLayer;
  import org.openscales.fx.popup.FxPopup;

  public class FxMap extends Container {

    private var _map:Map;

    private var _popupContainer:Container;

    private var _maxResolution:Number = NaN;

    private var _minResolution:Number = NaN;

    private var _numZoomLevels:Number = NaN;

    private var _maxExtent:Bounds = null;

    private var _zoom:Number = NaN;

    private var _lon:Number = NaN;

    private var _lat:Number = NaN;

    private var _creationHeight:Number = NaN;

    private var _creationWidth:Number = NaN;

    private var _proxy:String = "";

    public function FxMap() {
      super();
	
	  // Fix for issue 114: Error at startup when window is too small
	  this.clipContent = false;
	  
      this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    private function onCreationComplete(event:Event):void {

      this._map = new Map(this.width, this.height);

      this.rawChildren.addChild(this._map);

      this._popupContainer = new Container();
      this._popupContainer.width = this.width;
      this._popupContainer.height = this.height;

      this.rawChildren.addChild(this._popupContainer);

      if(this._proxy != "")
        this._map.proxy = this._proxy;

      if(!isNaN(this._maxResolution))
        this._map.maxResolution = this._maxResolution;

      if(!isNaN(this._minResolution))
        this._map.minResolution = this._minResolution;

      if(!isNaN(this._numZoomLevels))
        this._map.numZoomLevels = this._numZoomLevels;

      if(this._maxExtent != null)
        this._map.maxExtent = this._maxExtent;
        
      // Some operations must be done at the beginning, in order to do
      // not depend on declaration order
      for(var i:int=0; i < this.rawChildren.numChildren ; i++) {
        var child:DisplayObject = this.rawChildren.getChildAt(i);
        if(child is FxMaxExtent) {
          this._map.maxExtent = (child as FxMaxExtent).bounds;
        }
      }

      for(i=0; i < this.rawChildren.numChildren ; i++) {
        child = this.rawChildren.getChildAt(i);
        if(child is FxLayer) {
          (child as FxLayer).fxmap = this;
          this._map.addLayer((child as FxLayer).layer);
        } 
       // else if (child is FxSecurities){}
        else if(child is FxControl) {
          this._map.addControl((child as FxControl).control);
        } else if(child is IControl) {
          this._map.addControl(child as IControl, false);
        } else if (child is Control){
          this.parent.addChild(child);
        } else if(child is FxHandler) {
          this._map.addHandler((child as FxHandler).handler);
        } else if ((child is UIComponent) && !(child is FxMaxExtent) && !(child is FxExtent) ){
          this.parent.addChild(child);
        }
          

      }

      if(!isNaN(this._lon) && !isNaN(this._lat))
        this._map.center = new LonLat(this._lon, this._lat);


      if(!isNaN(this._creationWidth) && !isNaN(this._creationHeight))
        this._map.size = new Size(this._creationWidth, this._creationHeight);

      if(!isNaN(this._zoom))
        this._map.zoom = this._zoom;

      // Some operations must be done at the end, in order to do
      // not depend on declaration order
      for(i=0; i < this.rawChildren.numChildren ; i++) {
        child = this.rawChildren.getChildAt(i);
        if(child is FxExtent) {
          this._map.zoomToExtent((child as FxExtent).bounds);
          break;
        }
        else if(child is FxMaxExtent){
        	 this._map.zoomToExtent((child as FxMaxExtent).bounds);
        	 break;
        }
      }
	 /*  for(i=0; i < this.rawChildren.numChildren ; i++) {
         child = this.rawChildren.getChildAt(i);
 		  if(child is FxSecurities){
          	(child as FxSecurities).map=this._map;
          }
          
 		} */
      this._map.addEventListener(MapEvent.MOVE_START, this.hidePopups)
      this._map.addEventListener(MapEvent.DRAG_START, this.hidePopups)
      this._map.addEventListener(MapEvent.MOVE_END, this.showPopups)
      this.addEventListener(ResizeEvent.RESIZE, this.onResize);
    }

    private function hidePopups(event:Event):void{
      var element:Container = this._popupContainer;
      element.visible = false;
    }

    private function showPopups(event:Event):void{
       var element:Container = this._popupContainer;
      var i:Number;
      var child:DisplayObject;
      for(i=element.numChildren-1;i>=0;i--){
        child = element.getChildAt(i);
        if(child is FxPopup){
         FxPopup(child).draw();;
        }
      }
      element.visible = true; 
    }

    private function onResize(event:ResizeEvent):void {
      var o:DisplayObject = event.target as DisplayObject;
      this._map.size = new Size(o.width, o.height);
    }

    /**
    * @param {OpenLayers.Popup} popup
    * @param {Boolean} exclusive If true, closes all other popups first
    **/
    public function addPopup(popup:Sprite, exclusive:Boolean = true):void {
        this.map.addPopup(popup as Popup, exclusive);
          if(exclusive){
              var i:Number;
              var child:DisplayObject;
              for(i=this._popupContainer.numChildren-1;i>=0;i--){
                child = this.parent.getChildAt(i);
                if(child is Popup || child is FxPopup){
                 this.removePopup(child as Sprite);
                }
              }
          }
        if (popup is FxPopup){
          FxPopup(popup).fxmap = this;
          FxPopup(popup).draw();
          this._popupContainer.addChild(popup);
        }
    }

    public function removePopup(popup:Sprite):void {
        if (popup is Popup){
          this.map.removePopup(popup as Popup);
        } else if (popup is FxPopup){
          FxPopup(popup).fxmap = null;
          FxPopup(popup).destroy();
          this._popupContainer.removeChild(popup);
        }
    }

    public function get map():Map {
      return this._map;
    }

    public function set maxResolution(value:Number):void {
      this._maxResolution = value;
    }

    public function set minResolution(value:Number):void {
      this._minResolution = value;
    }

    public function set numZoomLevels(value:Number):void {
      this._numZoomLevels = value;
    }

    public function set maxExtent(value:String):void {
      this._maxExtent = Bounds.getBoundsFromString(value);
    }

    public function set zoom(value:Number):void {
      this._zoom = value;
    }

    public function set lon(value:Number):void {
      this._lon = value;
    }

    public function set lat(value:Number):void {
      this._lat = value;
    }

    override public function set width(value:Number):void {
      super.width = value;
      if(map != null)
        this._map.width = value;
      else
        this._creationWidth = value;
    }

    override public function set height(value:Number):void {
      super.height = value;
      if(map != null)
        this._map.height = value;
      else
        this._creationHeight = value;

    }

    public function set proxy(value:String):void {
      this._proxy = value;
    }

  }
}
