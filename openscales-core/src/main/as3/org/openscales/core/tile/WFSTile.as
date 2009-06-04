package org.openscales.core.tile
{
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Request;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.format.GMLFormat;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.ogc.WFS;
	
	/**
	 * WFS single tile
	 */
	public class WFSTile extends Tile
	{
		
		private var _features:Array = null;		
		
		/**
	     * WFSTile constructor
	     * 
	     * @param layer
	     * @param position
	     * @param bounds
	     * @param url
	     * @param size
	     */ 
		public function WFSTile(layer:Layer, position:Pixel, bounds:Bounds, url:String, size:Size):void {
			super(layer, position, bounds, url, size);
        	this.features = new Array();
		}
		
		override public function destroy():void {
			super.destroy();
	        this.destroyAllFeatures();
	        this.features = null;
		}
		
		/** 
	     *  Clear the tile of any bounds/position-related data so that it can 
	     *   be reused in a new location.
	     */
		override public function clear():void {
			super.clear();
        	this.destroyAllFeatures();
		}
		
		/**
	     * Check that a tile should be drawn, and load features for it.
	     */
		override public function draw():Boolean {
			if (super.draw()) {
	            this.loadFeaturesForRegion(this.requestSuccess);
	        }
	        return false;
		}
		
		/** 
	    * Abort any pending requests and issue another request for data. 
	    *
	    * Input are function pointers for what to do on success and failure.
	    *
	    * @param success
	    * @param failure
	    */
		public function loadFeaturesForRegion(success:Function):void {
			new Request(this.url, URLRequestMethod.GET, success, null, null, this.layer.proxy);
		}
		
		/**
	    * Called on return from request succcess. 
	    *
	    * @param request
	    */
		public function requestSuccess(event:Event):void {
			var loader:URLLoader = event.target as URLLoader;
			var doc:XML =  new XML(loader.data);;
			var wfsLayer:org.openscales.core.layer.ogc.WFS = this.layer as org.openscales.core.layer.ogc.WFS;
			
			if (wfsLayer && wfsLayer.vectorMode) {
				wfsLayer.destroyFeatures();
				wfsLayer.renderer.clear();
			}
						
	        if (wfsLayer && wfsLayer.vectorMode) {
	            var gml:GMLFormat = new GMLFormat(wfsLayer.extractAttributes);
	            if (this.layer.map.projection != null && this.layer.projection != null && this.layer.projection.srsCode != this.layer.map.projection.srsCode) {
	            	gml.externalProj = this.layer.projection;
	            	gml.internalProj = this.layer.map.projection;
        		}
	            wfsLayer.addFeatures(gml.read(doc));
	        } else {
	            var resultFeatures:Object = doc..*::featureMember;
	            this.addResults(resultFeatures);
	        }
		}
		
		/**
	     * Construct new feature via layer featureClass constructor, and add to
	     * this.features.
	     * 
	     * @param results
	     */
		public function addResults(results:Object):void {
			var wfsLayer:org.openscales.core.layer.ogc.WFS = this.layer as org.openscales.core.layer.ogc.WFS;
			for (var i:int=0; i < results.length; i++) {
	            var feature:Object = new wfsLayer.featureClass(this.layer, results[i]);
	            this.features.push(feature);
	        }
		}
		
		/** 
	     * Iterate through and call destroy() on each feature, removing it from
	     *   the local array
	     */
		public function destroyAllFeatures():void {
			while(this.features.length > 0) {
	            var feature:Object = this.features.shift();
	            feature.destroy();
	        }
		}
		
		//Getters and Setters
		public function get features():Array {
        	return this._features;
        }
        
        public function set features(value:Array):void {
        	this._features = value;
        }

	}
}