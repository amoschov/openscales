package org.openscales.core.layer
{
	import org.openscales.core.Trace;
	import org.openscales.core.format.KMLFormat;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.request.XMLRequest;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	

	public class KML extends VectorLayer
	{
    
	    private var _url:String = "";
		private var _request:XMLRequest = null;
		private var _kmlFormat:KMLFormat = null;
		private var _xml:XML = null;
		
	    public function KML(name:String, url:String, bounds:Bounds, isBaseLayer:Boolean = false, visible:Boolean = true, 
								   projection:String = null, proxy:String = null) {
	        this._url = url;
	        this.maxExtent = bounds;
	        this._kmlFormat = new KMLFormat();
						
	        super(name,isBaseLayer,visible,projection,proxy);
			
	    }
	
	     override public function destroy(setNewBaseLayer:Boolean = true):void {
	        if (this._request) {
	            this._request.destroy();
	            this._request = null;
	        }
	        super.destroy(setNewBaseLayer);
	    } 
	   
	    /** 
	     * Method: moveTo
	     * Create the tile for the image or resize it for the new resolution
	     * 
	     * Parameters:
	     * bounds - {<OpenLayers.Bounds>}
	     * zoomChanged - {Boolean}
	     * dragging - {Boolean}
	     */
	    override public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean = false,resizing:Boolean=false):void {
	        super.moveTo(bounds,zoomChanged,dragging,resizing);
			
	        if((!this._request)) {
				this._request = _request = new XMLRequest(url, onSuccess, this.proxy, URLRequestMethod.GET, this.security,onFailure);
			} else if(this._xml) {
				this.updateKML();
			}
			
		}
		
		private function updateKML():void  {
			this.clear();
			
			if (this.map.baseLayer.projection != null && this.projection != null && this.projection.srsCode != this.map.baseLayer.projection.srsCode) {
				this._kmlFormat.externalProj = this.projection;
				this._kmlFormat.internalProj = this.map.baseLayer.projection;
			}
			
			var features:Array = this._kmlFormat.read(this._xml) as Array;
			this.addFeatures(features);
			
		}
		
		public function onSuccess(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			this.loading = false;
			
			// To avoid errors in case of the WFS server is dead
			try {
				//startTime = new Date();
				this._xml =  new XML(loader.data);
				//endTime = new Date();
				//Trace.debug("XML object creation : " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds");
				this.updateKML();
			}
			catch(error:Error) {
				Trace.error(error.message);
			}
			
		}
		
		protected function onFailure(event:Event):void {
			this.loading = false;
			Trace.error("Error when loading kml " + this._url);			
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
		
		override public function clear():void {
			while (this.numChildren > 0) {
				this.removeChildAt(this.numChildren-1);
			}
		}
	}
}