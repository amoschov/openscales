package org.openscales.core.control
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.handler.Click;
	import org.openscales.core.handler.MouseWheel;

	public class Navigation extends Control
	{
		
		public var dragPan:DragPan = null;

    	public var wheelHandler:MouseWheel = null;
    	
    	public var clickHandler:Click = null;

    	public function Navigation(options:Object = null):void {
        	super(options);
    	}
    	
    	override public function destroy():void {
    		super.destroy();
    		this.deactivate();
	        this.dragPan.destroy();
	        this.wheelHandler.destroy();
	        this.clickHandler.destroy();
    	}
    	
    	override public function activate():Boolean {
    		this.dragPan.activate();
	        this.wheelHandler.activate();
	        this.clickHandler.activate();
	        super.activate();
	        return true;
    	}
		
		override public function deactivate():Boolean {
	        this.dragPan.deactivate();
	        this.clickHandler.deactivate();
	        this.wheelHandler.deactivate();
	        super.deactivate();
	        return true;
		}
		
		override public function draw():void {

	        this.dragPan = new DragPan({map: this.map});
	        this.dragPan.draw();
	        
			this.clickHandler = new Click(this);
			//this.clickHandler.click = this.defaultDblClick;
			this.clickHandler.doubleClick = this.defaultDblClick;
	       
	        this.wheelHandler = new MouseWheel(this);
	        this.wheelHandler.up = this.wheelUp;
	        this.wheelHandler.down = this.wheelDown;

	        this.activate();
	        
		}
				
		public function defaultDblClick(evt:MouseEvent):void {
			var newCenter:LonLat = this.map.getLonLatFromViewPortPx( new Pixel(map.mouseX, map.mouseY) ); 
        	this.map.setCenter(newCenter, this.map.zoom + 1);
		}
		
		public function wheelChange(evt:MouseEvent, deltaZ:int):void {
			var newZoom:int = this.map.zoom + deltaZ;
	        if (!this.map.isValidZoomLevel(newZoom)) {
	            return;
	        }
	        var size:Size    = this.map.size;
	        var deltaX:Number  = size.w/2 - map.mouseX;
	        var deltaY:Number  = size.h/2 - map.mouseY;
	        var newRes:Number  = this.map.baseLayer.resolutions[newZoom];
	        var zoomPoint:LonLat = this.map.getLonLatFromPixel(new Pixel(map.mouseX, map.mouseY));
	        var newCenter:LonLat = new LonLat(
	                            zoomPoint.lon + deltaX * newRes,
	                            zoomPoint.lat - deltaY * newRes );
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