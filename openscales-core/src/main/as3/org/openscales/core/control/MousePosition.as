package org.openscales.core.control
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.MapEvent;

	public class MousePosition extends Control
	{
				
		public var label:TextField = null;
		
    	private var _prefix:String = "";
    	
    	private var _separator:String = ", ";
    
    	private var _suffix:String = "";

 	   	private var _numdigits:Number = 5;
 
    	private var _granularity:int = 10;
    	
    	private var _lastXy:Pixel = null;
    	  	
    	public function MousePosition(options:Object = null):void {
    		super(options);
    		
    		this.label = new TextField();
			
			var labelFormat:TextFormat = new TextFormat();
			labelFormat.size = 11;
			labelFormat.color = 0x0F0F0F;
			labelFormat.font = "Verdana";
			this.label.setTextFormat(labelFormat);
			
    	}
    	
    	override public function draw():void {
	    	super.draw();
	    	
	    	this.addChild(label);
	      
        	this.redraw();

    	}
    	
    	public function redraw(evt:MouseEvent = null):void {
    		var lonLat:LonLat;

	        if (evt == null) {
	            lonLat = new LonLat(0, 0);
	        } else {
	            if (this.lastXy == null ||
	                Math.abs(map.mouseX - this.lastXy.x) > this.granularity ||
	                Math.abs(map.mouseY - this.lastXy.y) > this.granularity)
	            {
	                this.lastXy = new Pixel(map.mouseX, map.mouseY);
	                return;
	            }
				
				this.lastXy = new Pixel(map.mouseX, map.mouseY);
	            lonLat = this.map.getLonLatFromPixel(this.lastXy);
	        }
	        
	        var digits:int = int(this.numdigits);
	        this.label.text =
	            this.prefix +
	            lonLat.lon.toFixed(digits) +
	            this.separator + 
	            lonLat.lat.toFixed(digits) +
	            this.suffix;
	
    	}
		
		override public function set map(map:Map):void {
			super.map = map;
			
			this.x = this.map.size.w - 110;
			this.y = this.map.size.h - 20;
			
			this.map.addEventListener(MouseEvent.MOUSE_MOVE,this.redraw);
		}
		
		override public function resize(event:MapEvent):void {
			this.x = this.map.size.w - 110;
			this.y = this.map.size.h - 20;
			super.resize(event);
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