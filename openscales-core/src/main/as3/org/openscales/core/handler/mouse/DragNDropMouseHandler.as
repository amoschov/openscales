package org.openscales.core.handler.mouse {
	
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.handler.Handler;
	
	
	public class DragNDropMouseHandler extends Handler {
		
		private var _startCenter:LonLat = null;
		
		private var _start:Pixel = null;
		
		private var _last:Pixel = null;
		
		private var _dragging:Boolean = false;
			
		public function DragNDropMouseHandler(target:Map = null, active:Boolean = false){
			super(target,active);
		}
		
		override protected function registerListeners():void{
			this.map.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			this.map.addEventListener(MouseEvent.CLICK, this.onMouseUp);
		}
		
		override protected function unregisterListeners():void{
			this.map.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			this.map.removeEventListener(MouseEvent.CLICK, this.onMouseUp);
           	this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
           	this.map.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
           	//this.map.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseUp);
		}
		
		private function onMouseDown(event:MouseEvent):void {
			this.start = new Pixel(event.stageX, event.stageY);
			this.startCenter = this.map.center;
	        this.last = new Pixel(event.stageX, event.stageY);
           	this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
           	this.down(new Pixel(event.stageX, event.stageY));
		}
		
		private function onMouseMove(event:MouseEvent):void {
            if(event.stageX != this.last.x || event.stageY != this.last.y) {
                this.last = new Pixel(event.stageX, event.stageY);
            	this.dragging = true;
            	this.move(new Pixel(event.stageX, event.stageY));
              	this.map.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
	           	//this.map.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseUp);
            }
	 	}
	 	
	 	protected function onMouseUp(event:MouseEvent):void {
			this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
           	this.map.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
           	//this.map.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseUp);
			
			if (this._dragging) {
	            this.map.useHandCursor = false;
	            this.map.buttonMode = false;
                this.done(new Pixel(event.stageX, event.stageY));
                this._dragging = false;
	        }
	 	}
	 	
	 	public function get start():Pixel {
			return this._start;
		}
		
		public function set start(value:Pixel):void {
			this._start = value;
		}
		
		public function get startCenter():LonLat {
			return this._startCenter;
		}
		
		public function set startCenter(value:LonLat):void {
			this._startCenter = value;
		}
		
		public function get last():Pixel {
			return this._last;
		}
		
		public function set last(value:Pixel):void {
			this._last = value;
		}
	 	
	 	public function get dragging():Boolean {
			return this._dragging;
		}
		
		public function set dragging(value:Boolean):void {
			this._dragging = value;
		}
		
		public function down(xy:Pixel):void {
			this.map.buttonMode = true;
	        this.map.useHandCursor = true;
		}
	 	
	 	public function move(xy:Pixel):void {
            this.panMap(xy);
	 	}
		
		public function done(xy:Pixel):void {
            if(this.dragging) {
            	this.panMap(xy);
            	this.dragging = false;
            }
	 	}
	 	
	 	private function panMap(xy:Pixel):void {
	 		this.dragging = true;
	        var deltaX:Number = this.start.x - xy.x;
	        var deltaY:Number = this.start.y - xy.y;
	                
	        var newCenter:LonLat = new LonLat(this.startCenter.lon + deltaX * this.map.resolution , this.startCenter.lat - deltaY * this.map.resolution);
	        
	        this.map.setCenter(newCenter, NaN, this.dragging);
	 	}
	}
}