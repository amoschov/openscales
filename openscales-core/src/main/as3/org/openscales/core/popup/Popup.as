package org.openscales.core.popup
{
	import com.gskinner.motion.GTweeny;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.Marker;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.Button;
	import org.openscales.core.feature.Feature;
	
	public class Popup extends Sprite
	{
		
		public static var WIDTH:Number = 300;
		public static var HEIGHT:Number = 300;
		public static var BORDER:Number = 2;
	    
	    private var _id:String = "";

	    private var _lonlat:LonLat = null;
	
	    private var _size:Size = null;    
	    	    
	    private var _border:Number;
    
	    private var _map:Map = null;
	        
	    private var _textfield:TextField = null;
	    
	    private var _feature:Feature = null;
	    
	    private var _htmlText:String = null;
	    
	    private var _closeBox:Boolean;
	    
	    	    
	    [Embed(source="/org/openscales/core/img/close.gif")]
        private var _closeImg:Class;
	    
	    public function Popup(id:String, lonlat:LonLat, size:Size = null, htmlText:String = "", closeBox:Boolean = true):void {
	    	if (id == null) {
	            id = Util.createUniqueID(getQualifiedClassName(this) + "_");
	        }
	
	        this.id = id;
	        this.lonlat = lonlat;
	        this.border = Popup.BORDER;
	        this.closeBox = closeBox;
	        
	        this.textfield = new TextField();
	        this.textfield.multiline = true;
	        this.textfield.htmlText = htmlText;
	        this.addChild(textfield); 
	        
	        if (size != null){
	        	this._size = size;
	        }
	        else{
	        	this.size = new Size(Popup.WIDTH,Popup.HEIGHT);
	        }
	    }
	    
	    public function closePopup(evt:MouseEvent):void {
        	var target:Sprite = (evt.target as Sprite);
        	target.visible = false;
        	graphics.clear();       	
			graphics.clear();
       	
       	    this.removeChild(target);
       		if ( this.contains(textfield) )
       		{      
					this.removeChild(textfield);
       		}			      					    
            evt.stopPropagation();
            
        } 
	    
	    public function showPopup(event:MouseEvent):void {
			var mark:Marker = (event.currentTarget as Marker);
			mark.map.addPopup(this); 
		}
		
		private function hidePopup(event:MouseEvent):void {
			var node:Object = event.currentTarget;
			var feature:Feature = node.feature;
			if (feature.popup) {
				feature.popup.visible = false;
			}
		}
		
		private function stopPropagation(event:MouseEvent):void{
			event.stopPropagation();
		}
		
	    public function destroy():void {
	    	if (this.map != null) {
	            this.map.removePopup(this);
	            this.map = null;
	        }
	    }
	    
	    public function draw(px:Pixel = null):void {
	    	if (px == null) {
	            if ((this.lonlat != null) && (this.map != null)) {
	                px = this.map.getViewPortPxFromLonLat(this.lonlat);
	            }
	        }
	        
	        this.position = px;
 	                 
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0,0,this.size.w, this.size.h);
			this.width = this.size.w;
			this.height = this.size.h;
			this._textfield.width = this.size.w;
			this._textfield.height = this.size.h;
			this.graphics.endFill();
			this.graphics.lineStyle(this.border, 0x000000);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(0, this.size.h);
			this.graphics.lineTo(this.size.w, this.size.h);
			this.graphics.lineTo(this.size.w, 0);
			this.graphics.lineTo(0, 0);
			
			if (this.closeBox == true) {
	
	          	var img:Bitmap = new this._closeImg();

	            var closeImg:Button = new Button(this.id + "_close", img, new Pixel(this.size.w- 17 - (this.border/2), (this.border/2)));
	            
	            this.addChild(closeImg);
	
	            closeImg.addEventListener(MouseEvent.CLICK, closePopup);
	  	 	}
	  		this.alpha = 0;
	  		var tween:GTweeny = new GTweeny(this, 0.5, {alpha:1});
	    }
	    
		public function set position(px:Pixel):void {
			if (px != null) {
	            this.x = px.x;
	            this.y = px.y;
	        }
		}
		
		public function get position():Pixel {
			return new Pixel(this.x, this.y);
		}
		
		public function set htmlText(value:String):void {
			if (value != null) {
	            this.textfield.htmlText = value;
	        }
		}
		
		public function get size():Size {
			return this._size;
			
		}
		public function set size(size:Size):void {
			if (size != null) {
	            this._size = size;
	            this.width = this.size.w;
	            this.height = this.size.h;
	        }
		}
		
		public function get border():Number {
			return this._border;
			
		}
		public function set border(value:Number):void {
			this._border = value;
		}
		
		public function get textfield():TextField {
			return this._textfield;
			
		}
		public function set textfield(value:TextField):void {
			this._textfield = value;
		}
		
		public function get map():Map {
			return this._map;
			
		}
		public function set map(value:Map):void {
			this._map = value;
		}
		
		public function get id():String {
			return this._id;
			
		}
		public function set id(value:String):void {
			this._id = value;
		}
		
		public function get lonlat():LonLat {
			return this._lonlat;
		}
		public function set lonlat(value:LonLat):void {
			this._lonlat = value;
		}
		
		public function get feature():Feature {
			return this._feature;
		}
		public function set feature(value:Feature):void {
			this._feature = value;
		}
		
		public function get htmlText():String{
			return this._htmlText;			
		}
		
		public function get closeBox():Boolean{
			return this._closeBox;
		}
		public function set closeBox(value:Boolean):void{
			this._closeBox = value;
		}
	}
}