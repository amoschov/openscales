package org.openscales.core.handler.sketch
{
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.SelectBoxEvent;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.feature.VectorFeature;
	
	/**
	 * Handler to draw paths (multi line strings)
	 */
	public class DrawPathHandler extends AbstractDrawHandler
	{		
		// The layer in which we'll draw
		private var _drawLayer:org.openscales.core.layer.VectorLayer = null;				
		private var _id:Number = 0;
		private var _lastPoint:Point = null;
		private var _newFeature:Boolean = true;
		
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
			this._dblClickHandler.doubleclick = this.mouseDblClick;
			this.map.addEventListener(MouseEvent.CLICK, this.mouseClick); 
		}
		
		override protected function unregisterListeners():void{
        	this.map.removeEventListener(MouseEvent.CLICK, this.mouseClick);
        	this._dblClickHandler.active = false;
		}
		
		public function mouseClick(event:MouseEvent):void {	 					
			this.drawLine();						
		}
		
		 public function mouseDblClick(event:MouseEvent):void {
			this.drawFinalPath();
		} 
		
		private function drawLine():void{
			var feature:VectorFeature = new VectorFeature(); 
			feature.name = "path." + id.toString(); id++;
			
			var pixel:Pixel = new Pixel(drawLayer.mouseX,drawLayer.mouseY);
			var lonlat:LonLat = this.map.getLonLatFromLayerPx(pixel);
			var point:Point = new Point(lonlat.lon,lonlat.lat);
			
			if(newFeature){				
				lastPoint = point;
				feature.geometry = point;
				drawLayer.addFeatures(feature);
				newFeature = false;				
			}
			else {
				//When we have at least a 2 points path, we can remove the first point				
				if(getQualifiedClassName(drawLayer.features[drawLayer.features.length-1].geometry) == "org.openscales.core.geometry::Point") {
					drawLayer.removeFeatures(drawLayer.features[drawLayer.features.length-1]);
				}								
				drawLayer.renderer.clear();
				var points:Array = new Array(2);
				points.push(lastPoint, point);
				var lstring:LineString = new LineString(points);
				feature.geometry = lstring;
				drawLayer.addFeatures(feature);
				drawLayer.redraw();
				lastPoint = point;
			}
		}
		
		public function drawFinalPath():void{
			newFeature = true;
				
			//Change style of finished path
			var style:Style = new Style();
			style.strokeColor = 0x60FFE9;
			
			var lstrings:Array = [];
			var featuresToRemove:Array = [];
			
			for each (var feature:VectorFeature in drawLayer.features) {
				if (getQualifiedClassName(feature.geometry) == "org.openscales.core.geometry::LineString") {
					featuresToRemove.push(feature);
					lstrings.push(feature.geometry);
				}
			}
			
			//We create a MultiLineString with several LineStrings (if there are line strings)
			if (lstrings.length > 0) {
				var mlString:MultiLineString = new MultiLineString(lstrings);
				var mlFeature:VectorFeature = new VectorFeature();
				mlFeature.name = "path." + id.toString(); id++;
				mlFeature.style = style;
				mlFeature.geometry = mlString;
				
				drawLayer.removeFeatures(featuresToRemove);
				drawLayer.addFeatures(mlFeature);
				
				drawLayer.renderer.clear();
				drawLayer.redraw();
			}
			
		}
		
		public function featureSelectedBox(event:SelectBoxEvent):void {
            	
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