package org.openscales.core.control
{
	import flash.events.MouseEvent;
	
	import mx.controls.Label;
	
	import org.openscales.core.CanvasOL;
	import org.openscales.core.Control;
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;

	public class MousePosition extends Control
	{
		
		public var element:CanvasOL = null;
		
		public var label:Label = null;

    	private var _prefix:String = "";
    	
    	private var _separator:String = ", ";
    
    	private var _suffix:String = "";

 	   	private var _numdigits:Number = 5;
 
    	private var _granularity:int = 10;
    	
    	private var _lastXy:Pixel = null;
    	  	
    	public function MousePosition(options:Object = null):void {
    		super(options);
    	}
    	
    	override public function draw(px:Pixel = null, toSuper:Boolean = false):CanvasOL {
	    	super.draw(px);
	
	        if (!toSuper) {
		        if (!this.element) {
		            this.canvas.x = this.map.width - 150;
		            this.canvas.y = this.map.height - 30;
		            this.canvas.classNameOL = this.displayClass;
		            this.element = this.canvas;
		            this.label = new Label();
		            this.element.addChild(label);
		        }
	        
	        	this.redraw();
	        }
	        return this.canvas;
    	}
    	
    	public function redraw(evt:MouseEvent = null):void {
    		var lonLat:LonLat;

	        if (evt == null) {
	            lonLat = new LonLat(0, 0);
	        } else {
	            if (this.lastXy == null ||
	                Math.abs(evt.localX - this.lastXy.x) > this.granularity ||
	                Math.abs(evt.localY - this.lastXy.y) > this.granularity)
	            {
	                this.lastXy = new Pixel(evt.localX, evt.localY);
	                return;
	            }
	
	            lonLat = this.map.getLonLatFromPixel(new Pixel(evt.localX, evt.localY));
	            this.lastXy = new Pixel(evt.localX, evt.localY);
	        }
	        
	        var digits:int = int(this.numdigits);
	        var newHtml:String =
	            this.prefix +
	            lonLat.lon.toFixed(digits) +
	            this.separator + 
	            lonLat.lat.toFixed(digits) +
	            this.suffix;
	
	        if (newHtml != this.label.htmlText) {
	            this.label.htmlText = newHtml;
	        }
    	}
		
		override public function setMap(map:Map):void {
			super.setMap(map);
			this.map.events.register(MouseEvent.MOUSE_MOVE, this, this.redraw);
		}
		
		// Getters & setters
		
		public function get prefix():String
		{
			return _prefix;
		}
		public function set prefix(newPrefix:String):void
		{
			_prefix = newPrefix;
		}
		
		public function get separator():String
		{
			return _separator;
		}
		public function set separator(newSeparator:String):void
		{
			_separator = newSeparator;
		}
		
		public function get suffix():String
		{
			return _suffix;
		}
		public function set suffix(newSuffix:String):void
		{
			_suffix = newSuffix;
		}
		
		public function get numdigits():Number
		{
			return _numdigits;
		}
		public function set numdigits(newNumDigits:Number):void
		{
			_numdigits = newNumDigits;
		}
		
		public function get granularity():int
		{
			return _granularity;
		}
		public function set granularity(newGranularity:int):void
		{
			_granularity = newGranularity;
		}
		
		public function get lastXy():Pixel
		{
			return _lastXy;
		}
		public function set lastXy(newLastXy:Pixel):void
		{
			_lastXy = newLastXy;
		}
	}
}