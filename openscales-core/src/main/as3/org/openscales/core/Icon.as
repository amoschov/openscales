package org.openscales.core
{
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.event.OpenScalesEvent;
	
	public class Icon
	{
	    public var url:String = null;
	    
	    public var size:Size = null;

	    public var offset:Pixel = null;    

	    public var calculateOffset:Function = null;    
	    
	    public var imageCanvas:CanvasOL = null;
	
	    public var px:Pixel = null;
	    
	    public var marker:Marker = null;
	    
	    public function Icon(url:String, size:Size = null, offset:Pixel = null, calculateOffset:Function = null):void {	
	        this.url = url;
	        this.size = (size) ? size : new Size(20,20);
	        this.offset = offset ? offset : new Pixel(-(this.size.w/2), -(this.size.h/2));
	        this.calculateOffset = calculateOffset;
	
	        var id:String = Util.createUniqueID("FL_Icon_");
	        this.imageCanvas = Util.createAlphaImageCanvas(id);
	        this.imageCanvas.doubleClickEnabled = true;
	        this.imageCanvas.flIcon = this;
	    }
	    
	    public function destroy():void {
		   	OpenScalesEvent.stopObservingElement("click", this.imageCanvas);
	        this.imageCanvas = null;
	    }
	    
	    public function clone():Icon {
        	return new Icon(this.url, 
                                   this.size, 
                                   this.offset, 
                                   this.calculateOffset);
     	}
     	
     	public function setSize(size:Size):void {
	        if (size != null) {
	            this.size = size;
	        }
	        this.draw();
     	}
     	
     	public function setUrl(url:String):void {
     		if (url != null) {
     			 this.url = url;
     		}
     		this.draw();	
     	}
     	
     	public function draw(px:Pixel = null):CanvasOL {
 	        Util.modifyAlphaImageCanvas(this.imageCanvas, 
                                    null, 
                                    null, 
                                    this.size, 
                                    this.url, 
                                    "absolute");
	        this.moveTo(px);
	        return this.imageCanvas;
     	}
     	
     	public function setOpacity(opacity:Number):void {
 		     Util.modifyAlphaImageCanvas(this.imageCanvas, null, null, null, 
                                   	null, null, null, null, opacity);
     	}
     	
     	public function moveTo(px:Pixel):void {
     		if (px != null) {
	            this.px = px;
	        }
	
	        if (this.imageCanvas != null) {
	            if (this.px == null) {
	                this.display(false);
	            } else {
	                if (this.calculateOffset != null) {
	                    this.offset = this.calculateOffset(this.size);  
	                }
	                var offsetPx:Pixel = this.px.offset(this.offset);
	                Util.modifyAlphaImageCanvas(this.imageCanvas, null, offsetPx);
	            }
	        }
     	}
     	
     	public function display(display:Boolean):void {
     		this.imageCanvas.visible = (display) ? true : false;
     	}
     	
	}
}