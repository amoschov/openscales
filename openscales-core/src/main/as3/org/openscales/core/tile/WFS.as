package org.openscales.core.tile
{
	
	import flash.events.Event;
	import flash.net.URLLoader;
	
	import org.openscales.core.layer.Layer;
	import org.openscales.core.OpenScales;
	import org.openscales.commons.basetypes.Bounds;
	import org.openscales.commons.basetypes.Pixel;
	import org.openscales.commons.basetypes.Size;
	import org.openscales.core.format.GML;
	import org.openscales.core.layer.WFS;
	
	public class WFS extends Tile
	{
		
		private var features:Array = null;

    	private var urlW:String = null;
		
		
		public function WFS(layer:Layer, position:Pixel, bounds:Bounds, url:String, size:Size):void {
			super(layer, position, bounds, url, size);
			this.urlW = url;        
        	this.features = new Array();
		}
		
		override public function destroy():void {
			super.destroy();
	        this.destroyAllFeatures();
	        this.features = null;
	        this.urlW = null;
		}
		
		override public function clear():void {
			super.clear();
        	this.destroyAllFeatures();
		}
		
		override public function draw():Boolean {
			if (super.draw()) {
	            this.loadFeaturesForRegion(this.requestSuccess);
	        }
	        return false;
		}
		
		public function loadFeaturesForRegion(success:Function):void {
			OpenScales.loadURL(this.url, null, this, success);
		}
		
		public function requestSuccess(event:Event):void {
			var loader:URLLoader = event.target as URLLoader;
			var doc:XML =  new XML(loader.data);;
			var wfsLayer:org.openscales.core.layer.WFS = this.layer as org.openscales.core.layer.WFS;
			
			if (wfsLayer && wfsLayer.vectorMode) {
				wfsLayer.destroyFeatures();
				wfsLayer.renderer.clear();
			}
			
	        if (wfsLayer && wfsLayer.vectorMode) {
	            var gml:GML = new GML({extractAttributes: wfsLayer.extractAttributes});
	            wfsLayer.addFeatures(gml.read(doc));
	        } else {
	            var resultFeatures:Object = doc..*::featureMember;
	            this.addResults(resultFeatures);
	        }
		}
		
		public function addResults(results:Object):void {
			var wfsLayer:org.openscales.core.layer.WFS = this.layer as org.openscales.core.layer.WFS;
			for (var i:int=0; i < results.length; i++) {
	            var feature:Object = new wfsLayer.featureClass(this.layer, results[i]);
	            this.features.push(feature);
	        }
		}
		
		public function destroyAllFeatures():void {
			while(this.features.length > 0) {
	            var feature:Object = this.features.shift();
	            feature.destroy();
	        }
		}

	}
}