package org.openscales.core.handler
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.control.Control;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.layer.Vector;

	public class Feature extends Handler
	{
		
		public var layerIndex:Number = NaN;

    	public var feature:org.openscales.core.feature.Vector = null;
    	
    	public var layer:org.openscales.core.layer.Vector = null;
    	
    	public function Feature(control:Control, layer:org.openscales.core.layer.Vector, options:Object = null):void {
    		super(control, options);
    		this.layer = layer;
    	}
    	
    	override public function activate():void {
	    	this.layerIndex = this.layer.zindex;
	        this.layer.zindex = this.map.Z_INDEX_BASE['Popup'] - 1;
	        
	        control.addEventListener(MouseEvent.MOUSE_DOWN, this.mousedown);
	        control.addEventListener(MouseEvent.MOUSE_MOVE, this.mousemove);
	        control.addEventListener(MouseEvent.MOUSE_UP, this.mouseup);
	        control.addEventListener(MouseEvent.DOUBLE_CLICK, this.mousedoubleclick);
	        
    	}
    	
    	override public function deactivate():void {
    		this.layer.zindex = this.layerIndex;
    		
    		control.removeEventListener(MouseEvent.MOUSE_DOWN, this.mousedown);
	        control.removeEventListener(MouseEvent.MOUSE_MOVE, this.mousemove);
	        control.removeEventListener(MouseEvent.MOUSE_UP, this.mouseup);
	        control.removeEventListener(MouseEvent.DOUBLE_CLICK, this.mousedoubleclick);
    	}
    	
    	/**
		 * function over(feature:org.openscales.core.feature.Vector):void
		 */
		public var over:Function = null;
		
    	
    	/**
		 * function out(feature:org.openscales.core.feature.Vector):void
		 */
		public var out:Function = null;
		
		/**
		 * function move(feature:org.openscales.core.feature.Vector):void
		 */
		public var move:Function = null;
		
		/**
		 * function down(feature:org.openscales.core.feature.Vector):void
		 */
		public var down:Function = null;
		
		/**
		 * function up(feature:org.openscales.core.feature.Vector):void
		 */
		public var up:Function = null;
    	
    	/**
		 * function doubleclick(feature:org.openscales.core.feature.Vector):void
		 */
		public var doubleclick:Function = null;
    	
		
    	protected function mousedown(evt:MouseEvent):Boolean {
    		var selected:Boolean = this.select(this.down, evt);
    		return !selected;
    	}
    	
    	protected function mousemove(evt:MouseEvent):Boolean {
    		this.select(this.move, evt);
        	return true;
    	}
    	
    	protected function mouseup(evt:MouseEvent):Boolean {
    		var selected:Boolean = this.select(this.up, evt);
        	return !selected;
    	}
    	
    	protected function mousedoubleclick(evt:MouseEvent):Boolean {
    		var selected:Boolean = this.select(this.doubleclick, evt);
        	return !selected;
    	}
    	
    	protected function select(type:Function, evt:MouseEvent):Boolean {
    		var feature:org.openscales.core.feature.Vector = this.layer.getFeatureFromEvent(evt);
	        if(feature) {
	            if(!this.feature) {
	                this.over(feature);
	            } else if(this.feature != feature) {
	                this.out(this.feature);
	                this.over(feature);
	            }
	            this.feature = feature;
	            type(feature);
	            return true;
	        } else {
	            if(this.feature) {
	                // out of the last
	                this.out(this.feature);
	                this.feature = null;
	            }
	            return false;
	        }
    	}
    	
    	
	}
}