package org.openscales.core
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.openscales.commons.Util;
	import org.openscales.commons.basetypes.Pixel;
	import org.openscales.commons.basetypes.Size;
	
	public class Icon extends Sprite
	{
	    public var url:String = null;
	    
	    public var size:Size = null;

	    public var offset:Pixel = null;    

	    public var calculateOffset:Function = null;    
	    
	    private var _iconLoader:Loader = null;
	    
	    public function Icon(url:String, size:Size = null, offset:Pixel = null, calculateOffset:Function = null):void {	
	        this.url = url;
	        this.size = (size) ? size : new Size(20,20);
	        this.offset = offset ? offset : new Pixel(-(this.size.w/2), -(this.size.h/2));
	        this.calculateOffset = calculateOffset;
	
	        var id:String = Util.createUniqueID("FL_Icon_");
	        this.doubleClickEnabled = true;
	    }
	    
	    public function destroy():void {
		   	
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
     	
     	public function draw(px:Pixel = null):void {
 	        _iconLoader.load(new URLRequest(this.url));
	        _iconLoader.name=this.url;
	        _iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIconLoadEnd, false, 0, true);
			_iconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIconLoadError, false, 0, true);
			
	        this.position = px;
     	}
     	
     	public function onIconLoadEnd(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var loader:Loader = loaderInfo.loader as Loader;
			this.addChild(loader);
		}
		
		private function onIconLoadError(event:IOErrorEvent):void
		{
			trace("Error when loading icon " + this.url);

		}
     	
     	public function set position(px:Pixel):void {
			if (px != null) {
	            this.x = px.x;
	            this.y = px.y;
	        }
	        
	        if (this.calculateOffset != null) {
                this.offset = this.calculateOffset(this.size);  
            }
            var offsetPx:Pixel = this.position.offset(this.offset);
            this.x = offsetPx.x;
	        this.y = offsetPx.y;
                	        
		}
		
		public function get position():Pixel {
			return new Pixel(this.x, this.y);
		}
     	
     	
	}
}