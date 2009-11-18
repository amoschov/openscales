package org.openscales.core.layer.ogc
{	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.format.Format;
	import org.openscales.core.format.GMLFormat;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.layer.capabilities.GetCapabilities;
	import org.openscales.core.layer.params.ogc.WFSParams;
	import org.openscales.core.request.XMLRequest;
	import org.openscales.proj4as.ProjProjection;

	/**
	 * Instances of WFS are used to display data from OGC Web Feature Services.
	 *
	 * @author Bouiaw
	 */
	public class WFS extends VectorLayer
	{
		
		private var _writer:Format = null;

		private var _featureNS:String = null;

		private var _geometryColumn:String = null;

		/**
		 * 	 Should the WFS layer parse attributes from the retrieved
		 *     GML? Defaults to false. If enabled, parsing is slower, but
		 *     attributes are available in the attributes property of
		 *     layer features.
		 */
		private var _extractAttributes:Boolean = true;

		/**
		 * An HashMap containing the capabilities of the layer.
		 */
		private var _capabilities:HashMap = null;

		/**
		 * Do we get capabilities ?
		 */
		private var _useCapabilities:Boolean = false;

		private var _capabilitiesVersion:String = "1.1.0";

		private var _url:String = null;

		private var _params:WFSParams = null;

		private var _request:XMLRequest = null;	
		
		private var _firstRendering:Boolean = true;

		/**
		 * WFS class constructor
		 *
		 * @param name Layer's name
		 * @param url The WFS server url to request
		 * @param params
		 * @param isBaseLayer
		 * @param visible
		 * @param projection
		 * @param proxy
		 * @param capabilities
		 * @param useCapabilities
		 */	                    
		public function WFS(name:String, url:String, typename:String, isBaseLayer:Boolean = false, visible:Boolean = true, 
			projection:String = null, proxy:String = null, useCapabilities:Boolean=false, capabilities:HashMap=null) {

			this.capabilities = capabilities;
			this.useCapabilities = useCapabilities;

			super(name, isBaseLayer, visible, projection, proxy);

			if (!(this.geometryColumn)) {
				this.geometryColumn = "the_geom";
			}    

			this.params = new WFSParams(typename);
				
			this.url = url;
			
			// Will draw features asynchronously when data have been received 
			this._drawOnMove = false;    
		}

		override public function set map(map:Map):void {
			super.map = map;

			// GetCapabilities request made here in order to have the proxy set 
			if (url != null && url != "" && this.capabilities == null && useCapabilities == true) {
				var getCap:GetCapabilities = new GetCapabilities("wfs", url, this.capabilitiesGetter,
					capabilitiesVersion, this.proxy);
			}
		}
		
		/**
		 * Override FeatureLayer function to add time logs
		 */
		/*override public function drawFeatures():void {
			var startTime:Date = new Date();
			super.drawFeatures();
			var endTime:Date = new Date();
			Trace.debug("Draw features : " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds");
		}*/

		/**
		 * Method called when we pan, drag or change zoom to move the layer.
		 *
		 * @param bounds The new bounds delimiting the layer view
		 * @param zoomChanged Zoom changed or not
		 * @param dragging Drag action or not
		 */
		override public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean = false,resizing:Boolean=false):void {
			super.moveTo(bounds, zoomChanged, dragging,resizing);
			if ((this.map.zoom < this.minZoomLevel) || (this.map.zoom > this.maxZoomLevel)) {
		 		Trace.info("Zoom "+this.map.zoom+" outside [min,max] zoom levels ["+this.minZoomLevel+","+this.maxZoomLevel+"]: don't draw layer " + this.name);
		 		this.clear();
		 		return;
	    	}
	    	
			if ( zoomChanged || !dragging  ) {
				var projectedBounds:Bounds = bounds.clone();
				
				if(this.projection.srsCode != this.map.baseLayer.projection.srsCode) {
						projectedBounds.transform(this.map.baseLayer.projection, this.projection);
				}
				var center:LonLat = projectedBounds.centerLonLat;

				if (projectedBounds.containsBounds(this.maxExtent)) {
					projectedBounds = this.maxExtent;

				}
				var previousFeatureBbox:Bounds = this.featuresBbox.clone(); 
				this.featuresBbox = projectedBounds;
				this.params.bbox = projectedBounds.boundsToString();
				
				if (this._firstRendering) {
					this.loadFeatures(this.getFullRequestString());
					this._firstRendering = false;
				} else {
					// else reuse the existing one
					if ( previousFeatureBbox.containsBounds(projectedBounds)) {
						this.drawFeatures();
					} else {
						// Use GetCapabilities to know if all features have already been retreived.
						// If they are, we don't request data again
						if ((this.capabilities == null) || (this.capabilities != null && !this.featuresBbox.containsBounds(this.capabilities.getValue("Extent")))) {
							this.loadFeatures(this.getFullRequestString());
						} else {
							this.drawFeatures();
						}
					}
				}
			}	
		}

		/**
		 * Override FeatureLayer destroy function. Be sure loading is set to false.
		 */
		override public function destroy(setNewBaseLayer:Boolean=true):void	{
			this.loading = false;
			super.destroy();
		}
		 
		/**
		 * Combine the layer's url with its params and these newParams.
		 *
		 * @param newParams
		 * @param altUrl Use this as the url instead of the layer's url
		 */
		public function getFullRequestString(altUrl:String = null):String {

			var url:String;

			if (altUrl != null)
				url = altUrl;
			else
				url = this.url;

			var requestString:String = url;

			var projection:ProjProjection = this.projection;
			if (projection != null || this.map.baseLayer.projection != null)
				this.params.srs = (projection == null) ? this.map.baseLayer.projection.srsCode : projection.srsCode;


			var lastServerChar:String = url.charAt(url.length - 1);
			if ((lastServerChar == "&") || (lastServerChar == "?")) {
				requestString += this.params.toGETString();
			} 
			else {
				if (url.indexOf('?') == -1) {
					requestString += '?' + this.params.toGETString();
				} 
				else {
					requestString += '&' + this.params.toGETString();
				}
			}


			return requestString;
		}

		public function set typename(value:String):void {
			this.params.typename = value;
		}

		public function get typename():String {
			return this.params.typename;
		}

		public function get capabilities():HashMap {
			return this._capabilities;
		}

		public function set capabilities(value:HashMap):void {
			this._capabilities = value;
		}

		/**
		 * TODO: Refactor this to use events
		 *
		 * Callback method called by the capabilities retriever.
		 *
		 * @param caller The GetCapabilities instance which call it.
		 */
		public function capabilitiesGetter(caller:GetCapabilities):void {
			if (this.params != null) {
				this._capabilities = caller.getLayerCapabilities(this.params.typename);

			}
			if ((this._capabilities != null) && (this.projection == null)) {
				this.projection = new ProjProjection(this._capabilities.getValue("SRS"));
			}
		}
		
		/**
		 * Abort any pending requests and issue another request for data.
		 *
		 * Input are function pointers for what to do on success and failure.
		 *
		 * @param success
		 * @param failure
		 */
		protected function loadFeatures(url:String):void {		
			if(map)
                this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_LOAD_START, this ));
            else
                Trace.warning("Warning : no LAYER_LOAD_START dispatched because map event dispatcher is not defined");
                 
			if(_request)
				_request.destroy();
			this.loading = true;
			this.drawFeatures();
			_request = new XMLRequest(url, onSuccess, this.proxy, URLRequestMethod.GET, this.security,onFailure);
		}
		
		
		/**
		 * Called on return from request succcess.
		 *
		 * @param request
		 */
		protected function onSuccess(event:Event):void {
			var loader:URLLoader = event.target as URLLoader;
			//var startTime:Date;
			//var endTime:Date;

			this.loading = false;			
			
			// To avoid errors in case of the WFS server is dead
			try {
				//startTime = new Date();
				var doc:XML =  new XML(loader.data);
				//endTime = new Date();
				//Trace.debug("XML object creation : " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds");
			}
			catch(error:Error) {
				Trace.error(error.message);
			}
			
			this.clear();
			var gml:GMLFormat = new GMLFormat(this.extractAttributes);
			if (this.map.baseLayer.projection != null && this.projection != null && this.projection.srsCode != this.map.baseLayer.projection.srsCode) {
				gml.externalProj = this.projection;
				gml.internalProj = this.map.baseLayer.projection;
			}
			/*else { 
				Trace.debug("WFSTile.requestSuccess: no reprojection needed");
			}*/
			
			//startTime = new Date();
			// TODO : Issue 217: Optimize WFS by drawing feature as soon as they are parsed
			var features:Array = gml.read(doc) as Array;
			//endTime = new Date();
			//Trace.debug("XML parsing : " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds");
			
			//startTime = new Date();
			this.addFeatures(features);
			//endTime = new Date();
			//Trace.debug("Add features : " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds");
			
			if (map) {
                this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_LOAD_END, this ));
			} else {
                Trace.warning("Warning : no LAYER_LOAD_END dispatched because map event dispatcher is not defined"); 	
			}
		}
		
		/**
		 * Called on return from request failure.
		 *
		 * @param event
		 */
		protected function onFailure(event:Event):void {
			this.loading = false;
			Trace.error("Error when loading WFS request " + this._url);			
		}
		/**
		 * Construct new feature and add to this.features.
		 *
		 * @param results
		 */
		protected function addResults(results:Object):void {
			for (var i:int=0; i < results.length; i++) {
				var data:Object = this.processXMLNode(results[i]);
				var feature:Feature = new Feature( this, data.lonlat, data);
				this.features.push(feature);
			}
		}
		
		protected function processXMLNode(xmlNode:XML):Object {
			var point:XMLList = xmlNode.elements("gml::Point");
			var text:String = point[0].elements("gml::coordinates")[0].nodeValue;
			var floats:Array = text.split(",");
			return {lonlat: new LonLat(Number(floats[0]),
						Number(floats[1])),
					id: null};
		}

		public function get params():WFSParams {
			return this._params;
		}

		public function set params(value:WFSParams):void {
			this._params = value;
		}

		public function get url():String {		
			return this._url;
		}

		public function set url(value:String):void {
			this._firstRendering = true;
			this._url=value;
		}

		public function get writer():Format {
			return this._writer;
		}

		public function set writer(value:Format):void {
			this._writer = value;
		}

		public function get featureNS():String {
			return this._featureNS;
		}

		public function set featureNS(value:String):void {
			this._featureNS = value;
		}

		public function get geometryColumn():String {
			return this._geometryColumn;
		}

		public function set geometryColumn(value:String):void {
			this._geometryColumn = value;
		}

		public function get extractAttributes():Boolean {
			return this._extractAttributes;
		}

		public function set extractAttributes(value:Boolean):void {
			this._extractAttributes = value;
		}

		public function get useCapabilities():Boolean {
			return this._useCapabilities;
		}

		public function set useCapabilities(value:Boolean):void {
			this._useCapabilities = value;
		}

		public function set capabilitiesVersion(value:String):void {
			this._capabilitiesVersion = value;
		}

		public function get capabilitiesVersion():String {
			return this._capabilitiesVersion;
		}


	}
}

