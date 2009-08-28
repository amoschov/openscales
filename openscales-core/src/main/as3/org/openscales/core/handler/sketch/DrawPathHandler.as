package org.openscales.core.handler.sketch
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.layer.VectorLayer;

	/**
	 * Handler to draw paths (multi line strings)
	 */
	public class DrawPathHandler extends AbstractDrawHandler
	{		
		// The layer in which we'll draw
		private var _drawLayer:VectorLayer = null;				
		private var _id:Number = 0;
		private var _lineString:LineString=null;
		private var _lastPoint:Point = null;
		private var _newFeature:Boolean = true;
		private var _drawContainer:Sprite = new Sprite();
		private var _startPoint:Pixel=new Pixel(); //for the temporary line

		private var _dblClickHandler:ClickHandler = new ClickHandler();

		/**
		 * DrawPathHandler constructor
		 *
		 * @param map
		 * @param active
		 * @param drawLayer
		 */
		public function DrawPathHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.VectorLayer=null)
		{
			super(map, active, drawLayer);
		}

		override protected function registerListeners():void{
			this._dblClickHandler.active = true;
			/* this._dblClickHandler.click=this.drawLine; */
			this._dblClickHandler.doubleclick = this.mouseDblClick; 
			this.map.addEventListener(MouseEvent.CLICK, this.drawLine);
		}

		override protected function unregisterListeners():void{
			this._dblClickHandler.active = false;
			this.map.removeEventListener(MouseEvent.CLICK, this.drawLine);
		}

		public function mouseDblClick(event:MouseEvent):void {
			this.drawFinalPath();
			_drawContainer.graphics.clear();
			this.map.removeEventListener(MouseEvent.MOUSE_MOVE,temporaryLine);
		} 

		public function drawFinalPath():void{			
			newFeature = true;
			
			//Change style of finished path
			var style:Style = new Style();
			style.strokeColor = 0x60FFE9;

			var f:VectorFeature = drawLayer.features[drawLayer.features.length - 1];
			if(f!=null){
				//Apply the new style
				f.style = style;
				f.name = "path." + id.toString(); id++;
				drawLayer.redraw();
			}	
		}

		private function drawLine(event:MouseEvent=null):void{
			var name:String = "path." + id.toString(); id++;

			var pixel:Pixel = new Pixel(drawLayer.mouseX,drawLayer.mouseY );
			var lonlat:LonLat = this.map.getLonLatFromLayerPx(pixel);
			if(this.drawLayer.projection.srsCode!=this.map.projection.srsCode)
				lonlat.transform(this.map.projection,this.drawLayer.projection);
			var point:Point = new Point(lonlat.lon,lonlat.lat);
			_startPoint = this.map.getMapPxFromLonLat(lonlat);
			
			if(newFeature){
				_lineString = new LineString();
				_lineString.addPoint(point);
				lastPoint = point;
				
				var lineStyle:Style = new Style();
				lineStyle.strokeColor = 0x00ff00;
				
				var lineStringFeature:LineStringFeature = new LineStringFeature(_lineString, null, lineStyle);
				
				drawLayer.addFeature(lineStringFeature);
				
				newFeature = false;
						
				this.map.addEventListener(MouseEvent.MOUSE_MOVE,temporaryLine);	
			}
			else {								
				if(!point.equals(lastPoint)){
					_lineString.addPoint(point); 						
					drawLayer.redraw();
					lastPoint = point;
				}								
			}
		}
		
		private function temporaryLine(evt:MouseEvent):void{
			_drawContainer.graphics.clear();
			_drawContainer.graphics.lineStyle(2, 0x00ff00);
			_drawContainer.graphics.moveTo(_startPoint.x, _startPoint.y);
			_drawContainer.graphics.lineTo(map.mouseX, map.mouseY);	
			_drawContainer.graphics.endFill();	
		}

		override public function set map(value:Map):void {
			super.map = value;
			this._dblClickHandler.map = value;
			if(map!=null){map.addChild(_drawContainer);}
		}

		//Getters and Setters		
		public function get id():Number {
			return _id;
		}
		public function set id(nb:Number):void {
			_id = nb;
		}

		public function get newFeature():Boolean {
			return _newFeature;
		}

		public function set newFeature(newFeature:Boolean):void {
			if(newFeature == true) {
				lastPoint = null;
			}
			_newFeature = newFeature;
		}

		public function get lastPoint():Point {
			return _lastPoint;
		}
		public function set lastPoint(value:Point):void {
			_lastPoint = value;
		}
	}
}