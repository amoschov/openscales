package org.openscales.core.popup
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.control.Button;
	import org.openscales.core.event.Events;
	import org.openscales.core.event.OpenScalesEvent;
	import org.openscales.core.feature.Feature;
	
	public class Popup extends Sprite
	{
		
		public static var WIDTH:Number = 200;
		public static var HEIGHT:Number = 200;
		public static var BORDER:String = "0px";
		
	    private var events:Events = null;
	    
	    private var id:String = "";

	    public var lonlat:LonLat = null;
	
	    public var size:Size = null;    
	    
	    private var contentHTML:String = "";
	    
	    public var border:String = "";
    
	    public var padding:Number = 3;
	
	    public var map:Map = null;
	    
	    private var mousedown:Boolean;
	    
	    public var textfield:TextField = null;
	    
	    public var feature:Feature = null;
	    
	    [Embed(source="/org/openscales/core/img/close.gif")]
        private var _closeImg:Class;
	    
	    public function Popup(id:String, lonlat:LonLat, size:Size, contentHTML:String, closeBox:Boolean):void {
	    	if (id == null) {
	            id = Util.createUniqueID(getQualifiedClassName(this) + "_");
	        }
	
	        this.id = id;
	        this.lonlat = lonlat;
	        this.size = (size != null) ? size 
	                                  : new Size(
                                           Popup.WIDTH,
                                           Popup.HEIGHT);
	        if (contentHTML != null) { 
	             this.contentHTML = contentHTML;
	        }
	        this.border = Popup.BORDER;
	
	        textfield = new TextField();
	        if (this.contentHTML.length > 0) {
	        	textfield.htmlText = this.contentHTML;
	        }
	      
	        textfield.text = "[x]";
	        
	        this.addChild(textfield);
	
	        if (closeBox == true) {
	            var closeSize:Size = new Size(17,17);
	            var closeImg:Button = new Button(this.id + "_close", new this._closeImg(), new Pixel(this.padding, this.padding), closeSize); 	                                                                null, 

	            this.addChild(closeImg);
	
	            var closePopup:Function = function(evt:MouseEvent):void {
	            	var target:Sprite = evt.currentTarget as Sprite;
	            	/* var label:String = target.popup.textarea.text;
	            	target.popup.feature.attributes.label = label.substr(3);
	                target.popup.visible = false; */
				    
	                OpenScalesEvent.stop(evt);
	            }
	            new OpenScalesEvent().observe(closeImg, MouseEvent.CLICK, 
	                                     closePopup);
	        }
	
	        this.registerEvents();
	    }
	    
	    private function showPopup(event:MouseEvent):void {
			var node:Object = event.currentTarget;
			var feature:Feature = node.feature;
			if (feature.popup) {
				feature.popup.visible = true;
			}
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
	        this.events.destroy();
	        this.events = null;
	    }
	    
	    public function draw(px:Pixel = null):void {
	    	if (px == null) {
	            if ((this.lonlat != null) && (this.map != null)) {
	                px = this.map.getLayerPxFromLonLat(this.lonlat);
	            }
	        }
	        
	        this.setSize();
	        this.setContentHTML();
	        this.position = px;
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
		
		public function setContentHTML(contentHTML:String = null):void {
			if (contentHTML != null) {
	            this.contentHTML = contentHTML;
	        }
	        
	        if (this.contentHTML.length > 0) {
	            (this.getChildAt(0) as TextField).text = "[x]" + this.contentHTML;
	        }
		}
		
		public function setSize(size:Size = null):void {
			if (size != null) {
	            this.size = size;
	            this.width = this.size.w;
	            this.height = this.size.h;
	        }

		}
		
		public function registerEvents():void {
			
			//new OpenScalesEvent().observe(this.canvas, MouseEvent.CLICK, this.onclick);
			
	    /*    this.events = new Events(this, this.canvas, null, true);
	
	        this.events.register(MouseEvent.MOUSE_DOWN, this, this.onmousedown);
	        this.events.register(MouseEvent.MOUSE_MOVE, this, this.onmousemove);
	        this.events.register(MouseEvent.MOUSE_UP, this, this.onmouseup);
	        this.events.register(MouseEvent.CLICK, this, this.onclick);
	        this.events.register(MouseEvent.MOUSE_OUT, this, this.onmouseout);
	        this.events.register(MouseEvent.DOUBLE_CLICK, this, this.ondblclick);*/
		}
		
		public function onmousedown(evt:MouseEvent):void {
			this.mousedown = true;
        	OpenScalesEvent.stop(evt, true);
		}
		
		public function onmousemove(evt:MouseEvent):void {
			if (this.mousedown) {
            	OpenScalesEvent.stop(evt, true);
        	}
		}
		
		public function onmouseup(evt:MouseEvent):void {
			if (this.mousedown) {
	            this.mousedown = false;
	            OpenScalesEvent.stop(evt, true);
	        }
		}
		
		public function onclick(evt:MouseEvent):void {
			OpenScalesEvent.stop(evt, true);
		}
		
		public function onmouseout(evt:MouseEvent):void {
			this.mousedown = false;
		}
		
		public function ondblclick(evt:MouseEvent):void {
			OpenScalesEvent.stop(evt, true);
		}
		
	}
}