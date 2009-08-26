package org.openscales.core.handler.zoom
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.ZoomBoxEvent;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.handler.mouse.DragHandler;
	
	public class ZoomBoxHandler extends Handler
	{
		
		/**
         * Coordinates of the top left corner (of the drawing rectangle)
         */
         private var _startCoordinates:LonLat = null;
	            
	    /**
	     * Color of the rectangle
	     */
	     private var _fillColor:uint = 0x660000
	     private var _drawContainer:Sprite = new Sprite();     
                
         public function ZoomBoxHandler(map:Map=null, active:Boolean=false):void{
         	super(map, active);
         }
         
         override protected function registerListeners():void{
   			this.map.addEventListener(MouseEvent.MOUSE_DOWN,startBox);
	        this.map.addEventListener(MouseEvent.MOUSE_UP,endBox);     
         }
         
         override protected function unregisterListeners():void{
         	this.map.removeEventListener(MouseEvent.MOUSE_DOWN,startBox);
	        this.map.removeEventListener(MouseEvent.MOUSE_UP,endBox);
	        this.map.removeEventListener(MouseEvent.MOUSE_MOVE,expandArea);
         }
        
         override public function set map(value:Map):void{
         	super.map = value;
         	if(map!=null){map.addChild(_drawContainer);}
         }
				
        private function startBox(e:MouseEvent) : void {
            this.map.addEventListener(MouseEvent.MOUSE_MOVE,expandArea);
            _drawContainer.graphics.beginFill(_fillColor,0.5);
            _drawContainer.graphics.drawRect(map.mouseX,map.mouseY,1,1);
            _drawContainer.graphics.endFill();
            this._startCoordinates = this.map.getLonLatFromMapPx(new Pixel(map.mouseX, map.mouseY));
            
        }

        private function endBox(e:MouseEvent) : void {
            this.map.removeEventListener(MouseEvent.MOUSE_MOVE,expandArea);
      		this.map.removeEventListener(MouseEvent.MOUSE_DOWN,startBox);
            this.map.removeEventListener(MouseEvent.MOUSE_UP,endBox);
      		_drawContainer.graphics.clear();
      		var endCoordinates:LonLat = this.map.getLonLatFromMapPx(new Pixel(map.mouseX, map.mouseY));
           	map.zoomToExtent(new Bounds(Math.min(_startCoordinates.lon,endCoordinates.lon),
               									Math.min(endCoordinates.lat,_startCoordinates.lat),
               									Math.max(_startCoordinates.lon,endCoordinates.lon),
               									Math.max(endCoordinates.lat,_startCoordinates.lat)));
            this._startCoordinates = null;
            this.map.dispatchEvent(new ZoomBoxEvent(ZoomBoxEvent.END));
            this.active = false;
	        activeDrag();
        }

        private function expandArea(e:MouseEvent) : void {
            var ll:Pixel = map.getMapPxFromLonLat(_startCoordinates);
            _drawContainer.graphics.clear();
            _drawContainer.graphics.beginFill(_fillColor,0.5);
            _drawContainer.graphics.drawRect(ll.x,ll.y,map.mouseX - ll.x,map.mouseY - ll.y);
            _drawContainer.graphics.endFill();
        }
			
	   /**
	    * Active paning
		* User can pan the map
		*/
        public function activeDrag():void{
            var handler:Handler;
            for each(handler in this.map.handlers){
            if(handler is DragHandler){handler.active = true;}
            }
        }

		/**
	     * Deactive paning
		 * User can't pan map anymore
		 */
         public function deactiveDrag():void{
            var handler:Handler;
            for each(handler in this.map.handlers){
            	if(handler is DragHandler){handler.active = false;}
            }
         }
	}
}