package org.openscales.core.handler.sketch
{
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.layer.VectorLayer;
	
	public class DrawPathHandler extends Handler
	{		
		// The layer in which we'll draw
		private var _drawLayer:org.openscales.core.layer.VectorLayer = null;				
		private var _id:Number = 0;
		private var _lastPoint:Point = null;
		private var _newFeature:Boolean = true;
		private var _nbPaths:Number = 0;
		
		private var _dblClickHandler:ClickHandler = new ClickHandler();
				
		public function DrawPathHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.VectorLayer=null)
		{
			super(map, active);
			this.drawLayer = drawLayer;
		}
		override protected function registerListeners():void{
			this._dblClickHandler.active = true;
			this._dblClickHandler.doubleclick = this.mouseDblClick;
			this.map.addEventListener(MouseEvent.CLICK, this.mouseClick); 
			/* this.map.addEventListener(MouseEvent.DOUBLE_CLICK, this.mouseDoubleClick); */
		}
		
		override protected function unregisterListeners():void{
        	this.map.removeEventListener(MouseEvent.CLICK, this.mouseClick);
        	this._dblClickHandler.active = false;
		}
		
		public function mouseClick(event:MouseEvent):void {	 					
			
			var feature:org.openscales.core.feature.VectorFeature;
			feature = new org.openscales.core.feature.VectorFeature();
			feature.id = "path." + id.toString(); id++;
			
			var pixel:Pixel = new Pixel(drawLayer.mouseX,drawLayer.mouseY);
			var lonlat:LonLat = this.map.getLonLatFromLayerPx(pixel);
			var point:Point = new Point(lonlat.lon,lonlat.lat);
			
			if(newFeature){				
				_lastPoint = point;
				feature.geometry = point;
				drawLayer.addFeatures(feature);
				newFeature = false;			
			}
			else {
				//When we have at least a 2 points path, we can remove the first point
				var featuresToRemove:Array = [];
				
				for each (var feat:VectorFeature in drawLayer.features) {
					if(getQualifiedClassName(feat.geometry) == "org.openscales.core.geometry::Point") {
						featuresToRemove.push(feat);
					}
				}
				drawLayer.removeFeatures(featuresToRemove);
				drawLayer.renderer.clear();
				var points:Array = new Array(2);
				points.push(_lastPoint, point);
				var lstring:LineString = new LineString(points);
				feature.geometry = lstring;
				drawLayer.addFeatures(feature);
				drawLayer.redraw();
				_lastPoint = point;
			}							
		}
		
		 public function mouseDblClick(event:MouseEvent):void {
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
			
			//We create a MultiLineString with several LineStrings
			var mlString:MultiLineString = new MultiLineString(lstrings);
			var mlFeature:VectorFeature = new VectorFeature();
			mlFeature.id = "path." + id.toString(); id++;
			mlFeature.style = style;
			mlFeature.geometry = mlString;
			
			drawLayer.removeFeatures(featuresToRemove);
			drawLayer.addFeatures(mlFeature);
			
			drawLayer.renderer.clear();
			drawLayer.redraw();
		} 
		
		override public function set map(value:Map):void {
			super.map = value;
			this._dblClickHandler.map = value;
		}
		
		public function get drawLayer():org.openscales.core.layer.VectorLayer {
			return _drawLayer;
		}
		public function set drawLayer(drawLayer:org.openscales.core.layer.VectorLayer):void {
			_drawLayer = drawLayer;
		}
		
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
				_nbPaths++;
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