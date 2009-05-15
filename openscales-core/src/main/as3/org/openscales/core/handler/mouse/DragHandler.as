package org.openscales.core.handler.mouse
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.handler.Handler;
	
	public class DragHandler extends Handler
	{
		private var _startCenter:LonLat = null;		
		private var _start:Pixel = null;
		
		private var _dragging:Boolean = false;	
		
		private var _onStart:Function=null;
		private var _oncomplete:Function=null;
		
		public function DragHandler(map:Map=null,active:Boolean=false)
		{
			super(map,active);
		}
		override protected function registerListeners():void{
			this.map.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			this.map.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
			
		}
		
		override protected function unregisterListeners():void{
			this.map.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
           	this.map.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);         
		}
		
		protected function onMouseDown(event:Event):void{
			var element:Object = this.map.layerContainer;
			element.startDrag();
			this._start = new Pixel((event as MouseEvent).stageX,(event as MouseEvent).stageY);
			this._startCenter = this.map.center;
			this.map.buttonMode=true;
			this.dragging=true;
			if(this.onstart!=null) this.onstart(event as MouseEvent);
		}
		protected function onMouseUp(event:Event):void{			
			var element:Object = this.map.layerContainer;
			element.stopDrag();		
			this.map.buttonMode=false;		
            this.done(new Pixel((event as MouseEvent).stageX,(event as MouseEvent).stageY));
            
			this.dragging=false;
			if(this.oncomplete!=null) this.oncomplete(event as MouseEvent);
		}
		
		//properties
		public function get dragging():Boolean
		{
			return this._dragging;
		}
		public function set dragging(dragging:Boolean):void
		{
			this._dragging=dragging;	
		}
		public function set onstart(onstart:Function):void
		{
			this._onStart=onstart;
		}
		public function get onstart():Function
		{
			return this._onStart;
		}
		public function set oncomplete(oncomplete:Function):void
		{
			this._oncomplete=oncomplete;	
		}
		public function get oncomplete():Function
		{
			return this._oncomplete;
		}
		
		private function done(xy:Pixel):void {
            if(this.dragging) {
            	this.panMap(xy);
            	this.dragging = false;
            }
	 	}
		private function panMap(xy:Pixel):void {
	 		this.dragging = true;
	        var deltaX:Number = this._start.x - xy.x;
	        var deltaY:Number = this._start.y - xy.y;
	                
	        var newCenter:LonLat = new LonLat(this._startCenter.lon + deltaX * this.map.resolution , this._startCenter.lat - deltaY * this.map.resolution);
	        
<<<<<<< .mine
	        this.map.center = newCenter;
=======
	        //this.map.setCenter(newCenter, NaN, this.dragging);
	        this.map.center = newCenter;
>>>>>>> .r416
	 	}
	}
}