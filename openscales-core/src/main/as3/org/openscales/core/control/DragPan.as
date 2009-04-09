package org.openscales.core.control
{
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.handler.Drag;

	public class DragPan extends Control
	{
		
		public var ctype:int = Control.TYPE_TOOL;

    	public var panned:Boolean = false;
    	
    	public var done:Boolean = false;
    	
    	public var move:Boolean = false;
    	
    	private var startCenter:LonLat = null;
    	
    	public function DragPan(options:Object = null):void {
    		super(options);
    	}
    	
    	override public function draw():void {
    		var drag:Drag = new Drag(this);
    		drag.down = this.init;
    		drag.move = this.panMap;
    		drag.done = this.panMapDone;
    		 
    		this.handler = drag;
    	}
    	
    	public function init(xy:Pixel):void {
    		startCenter = this.map.center;
    	}
    	
    	public function panMap(xy:Pixel):void {
    		this.panned = true;
	        var deltaX:Number = this.handler.start.x - xy.x;
	        var deltaY:Number = this.handler.start.y - xy.y;
        
	        var newCenter:LonLat = new LonLat(startCenter.lon + deltaX * map.resolution , startCenter.lat - deltaY * map.resolution);
	        
	        this.map.setCenter(newCenter, NaN, this.handler.dragging);

    	}
    	
    	public function panMapDone(xy:Pixel):void {
    		if(this.panned) {
	            this.panMap(xy);
	            this.panned = false;
	        }
    	}
    	
	}
}