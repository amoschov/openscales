package org.openscales.core.handler.sketch
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.MultiLineString;
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
		private var _multiLineString:MultiLineString=null;
		private var _lastPoint:Point = null;
		private var _newFeature:Boolean = true;
		private var _firstPointRemoved:Boolean = false;

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
			var point:Point = new Point(lonlat.lon,lonlat.lat);

			if(newFeature){			
				_multiLineString = new MultiLineString();
				var multiLineFeature:MultiLineStringFeature = new MultiLineStringFeature(_multiLineString);
				
				lastPoint = point;
				
				//add a pointFeature to show where we clicked
				var pointFeature:PointFeature = new PointFeature(point); 
				pointFeature.name = name;
				
				drawLayer.addFeature(pointFeature);								
				drawLayer.addFeature(multiLineFeature);
				
				newFeature = false;		
					
			}
			else {
				//When we have at least a 2 points path, we can remove the first point				
				if(!_firstPointRemoved && drawLayer.features[drawLayer.features.length-2] is PointFeature) {
					drawLayer.removeFeature(drawLayer.features[drawLayer.features.length-2]);
					_firstPointRemoved = true;
				}								
				if(!point.equals(lastPoint)){
					var points:Array = new Array(2);
					points.push(lastPoint, point);
					var lstring:LineString = new LineString(points);
					_multiLineString.addLineString(lstring); 
						
					drawLayer.redraw();
					lastPoint = point;
				}								
			}
		}

		override public function set map(value:Map):void {
			super.map = value;
			this._dblClickHandler.map = value;
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
				_firstPointRemoved = false;
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

