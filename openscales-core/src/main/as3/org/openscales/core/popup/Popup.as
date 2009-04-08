package org.openscales.core.popup
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.commons.Util;
	import org.openscales.commons.basetypes.LonLat;
	import org.openscales.commons.basetypes.Pixel;
	import org.openscales.commons.basetypes.Size;
	import org.openscales.core.Map;
	import org.openscales.core.Marker;
	import org.openscales.core.control.Button;
	import org.openscales.core.feature.Feature;
	
	public class Popup extends Sprite
	{
		
		public static var WIDTH:Number = 400;
		public static var HEIGHT:Number = 400;
		public static var BORDER:Number = 3;
	    
	    private var _id:String = "";

	    public var _lonlat:LonLat = null;
	
	    private var _size:Size = null;    
	    	    
	    private var _border:Number;
    
	    private var _map:Map = null;
	        
	    private var _textfield:TextField = null;
	    
	    private var _feature:Feature = null;
	    	    
	    [Embed(source="/org/openscales/core/img/close.gif")]
        private var _closeImg:Class;
	    
	    public function Popup(id:String, lonlat:LonLat, size:Size = null, htmlText:String = "", closeBox:Boolean = true):void {
	    	if (id == null) {
	            id = Util.createUniqueID(getQualifiedClassName(this) + "_");
	        }
	
	        this.id = id;
	        this.lonlat = lonlat;
	        this.border = Popup.BORDER;
	        this.textfield = new TextField();
	        this.htmlText = htmlText;
	        
	        if (size != null){
	        	this.size = size;
	        }
	        else{
	        	this.size = new Size(Popup.WIDTH,Popup.HEIGHT);
	        }
	        
	        this.addChild(textfield);
		    
		    if (closeBox == true) {
	
	            var closeImg:Button = new Button(this.id + "_close", new this._closeImg(), this.position.add(25,30)); 
				
	            this.addChild(closeImg);
	
	            closeImg.addEventListener(MouseEvent.CLICK, closePopup);
	        }  
	        
	    }
	    
	    public function closePopup(evt:MouseEvent):void {
        	var target:Sprite = (evt.target as Sprite);
        	target.visible = false;
        	graphics.clear(); 
        					    
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
		
	    public function destroy():void {
	    	if (this.map != null) {
	            this.map.removePopup(this);
	            this.map = null;
	        }
	    }
	    
	    public function draw(px:Pixel = null):void {
	    	if (px == null) {
	            if ((this.lonlat != null) && (this.map != null)) {
	                px = this.map.getLayerPxFromLonLat(this.lonlat);
	            }
	        }        
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(px.x,px.y,this.size.w, this.size.h);
			this.graphics.endFill();
			this.width = this.size.w;
			this.height = this.size.h;
			this.graphics.lineStyle(this.border, 0x000000);
			this.graphics.moveTo(px.x, px.y);
			this.graphics.lineTo(px.x, px.y + this.size.h);
			this.graphics.lineTo(px.x + this.size.w, px.y + this.size.h);
			this.graphics.lineTo(px.x + this.size.w, px.y);
			this.graphics.lineTo(px.x, px.y);
			
			this.textfield.x = px.x;
			this.textfield.y = px.y;
			


	    }
	    
	    public function updatePosition():void {
		    if ((this.lonlat) && (this.map)) {
		    	var px:Pixel = this.map.getLayerPxFromLonLat(this.lonlat);
                this.position = px;           
	        }
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
	}
}