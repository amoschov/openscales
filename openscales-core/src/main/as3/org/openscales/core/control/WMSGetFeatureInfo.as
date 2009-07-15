package org.openscales.core.control
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Map;
	import org.openscales.core.Request;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.GetFeatureInfoEvent;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.layer.ogc.WMS;
	import org.openscales.core.layer.params.ogc.WMSGetFeatureInfoParams;
	import org.openscales.core.layer.params.ogc.WMSParams;

	public class WMSGetFeatureInfo extends Control
	{
	
		private var _clickHandler:ClickHandler;
		private var _format:String;
		private var _maxFeatures:Number;
		private var _url:String;
		private var _layers:String;
		private var _request:Request;
    	  	
    	public function WMSGetFeatureInfo(position:Pixel = null) {
    		super(position);
			_format = "application/vnd.ogc.gml";
			_maxFeatures = 10;
		}
		
		/**
		 * Get the existing map
		 * 
		 * @param map
		 */
		override public function set map(map:Map):void {
			super.map = map;
			_clickHandler = new ClickHandler(map, true);
			_clickHandler.click = this.getInfoForClick;
		}
		
		/**
		 * Set the existing format
		 * 
		 * @param format
		 */
		public function set format(format:String):void {
			_format = format;
		}
		
		/**
		 * Set the existing maxFeatures
		 * 
		 * @param maxFeatures
		 */
		public function set maxFeatures(maxFeatures:Number):void {
			_maxFeatures = maxFeatures;
		}
		
		public function set url(url:String):void {
			_url = url;
		}
		
		public function set layers(layers:String):void {
			_layers = layers;
		}
		
		private function getInfoForClick(event:MouseEvent):void {
			// get layers and styles
			var layerNames:String = _layers;
			var layerStyles:String = null;
			var theURL:String = _url;
			if (_layers == null) {
				var layers:Array = map.layers;
				for (var i:Number = 0; i < layers.length; i++) {
					if (!layers[i].visible) continue;
					if (!(layers[i] is WMS)) continue;
					if (theURL == null) theURL = (layers[i] as WMS).url;
					if (theURL != (layers[i] as WMS).url) continue;
					var params:WMSParams = (layers[i] as WMS).params as WMSParams;
					if (layerNames == null) layerNames = "" else layerNames + ",";
					layerNames = layerNames + params.layers;
					if (layerStyles == null) layerStyles = "" else layerStyles + ",";
					if (params.styles != null) layerStyles = layerStyles + params.styles;
				}
			}
			
			// setup params for call
			var infoParams:WMSGetFeatureInfoParams = new WMSGetFeatureInfoParams(layerNames, _format, layerStyles);
			infoParams.bbox = this.map.extent.boundsToString();
            infoParams.srs = this.map.projection.srsCode;
            infoParams.maxFeatures = _maxFeatures;
            infoParams.x = event.stageX;
            infoParams.y = event.stageY;
            infoParams.height = this.map.height;
            infoParams.width = this.map.width;
			
			// request data
			if (_request != null && _request.loader != null) try { _request.loader.close(); } catch (e:Error) { }
			_request = new Request(theURL + "?" + infoParams.toGETString(), URLRequestMethod.GET, this.handleResponse, null, null, map.proxy);
		}
		
		private function handleResponse(event:Event):void {
			var loader:URLLoader = event.target as URLLoader;
			this.map.dispatchEvent(new GetFeatureInfoEvent(GetFeatureInfoEvent.GET_FEATURE_INFO_DATA, loader.data));
		}
	}
}