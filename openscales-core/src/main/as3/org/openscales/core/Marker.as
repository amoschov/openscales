package org.openscales.core
{
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.Button;
	import org.openscales.core.event.Events;
	
	public class Marker extends Icon
	{

	    public var lonlat:LonLat = null;

	    public var events:Events = null;
	    
	    public var map:Object = null;
	    
	    public var drawn:Boolean = false;
	    
	    public var data:Object = null;
	    
	  	[Embed(source="/org/openscales/core/img/marker.png")]
        private var _markerImg:Class;
	    
	    public function Marker(url:String = null, size:Size = null, offset:Pixel = null, calculateOffset:Function = null):void {
	    	super(url, size, offset, calculateOffset);
	    	this.lonlat = lonlat;
	        
	        this.events = new Events(this, this, null);
	        
	        this.data = new Object();
	    }
	    
	    override public function destroy():void {
	    	super.destroy();
	    	this.map = null;
	
	        this.events.destroy();
	        this.events = null;
	        
	    }
	    
	  	    
	    override public function set position(px:Pixel):void {
	        super.position = px;        
	        this.lonlat = this.map.getLonLatFromLayerPx(px);
     	}
     	
     	public function onScreen():Boolean {
	     	var onScreen:Boolean = false;
	        if (this.map) {
	            var screenBounds:Bounds = this.map.getExtent();
	            onScreen = screenBounds.containsLonLat(this.lonlat);
	        }    
	        return onScreen;
     	}
     	
     	public function inflate(inflate:Number):void {
     	
	       var newSize:Size = new Size(this.size.w * inflate, this.size.h * inflate);
	       this.setSize(newSize);

     	}
     	
     	override public function draw(px:Pixel = null):void {
 	        if(url == null) {
 	        	var markerBtn:Button = new Button("", new this._markerImg(), px, new Size(21, 25)); 	                                                                null,
 	        	this.addChild(markerBtn);
 	        }
 	        else {
 	        	super.draw(px);
 	        }
     	}
     	
	}
}