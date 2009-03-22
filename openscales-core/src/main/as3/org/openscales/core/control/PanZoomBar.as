package org.openscales.core.control
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.openscales.core.CanvasOL;
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.event.Events;
	import org.openscales.core.event.OpenScalesEvent;
	
	public class PanZoomBar extends PanZoom
	{
		
	    public var zoomStopWidth:Number = 18;

	    public var zoomStopHeight:Number = 11;

	    public var slider:DisplayObject = null;

	    public var sliderEvents:Events = null;

	    public var zoomBar:DisplayObject = null;

	    public var canvasEvents:Events = null;
	    
	    public var startTop:Number = NaN;
	    
	    public var mouseDragStart:Pixel = null;
	    
	    public var zoomStart:Pixel = null;
	    
	    public function PanZoomBar(options:Object = null):void {
	    	super(options);
	    }
	    
	    override public function destroy():void {
	    	this.removeChild(this.slider);
	        this.slider = null;
	
	        this.sliderEvents.destroy();
	        this.sliderEvents = null;
	        
	        this.removeChild(this.zoomBar);
	        this.zoomBar = null;
		
	        this.map.events.unregister("zoomend", this, this.moveZoomBar);
	        this.map.events.unregister("changebaselayer", this, this.redraw)
	
	        super.destroy();
	    }
	    
	    override public function setMap(map:Map):void {
	    	super.setMap(map);
	    	this.map.events.register("changebaselayer", this, this.redraw);
	    }
	    
	    public function redraw(obt:Object = null):void {
	    	if (this != null) {
	    		while (numChildren > 0) {
	    			var child:DisplayObject = removeChildAt(0);
	    		}
	    	}
	    	this.draw();
	    }
	    
	    override public function draw(toSuper:Boolean = true):void {
	        super.draw(toSuper);

	        this.buttons = [];
			var px:Pixel = this.position;
	        var sz:Size = new Size(18,18);
			
	        var centered:Pixel = new Pixel(this.x+sz.w/2, this.y);
			
	        this._addButton("panup", new northMiniImg(), centered, sz, "Pan Up");
	        px.y = centered.y+sz.h;
	        this._addButton("panleft", new westMiniImg(), px, sz, "Pan Left");
	        this._addButton("panright", new eastMiniImg(), px.add(sz.w, 0), sz, "Pan Right");
	        this._addButton("pandown", new southMiniImg(), centered.add(0, sz.h*2), sz, "Pan Down");
	        this._addButton("zoomin", new zoomPlusMiniImg(), centered.add(0, sz.h*3+5), sz, "Zoom In");
	        centered = this._addZoomBar(centered.add(0, sz.h*4 + 5));
	        this._addButton("zoomout", new zoomMinusMiniImg(), centered, sz, "Zoom Out");
	        
	    }
	    
	    public function _addZoomBar(centered:Pixel):Pixel {
        
	        var zoomsToEnd:int = this.map.getNumZoomLevels() - 1 - this.map.zoom;
	        this.slider = new sliderImg();
	        this.slider.x = centered.x - 1;
	        this.slider.y = centered.y + zoomsToEnd * this.zoomStopHeight;
	       
	        
	        new OpenScalesEvent().observe(slider, MouseEvent.MOUSE_DOWN, this.zoomBarDown, true);
	        new OpenScalesEvent().observe(slider, MouseEvent.MOUSE_MOVE, this.zoomBarDrag, true);
	        new OpenScalesEvent().observe(slider, MouseEvent.MOUSE_UP, this.zoomBarUp, true);
	        new OpenScalesEvent().observe(slider, MouseEvent.MOUSE_OUT, this.zoomBarUp, true);
	        new OpenScalesEvent().observe(slider, MouseEvent.DOUBLE_CLICK, this.doubleClick, true);
	        new OpenScalesEvent().observe(slider, MouseEvent.CLICK, this.doubleClick, true);
	        
	        this.zoomBar = new zoombarImg();
	        zoomBar.x = centered.x;
	        zoomBar.y = centered.y
	        zoomBar.width = this.zoomStopWidth;
	        zoomBar.height = this.zoomStopHeight * this.map.getNumZoomLevels();
	        
	        new OpenScalesEvent().observe(this, MouseEvent.MOUSE_DOWN, this.controlClick, true);
	        new OpenScalesEvent().observe(this, MouseEvent.DOUBLE_CLICK, this.doubleClick, true);
	        new OpenScalesEvent().observe(this, MouseEvent.CLICK, this.doubleClick, true);
	        
	        this.addChild(this.zoomBar);
	
	        this.startTop = int(this.zoomBar.y);
	        this.addChild(slider);
	
	        this.map.events.register("zoomend", this, this.moveZoomBar);
	
	        centered = centered.add(0, 
	            this.zoomStopHeight * this.map.getNumZoomLevels());
	        return centered; 
	    }
	    
	    public function passEventToSlider(evt:MouseEvent):void {
	    	//this.sliderEvents.handleBrowserEvent(evt);
	    }
	    
	    public function controlClick(evt:MouseEvent):void {
	    	if (!OpenScalesEvent.isLeftClick(evt)) return;
	        var y:Number = evt.stageY;
	        var top:Number = Util.pagePosition(evt.currentTarget)[1];
	        var levels:Number = Math.floor((y - top)/this.zoomStopHeight);
	        this.map.zoomTo((this.map.getNumZoomLevels() -1) -  levels);
	        OpenScalesEvent.stop(evt);
	    }
	    
	    public function zoomBarDown(evt:MouseEvent):void {
	    	if (!OpenScalesEvent.isLeftClick(evt)) return;
	        this.map.events.register(MouseEvent.MOUSE_MOVE, this, this.passEventToSlider);
	        this.map.events.register(MouseEvent.MOUSE_UP, this, this.passEventToSlider);
	        this.map.events.register(MouseEvent.MOUSE_OUT, this, this.passEventToSlider);
	        this.mouseDragStart = new Pixel(evt.stageX, evt.stageY);
	        this.zoomStart = new Pixel(evt.stageX, evt.stageY);
	        this.useHandCursor = true;
	        
	        /* this.zoomBar.offsets = null; */ 
	        OpenScalesEvent.stop(evt);
	    }
	    
	    public function zoomBarDrag(evt:MouseEvent):void {
	    	if (this.mouseDragStart != null) {
	            var deltaY:Number = this.mouseDragStart.y - evt.stageY;
	            var offsets:Array = Util.pagePosition(this.zoomBar);
	            if ((evt.stageY - offsets[1]) > 0 && 
	                (evt.stageY - offsets[1]) < int(this.zoomBar.height) - 2) {
	                var newTop:Number = int(this.slider.y) - deltaY;
	                this.slider.y = newTop;
	            }
	            this.mouseDragStart = new Pixel(evt.stageX, evt.stageY);
	            OpenScalesEvent.stop(evt);
	        }
	    }
	    
	    public function zoomBarUp(evt:MouseEvent):void {
	    	if (!OpenScalesEvent.isLeftClick(evt)) return;
	        if (this.zoomStart) {
	            this.useHandCursor = false;
	            this.map.events.unregister(MouseEvent.MOUSE_UP, this, this.passEventToSlider);
	            this.map.events.unregister(MouseEvent.MOUSE_OUT, this, this.passEventToSlider);
	            this.map.events.unregister(MouseEvent.MOUSE_MOVE, this, this.passEventToSlider);
	            var deltaY:Number = this.zoomStart.y - evt.stageY;
	            this.map.zoomTo(this.map.zoom + Math.round(deltaY/this.zoomStopHeight));
	            this.moveZoomBar();
	            this.mouseDragStart = null;
	            OpenScalesEvent.stop(evt);
	        }
	    }
	    
	    public function moveZoomBar(evt:MouseEvent = null):void {
		   	var newTop:Number = 
	            ((this.map.getNumZoomLevels()-1) - this.map.zoom) * 
	            this.zoomStopHeight + this.startTop + 1;
	        this.slider.y = newTop;
	    }
	    
	}
}