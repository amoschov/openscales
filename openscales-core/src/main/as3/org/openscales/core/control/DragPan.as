package org.openscales.core.control
{
	import org.openscales.core.CanvasOL;
	import org.openscales.core.Control;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
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
    	
    	override public function draw(px:Pixel = null, toSuper:Boolean = false):CanvasOL {
    		this.handler = new Drag(this,
                            {"down": this.init, "move": this.panMap, "done": this.panMapDone});
            return null;
    	}
    	
    	public function init(xy:Pixel):void {
    		startCenter = this.map.center;
    	}
    	
    	public function panMap(xy:Pixel):void {
    		this.panned = true;
	        var deltaX:Number = this.handler.start.x - xy.x;
	        var deltaY:Number = this.handler.start.y - xy.y;
        
	        var newCenter:LonLat = new LonLat(startCenter.lon + deltaX * map.getResolution() , startCenter.lat - deltaY * map.getResolution());
	        
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