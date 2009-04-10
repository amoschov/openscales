package org.openscales.core
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.popup.Popup;
	
	public class Marker extends Icon
	{

	    public var lonlat:LonLat = null;
	    
	    public var map:Map = null;
	    
	    public var drawn:Boolean = false;
	    
	    public var data:Object = null;
	    
	    public var popup:Popup;
	    
	  	[Embed(source="/org/openscales/core/img/marker.png")]
        private var _markerImg:Class;
	    
	    public function Marker(url:String = null, size:Size = null, offset:Pixel = null, calculateOffset:Function = null):void {
	    	super(url, size, offset, calculateOffset);
	    	this.lonlat = lonlat;
	        
	        this.data = new Object();
	               
	    }
	    
	    override public function destroy():void {
	    	super.destroy();
	    	this.map = null;	        
	    }
	    
	  	    
	    override public function set position(px:Pixel):void {
	        super.position = px;        
	        if ( this.map )
	        {      
	        	this.lonlat = this.map.getLonLatFromLayerPx(px);
	        }
     	}
     	
     	public function onScreen():Boolean {
	     	var onScreen:Boolean = false;
	        if (this.map) {
	            var screenBounds:Bounds = this.map.extent;
	            onScreen = screenBounds.containsLonLat(this.lonlat);
	        }    
	        return onScreen;
     	}
     	
     	public function inflate(inflate:Number):void {
     	
	       var newSize:Size = new Size(this.size.w * inflate, this.size.h * inflate);
	       this.setSize(newSize);

     	}
     	
     	override public function draw(px:Pixel = null):void {
 	        
 	        trace("Marker lonlat : " + lonlat.lon + ", " + lonlat.lat);
 	        trace("Marker pixel : " + px.x + ", " + px.y);
 	        
 	        if(url == null) {
 	        	var defaultMarker:Bitmap = new this._markerImg();
 	        	defaultMarker.x = px.x;
 	        	defaultMarker.y = px.y;
 	        	if(this.numChildren==1) {
 	        		this.removeChildAt(0);
 	        	}
 	        	this.addChild(defaultMarker);
 	        }
 	        else {
 	        	super.draw(px);
 	        }
     	}    	
	}
}