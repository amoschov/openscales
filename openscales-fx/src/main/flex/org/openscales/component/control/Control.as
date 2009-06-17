package org.openscales.component.control
{
  import flash.events.Event;
  
  import mx.containers.Canvas;
  import mx.events.FlexEvent;
  
  import org.openscales.core.Map;
  import org.openscales.core.basetypes.Pixel;
  import org.openscales.core.control.IControl;
  import org.openscales.fx.FxMap;

  public class Control extends Canvas implements IControl
  {
    protected var _map:Map = null;
    protected var _fxmap:FxMap = null;
    protected var _active:Boolean = false;

    public function Control()
    {
      super();

    }

    public function get fxmap():FxMap
    {
      return this._fxmap;
    }

    public function set fxmap(value:FxMap):void
    {
      this._fxmap = value;
      this.fxmap.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    private function onCreationComplete(event:Event):void {

      this.map = this._fxmap.map;
    }

    public function get map():Map
    {
      return this._map;
    }

    public function set map(value:Map):void
    {
      this._map = value;
      this.active = true;
    }

    public function get active():Boolean
    {
      return this._active;
    }

    public function set active(value:Boolean):void
    {
      this._active = value;
    }

    public function draw():void
    {
    }

    public function set position(px:Pixel):void
    {
      if (px != null) {
              this.x = px.x;
              this.y = px.y;
          }
    }

    public function get position():Pixel
    {
      return new Pixel(this.x, this.y);
    }

  }
}