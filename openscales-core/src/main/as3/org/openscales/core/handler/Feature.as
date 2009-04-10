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
	        
	        control.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDown);
	        control.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
	        control.addEventListener(MouseEvent.MOUSE_UP, this.mouseUp);
	        control.addEventListener(MouseEvent.DOUBLE_CLICK, this.mouseDoubleClick);
	        
    	}
    	
    	override public function deactivate():void {
    		this.layer.zindex = this.layerIndex;
    		
    		control.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDown);
	        control.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
	        control.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUp);
	        control.removeEventListener(MouseEvent.DOUBLE_CLICK, this.mouseDoubleClick);
    	}
    	
    	/**
		 * callback function over(feature:org.openscales.core.feature.Vector):void
		 */
		public var over:Function = null;
		
    	
    	/**
		 * callback function out(feature:org.openscales.core.feature.Vector):void
		 */
		public var out:Function = null;
		
		/**
		 * callback function move(feature:org.openscales.core.feature.Vector):void
		 */
		public var move:Function = null;
		
		/**
		 * callback function down(feature:org.openscales.core.feature.Vector):void
		 */
		public var down:Function = null;
		
		/**
		 * callback function up(feature:org.openscales.core.feature.Vector):void
		 */
		public var up:Function = null;
    	
    	/**
		 * callback function doubleclick(feature:org.openscales.core.feature.Vector):void
		 */
		public var doubleClick:Function = null;
    	
		
    	protected function mouseDown(evt:MouseEvent):Boolean {
    		var selected:Boolean = this.select(this.down, evt);
    		return !selected;
    	}
    	
    	protected function mouseMove(evt:MouseEvent):Boolean {
    		this.select(this.move, evt);
        	return true;
    	}
    	
    	protected function mouseUp(evt:MouseEvent):Boolean {
    		var selected:Boolean = this.select(this.up, evt);
        	return !selected;
    	}
    	
    	protected function mouseDoubleClick(evt:MouseEvent):Boolean {
    		var selected:Boolean = this.select(this.doubleClick, evt);
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