package org.openscales.core.control
{
	import org.openscales.core.Control;
	import org.openscales.core.Geometry;
	import org.openscales.core.Util;
	import org.openscales.core.layer.Vector;
	import org.openscales.core.feature.Vector;

	public class DrawFeature extends Control
	{

    	public var callbacks:Object = null;

    	public var featureAdded:Function = function():void {};

		public var handlerOptions:Object = null;

		public function DrawFeature(layer:org.openscales.core.layer.Vector, handler:Class, options:Object = null):void {
			super(options);
	        this.callbacks = Util.extend({done: this.drawFeature},
	                                                this.callbacks);
	        this.layer = layer;
	        this.handler = new handler(this, this.callbacks, this.handlerOptions);
		}
		
		public function drawFeature(geometry:Geometry):void {
			var feature:org.openscales.core.feature.Vector = new org.openscales.core.feature.Vector(geometry);
		    this.layer.addFeatures([feature]);
		    this.featureAdded(feature);
		}
		
	}
}