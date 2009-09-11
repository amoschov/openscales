package org.openscales.core.handler.sketch
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.layer.VectorLayer;

	/**
	 * This handler manage the function draw of the LineString (path).
	 * Active this handler to draw a path.
	 */
	public class DrawPathHandler extends AbstractDrawHandler
	{		
		/**
		 * A unique id of the path
		 */ 
		private var _id:Number = 0;
		
		/**
		 * The lineString which contains all points
		 */
		private var _lineString:LineString=null;
		
		/**
		 * The last point of the lineString. 
		 */
		private var _lastPoint:Point = null; 
		
		/**
		 * To know if we create a new feature, or if some points are already added
		 */
		private var _newFeature:Boolean = true;
		
		/**
		 * The container of the temporary line
		 */
		private var _drawContainer:Sprite = new Sprite();
		
		/**
		 * The start point of the temporary line
		 */
		private var _startPoint:Pixel=new Pixel();
		
		/**
		 * Handler which manage the doubleClick, to finalize the lineString
		 */
		private var _dblClickHandler:ClickHandler = new ClickHandler();

		/**
		 * DrawPathHandler constructor
		 *
		 * @param map
		 * @param active
		 * @param drawLayer The layer on which we'll draw
		 */
		public function DrawPathHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.VectorLayer=null)
		{
			super(map, active, drawLayer);
		}

		override protected function registerListeners():void{
			this._dblClickHandler.active = true;
			this._dblClickHandler.doubleclick = this.mouseDblClick; 
			this.map.addEventListener(MouseEvent.CLICK, this.drawLine);
			this.map.addEventListener(MapEvent.ZOOM_END, this.updateZoom);
		}

		override protected function unregisterListeners():void{
			this._dblClickHandler.active = false;
			this.map.removeEventListener(MouseEvent.CLICK, this.drawLine);
			this.map.addEventListener(MapEvent.ZOOM_END, this.updateZoom);
		}

		public function mouseDblClick(event:MouseEvent):void {
			this.drawFinalPath();		
		} 
		
		/**
		 * Finish the LineString
		 */
		public function drawFinalPath():void{			
			newFeature = true;
			
			//clear the temporary line
			_drawContainer.graphics.clear();
			this.map.removeEventListener(MouseEvent.MOUSE_MOVE,temporaryLine);
			
			//Change style of finished path
			var style:Style = new Style();
			style.strokeColor = 0x60FFE9;
			
			//We finalize the last feature (of course, it's a lineString)
			var f:VectorFeature = drawLayer.features[drawLayer.features.length - 1];
			if(f!=null){
				//Apply the new style
				f.style = style;
				f.name = "path." + id.toString(); id++;
				drawLayer.redraw();
			}	
		}

		private function drawLine(event:MouseEvent=null):void{
			
			//we determine the point where the user clicked
			var pixel:Pixel = new Pixel(drawLayer.mouseX,drawLayer.mouseY );
			var lonlat:LonLat = this.map.getLonLatFromLayerPx(pixel);
			//manage the case where the layer projection is different from the map projection
			if(this.drawLayer.projection.srsCode!=this.map.projection.srsCode)
				lonlat.transform(this.map.projection,this.drawLayer.projection);
			var point:Point = new Point(lonlat.lon,lonlat.lat);
			//initialize the temporary line
			_startPoint = this.map.getMapPxFromLonLat(lonlat);
			
			//The user click for the first time
			if(newFeature){
				_lineString = new LineString([point]);
				lastPoint = point;
				
				var lineStyle:Style = new Style();
				lineStyle.strokeColor = 0x00ff00;
				
				var lineStringFeature:LineStringFeature = new LineStringFeature(_lineString, null, lineStyle);
				
				drawLayer.addFeature(lineStringFeature);
				
				newFeature = false;
				
				//draw the temporary line, update each time the mouse moves		
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
		/**
		 * Update the temporary line
		 */
		public function temporaryLine(evt:MouseEvent):void{
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
		
		private function updateZoom(evt:MapEvent):void{
			_drawContainer.graphics.clear();
			//we update the pixel of the last point which has changed
			var tempPoint:Point = _lineString.getLastPoint();
			_startPoint = this.map.getMapPxFromLonLat(new LonLat(tempPoint.x, tempPoint.y));
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
		
		public function get drawContainer():Sprite{
			return _drawContainer;
		}
		
		public function get startPoint():Pixel{
			return _startPoint;
		}
		public function set startPoint(pix:Pixel):void{
			_startPoint = pix;
		}
	}
}