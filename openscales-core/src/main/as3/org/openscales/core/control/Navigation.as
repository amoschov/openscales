package org.openscales.core.control
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Control;
	import org.openscales.core.Handler;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.handler.Click;
	import org.openscales.core.handler.MouseWheel;

	public class Navigation extends Control
	{
		
		public var dragPan:DragPan = null;

    	//public var zoomBox:ZoomBox = null;

    	public var wheelHandler:MouseWheel = null;
    	
    	public var clickHandler:Handler = null;

    	public function Navigation(options:Object = null):void {
        	super(options);
    	}
    	
    	override public function destroy():void {
    		super.destroy();
    		this.deactivate();
	        this.dragPan.destroy();
	        this.wheelHandler.destroy();
	        this.clickHandler.destroy();
	        //this.zoomBox.destroy();
    	}
    	
    	override public function activate():Boolean {
    		this.dragPan.activate();
	        this.wheelHandler.activate();
	        this.clickHandler.activate();
	        //this.zoomBox.activate();
	        super.activate();
	        return true;
    	}
		
		override public function deactivate():Boolean {
			//this.zoomBox.deactivate();
	        this.dragPan.deactivate();
	        this.clickHandler.deactivate();
	        this.wheelHandler.deactivate();
	        super.deactivate();
	        return true;
		}
		
		override public function draw(toSuper:Boolean = false):void {
			this.clickHandler = new Click(this, 
	                                        { 'doubleClick': this.defaultDblClick },
	                                        {
	                                          'double': true, 
	                                          'stopDouble': true
	                                        });
	        this.dragPan = new DragPan({map: this.map});
	        //this.zoomBox = new ZoomBox(
	        //            {map: this.map, keyMask: Handler.MOD_SHIFT});
	        this.dragPan.draw();
	        //this.zoomBox.draw();
	        this.wheelHandler = new MouseWheel(
	                                    this, {"up"  : this.wheelUp,
	                                           "down": this.wheelDown} );
	        this.activate();
	        
		}
		
		public function defaultDblClick(evt:MouseEvent):void {
			var newCenter:LonLat = this.map.getLonLatFromViewPortPx( new Pixel(evt.stageX, evt.stageY) ); 
        	this.map.setCenter(newCenter, this.map.zoom + 1);
		}
		
		public function wheelChange(evt:MouseEvent, deltaZ:int):void {
			var newZoom:int = this.map.zoom + deltaZ;
	        if (!this.map.isValidZoomLevel(newZoom)) {
	            return;
	        }
	        var size:Size    = this.map.size;
	        var deltaX:Number  = size.w/2 - evt.stageX;
	        var deltaY:Number  = evt.stageY - size.h/2;
	        var newRes:Number  = this.map.baseLayer.resolutions[newZoom];
	        var zoomPoint:LonLat = this.map.getLonLatFromPixel(new Pixel(evt.stageX, evt.stageY));
	        var newCenter:LonLat = new LonLat(
	                            zoomPoint.lon + deltaX * newRes,
	                            zoomPoint.lat + deltaY * newRes );
	        this.map.setCenter( newCenter, newZoom );
		}
		
		public function wheelUp(evt:MouseEvent):void {
			this.wheelChange(evt, 1);
		}
		
		public function wheelDown(evt:MouseEvent):void {
			this.wheelChange(evt, -1);
		}
		
	}
}