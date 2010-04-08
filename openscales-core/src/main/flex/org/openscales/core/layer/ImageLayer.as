package org.openscales.core.layer
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.request.DataRequest;
	

	public class ImageLayer extends Layer
	{
    
	    private var _url:String = "";
		private var _request:DataRequest = null;
		private var _size:Size = null;
		
	    public function ImageLayer(name:String,
	    						  url:String,
	    						  bounds:Bounds) {
	        this._url = url;
	        this.maxExtent = bounds;
						
	        super(name);
	        this.isBaseLayer = true;
			
	    }
	
	     override public function destroy(setNewBaseLayer:Boolean = true):void {
	        if (this._request) {
	            this._request.destroy();
	            this._request = null;
	        }
	        super.destroy(setNewBaseLayer);
	    } 
	   
	    override public function set map(value:Map):void {
	         if(value !=null)
	         {
	         	super.map = value;
	         }
	    } 
	
	    override public function redraw(fullRedraw:Boolean = true):void {
			
			if (!displayed) {
				this.clear();
				return;
			}
			
	        if (! this._request) {
				this._request = new DataRequest(this._url, onTileLoadEnd, onTileLoadError);
				this._request.proxy = this.proxy;
				this._request.security = this.security;
				this._request.send();
			} else {
				this.clear();
				this.draw();
			}
			
		}
		
		override protected function draw():void  {
			if(numChildren != 0) {
				var image:DisplayObject = this.getChildAt(0);
				image.width = this.maxExtent.width/this.map.resolution;
				image.height = this.maxExtent.height/this.map.resolution;
				var ul:LonLat = new LonLat(this.maxExtent.left, this.maxExtent.top);
				var ulPx:Pixel = this.map.getLayerPxFromLonLat(ul);
				image.x = ulPx.x;
				image.y = ulPx.y;
			}
		}
		
		public function onTileLoadEnd(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var loader:Loader = loaderInfo.loader as Loader;
			
			// Store image size
			this._size = new Size(loader.width, loader.height);
			this.addChild(loader);
			this.draw();
		} 
		
		public function onTileLoadError(event:IOErrorEvent):void
		{
			Trace.error("Error when loading image layer " + this._url);
		}
		
		public function get url():String {
			return this._url;
		}
		
		public function set url(value:String):void {
			this._url = value;
		}
		
		override public function getURL(bounds:Bounds):String {
			return this._url;
		}
	}
}