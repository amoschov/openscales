package org.openscales.core
{
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.TextArea;
	
	import org.openscales.core.basetypes.Element;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	
	public class PopupOL
	{
		
		public static var WIDTH:Number = 200;
		public static var HEIGHT:Number = 200;
		public static var BORDER:String = "0px";
		
	    private var events:Events = null;
	    
	    private var id:String = "";

	    public var lonlat:LonLat = null;
	
	    public var canvas:CanvasOL = null;

	    public var size:Size = null;    
	    
	    private var contentHTML:String = "";
	    
	    public var border:String = "";

	    public var contentCanvas:CanvasOL = null;

	    public var groupCanvas:CanvasOL = null;
	    
	    public var padding:Number = 3;
	
	    public var map:Map = null;
	    
	    private var mousedown:Boolean;
	    
	    public var textarea:TextArea = null;
	    
	    public var feature:Feature = null;
	    
	    public function PopupOL(id:String, lonlat:LonLat, size:Size, contentHTML:String, closeBox:Boolean):void {
	    	if (id == null) {
	            id = Util.createUniqueID(getQualifiedClassName(this) + "_");
	        }
	
	        this.id = id;
	        this.lonlat = lonlat;
	        this.size = (size != null) ? size 
	                                  : new Size(
                                           PopupOL.WIDTH,
                                           PopupOL.HEIGHT);
	        if (contentHTML != null) { 
	             this.contentHTML = contentHTML;
	        }
	        this.border = PopupOL.BORDER;
	
	        this.canvas = Util.createCanvas(this.id, null, null, 
	                                             null, null, null, "hidden");
	        
	        this.groupCanvas = Util.createCanvas(null, null, null, 
	                                                    null, "relative", null,
	                                                    "hidden");
	
	        var id:String = this.canvas.id + "_contentDiv";
	        this.contentCanvas = Util.createCanvas(id, null, this.size.clone(), 
	                                                    null, "relative", null,
	                                                    "hidden");
	        textarea = new TextArea();
	        if (this.contentHTML.length > 0) {
	        	textarea.htmlText = this.contentHTML;
	        }
	        textarea.verticalScrollPolicy = "off";
	        textarea.horizontalScrollPolicy = "off";
	        textarea.percentWidth = 100;
	        textarea.percentHeight = 100;
	        textarea.text = "[x]";
	        textarea.styleName = "popup";
	        this.contentCanvas.addChild(textarea);
	        this.contentCanvas.popup = this;                                  
	        this.groupCanvas.addChild(this.contentCanvas);
	        this.canvas.addChild(this.groupCanvas);
	
	        if (closeBox == true) {
	            var closeSize:Size = new Size(17,17);
	            var img:String = Util.getImagesLocation() + "close.gif";
	            var closeImg:CanvasOL = Util.createAlphaImageCanvas(this.id + "_close", 
	                                                                null, 
	                                                                closeSize, 
	                                                                img);
	            closeImg.x = this.padding;
	            closeImg.y = this.padding;
	            closeImg.popup = this;
	            this.groupCanvas.addChild(closeImg);
	
	            var closePopup:Function = function(evt:MouseEvent):void {
	            	var target:CanvasOL = evt.currentTarget as CanvasOL;
	            	var label:String = target.popup.textarea.text;
	            	target.popup.feature.attributes.label = label.substr(3);
	                target.popup.hide();
				    /*var layerCanvas = target.popup.feature.layer.canvas;
		    		var layersParent = layerCanvas.parent as CanvasOL;
		    		
		    		this.layerIndex = layersParent.getChildIndex(layerCanvas);
		    		layersParent.setChildIndex(layerCanvas, layersParent.numChildren-1);*/
	                EventOL.stop(evt);
	            }
	            new EventOL().observe(closeImg, MouseEvent.CLICK, 
	                                     closePopup);
	        }
	
	        this.registerEvents();
	    }
	    
	    private function showPopup(event:MouseEvent):void {
			var node:Object = event.currentTarget;
			var feature:Feature = node.feature;
			if (feature.popup) {
				feature.popup.show();
			}
		}
		
		private function hidePopup(event:MouseEvent):void {
			var node:Object = event.currentTarget;
			var feature:Feature = node.feature;
			if (feature.popup) {
				feature.popup.hide();
			}
		}
		
	    public function destroy():void {
	    	if (this.map != null) {
	            this.map.removePopup(this);
	            this.map = null;
	        }
	        this.events.destroy();
	        this.events = null;
	        this.canvas = null;
	    }
	    
	    public function draw(px:Pixel = null):CanvasOL {
	    	if (px == null) {
	            if ((this.lonlat != null) && (this.map != null)) {
	                px = this.map.getLayerPxFromLonLat(this.lonlat);
	            }
	        }
	        
	        this.setSize();
	        this.setBorder();
	        this.setContentHTML();
	        this.moveTo(px);
	
	        return this.canvas;
	    }
	    
	    public function updatePosition():void {
		    if ((this.lonlat) && (this.map)) {
		    	var px:Pixel = this.map.getLayerPxFromLonLat(this.lonlat);
                this.moveTo(px);            
	        }
	    }
	    
	    public function moveTo(px:Pixel):void {
		   	if ((px != null) && (this.canvas != null)) {
	            this.canvas.x = px.x;
	            this.canvas.y = px.y;
	        }
	    }
	    
	    public function visible():Boolean {
	    	return Element.visible([this.canvas]);
	    }
	    
	    public function toggle():void {
	    	Element.toggle([this.canvas]);
	    }
	    
	    public function show():void {
	    	Element.show([this.canvas]);
	    }
	    
	    public function hide():void {
	    	Element.hide([this.canvas]);
	    }
		
		public function setSize(size:Size = null):void {
			if (size != null) {
	            this.size = size; 
	        }
	        
	        if (this.canvas != null) {
	            this.canvas.width = this.size.w;
	            this.canvas.height = this.size.h;
	        }
	        if (this.contentCanvas != null){
	            this.contentCanvas.width = this.size.w;
	            this.contentCanvas.height = this.size.h;
	        }
		}
		
		public function setBorder(border:String = null):void {
			if (border != null) {
	            this.border = border;
	        }
	                
	        if (this.canvas != null) {
	            this.canvas.style.border = this.border;
	        }
		}
		
		public function setContentHTML(contentHTML:String = null):void {
			if (contentHTML != null) {
	            this.contentHTML = contentHTML;
	        }
	        
	        if (this.contentCanvas != null && this.contentHTML.length > 0) {
	            (this.contentCanvas.getChildAt(0) as TextArea).text = "[x]" + this.contentHTML;
	        }
		}
		
		public function registerEvents():void {
			
			//new EventOL().observe(this.canvas, MouseEvent.CLICK, this.onclick);
			
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
        	EventOL.stop(evt, true);
		}
		
		public function onmousemove(evt:MouseEvent):void {
			if (this.mousedown) {
            	EventOL.stop(evt, true);
        	}
		}
		
		public function onmouseup(evt:MouseEvent):void {
			if (this.mousedown) {
	            this.mousedown = false;
	            EventOL.stop(evt, true);
	        }
		}
		
		public function onclick(evt:MouseEvent):void {
			EventOL.stop(evt, true);
		}
		
		public function onmouseout(evt:MouseEvent):void {
			this.mousedown = false;
		}
		
		public function ondblclick(evt:MouseEvent):void {
			EventOL.stop(evt, true);
		}
		
	}
}