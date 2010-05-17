package org.openscales.core.layer
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.format.KMLFormat;
	import org.openscales.core.request.XMLRequest;

	public class KML extends FeatureLayer
	{
	    private var _url:String = "";
		private var _request:XMLRequest = null;
		private var _kmlFormat:KMLFormat = null;
		private var _xml:XML = null;

	    public function KML(name:String,
	    					url:String,
	    					bounds:Bounds) {
	        this._url = url;
	        this.maxExtent = bounds;

	        super(name);
			this._kmlFormat = new KMLFormat();
	    }

		 override public function destroy():void {
			if (this._request) {
				this._request.destroy();
				this._request = null;
			}
			this.loading = false;
			super.destroy();
		}

		override public function redraw(fullRedraw:Boolean = true):void {
			if (!displayed) {
				this.clear();
				return;
			}

			if (! this._request) {
				this.loading = true;
				this._request = new XMLRequest(url, onSuccess, onFailure);
				this._request.proxy = this.proxy;
				this._request.security = this.security;
				this._request.send();
			} else {
				this.clear();
				this.draw();
			}
		}

		public function onSuccess(event:Event):void
		{
			this.loading = false;
			var loader:URLLoader = event.target as URLLoader;

			// To avoid errors if the server is dead
			try {
				this._xml = new XML(loader.data);
				if (this.map.baseLayer.projection != null && this.projection != null && this.projection.srsCode != this.map.baseLayer.projection.srsCode) {
					this._kmlFormat.externalProj = this.projection;
					this._kmlFormat.internalProj = this.map.baseLayer.projection;
				}
				this._kmlFormat.proxy = this.proxy;
				var features:Vector.<Feature> = this._kmlFormat.read(this._xml) as Vector.<Feature>;
				this.addFeatures(features);

				this.clear();
				this.draw();
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

	}
}