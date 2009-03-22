package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.Control;
	import org.openscales.core.Handler;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.layer.Vector;

	public class Feature extends Handler
	{
		
		public var layerIndex:Number = NaN;

    	public var feature:org.openscales.core.feature.Vector = null;
    	
    	public var layer:org.openscales.core.layer.Vector = null;
    	
    	public function Feature(control:Control, layer:org.openscales.core.layer.Vector, callbacks:Object, options:Object = null):void {
    		super(control, callbacks, options);
    		this.layer = layer;
    	}
    	
    	public function mousedown(evt:MouseEvent):Boolean {
    		var selected:Boolean = this.select("down", evt);
    		return !selected;
    	}
    	
    	public function mousemove(evt:MouseEvent):Boolean {
    		this.select("move", evt);
        	return true;
    	}
    	
    	public function mouseup(evt:MouseEvent):Boolean {
    		var selected:Boolean = this.select("up", evt);
        	return !selected;
    	}
    	
    	public function doubleclick(evt:MouseEvent):Boolean {
    		var selected:Boolean = this.select("doubleclick", evt);
        	return !selected;
    	}
    	
    	public function select(type:String, evt:MouseEvent):Boolean {
    		var feature:org.openscales.core.feature.Vector = this.layer.getFeatureFromEvent(evt);
	        if(feature) {
	            if(!this.feature) {
	                this.callback("over", [feature]);
	            } else if(this.feature != feature) {
	                this.callback("out", [this.feature]);
	                this.callback("over", [feature]);
	            }
	            this.feature = feature;
	            this.callback(type, [feature]);
	            return true;
	        } else {
	            if(this.feature) {
	                // out of the last
	                this.callback("out", [this.feature]);
	                this.feature = null;
	            }
	            return false;
	        }
    	}
    	
    	override public function activate(evt:MouseEvent = null):Boolean {
	    	if(super.activate()) {
	            this.layerIndex = this.layer.zindex;
	            this.layer.zindex = this.map.Z_INDEX_BASE['Popup'] - 1;
	            return true;
	        } else {
	            return false;
	        }
    	}
    	
    	override public function deactivate(evt:MouseEvent = null):Boolean {
    		if(super.deactivate()) {
	            this.layer.zindex = this.layerIndex;
	            return true;
	        } else {
	            return false;
	        }
    	}
	}
}