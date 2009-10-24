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
    
    /**
     * Store if this control have been initialized (Event.COMPLETE has been thrown)  
     */
    protected var _isInitialized:Boolean = false;

    public function Control()
    {
      super();
      /* this.addEventListener(Event.COMPLETE, onCreationComplete); */
      this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete); 
      
    }
    
    /**
     * The Flex side of the control has been created, so activate the control if needed and if the map has been set
     */
    protected function onCreationComplete(event:Event):void {
    	this._isInitialized = true;
    	
    	if((this.map) && (this.active == false)) {  
    		this.active = true;
    	}
    }    

    public function get fxmap():FxMap
    {
      return this._fxmap;
    }

    public function set fxmap(value:FxMap):void
    {
      this._fxmap = value;
      this.fxmap.addEventListener(FlexEvent.CREATION_COMPLETE, onFxMapCreationComplete);
    }

	/**
	 * Flex Map wrapper initialization
	 */
    protected function onFxMapCreationComplete(event:Event):void {
      this.map = this._fxmap.map;
    }

	[Bindable(event="propertyChange")]
    public function get map():Map
    {
      return this._map;
    }
    public function set map(value:Map):void
    {
      this._map = value;
      // Activate the control only if this control has already thrown an Event.COMPLETE
      if(this._isInitialized) {
      	this.active = true;
      }
      // Dispatch an event to allow binding for the map of this Control
      dispatchEvent(new Event("propertyChange"));
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