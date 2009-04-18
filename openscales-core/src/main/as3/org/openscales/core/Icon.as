package org.openscales.core
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	
	public class Icon extends Sprite
	{
	    private var _url:String = null;
	    
	    private var _size:Size = null;

	    private var _offset:Pixel = null;    

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
     	
     	public function get offset():Pixel {
        	return this._offset;
        }
        
        public function set offset(value:Pixel):void {
        	this._offset = value;
        }
     	
     	public function get size():Size {
        	return this._size;
        }
     	
     	public function set size(value:Size):void {
	        if (value != null) {
	            this._size = value;
	        }
	        this.draw();
     	}
     	
     	public function get url():String {
        	return this._url;
        }
     	
     	public function set url(value:String):void {
     		if (value != null) {
     			 this._url = value;
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