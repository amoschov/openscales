package org.openscales.core.control
{
	import org.openscales.proj4as.ProjProjection;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.MapEvent;

	public class MousePosition extends Control
	{
				
		private var _label:TextField = null;
		
    	private var _prefix:String = "";
    	
    	private var _separator:String = ", ";
    
    	private var _suffix:String = "";

 	   	private var _numdigits:Number = 5;
 
    	private var _granularity:int = 10;
    	
    	private var _lastXy:Pixel = null;
    	
    	private var _displayProjection:ProjProjection = null;
    	  	
    	public function MousePosition(position:Pixel = null) {
    		super(position);
    		
    		this.label = new TextField();
			this.label.width = 150;
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
    	
    	/**
    	 * Display the coordinate where is the mouse
    	 * 
    	 * @param evt
    	 */
    	public function redraw(evt:MouseEvent = null):void {
    		var lonLat:LonLat;

	        if (evt != null) {
	            if (this.lastXy == null ||
	                Math.abs(map.mouseX - this.lastXy.x) > this.granularity ||
	                Math.abs(map.mouseY - this.lastXy.y) > this.granularity)
	            {
	                this.lastXy = new Pixel(map.mouseX, map.mouseY);
	                return;
	            }
				
				this.lastXy = new Pixel(map.mouseX, map.mouseY);
	            lonLat = this.map.getLonLatFromMapPx(this.lastXy);
	        }
	        
	        if(lonLat == null)
	        	lonLat = new LonLat(0, 0);
	    
	        if (this._displayProjection) {
	            lonLat.transform(this.map.projection, this._displayProjection );
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
			
			if (!this.x) this.x = this.map.size.w - 150;
			if (!this.y) this.y = this.map.size.h - 20;
						
			this.map.addEventListener(MouseEvent.MOUSE_MOVE,this.redraw);
		}
		
		override public function resize(event:MapEvent):void {
			if (!this.x) this.x = this.map.size.w - 150;
			if (!this.y) this.y = this.map.size.h - 20;
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
		
		public function get displayProjection():ProjProjection
		{
			return _displayProjection;
		}
		public function set displayProjection(value:ProjProjection):void
		{
			_displayProjection = value;
		}
		
		public function get label():TextField
		{
			return this._label;
		}
		public function set label(value:TextField):void
		{
			this._label = value;
		}
	}
}