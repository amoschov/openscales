package org.openscales.core.handler.sketch
{
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.feature.PointFeature;

	/**
	 * Handler to draw polygons.
	 */
	public class DrawPolygonHandler extends AbstractDrawHandler
	{
		private var _lring:LinearRing = null;
		private var _polygon:Polygon = null;
		private var _newFeature:Boolean = true;
		private var _dblClickHandler:ClickHandler = new ClickHandler();
		private var _firstPointRemoved:Boolean = false;

		private var id:Number = 0;


		public function DrawPolygonHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.VectorLayer=null)
		{
			super(map, active, drawLayer);
		}

		override protected function registerListeners():void{
			this._dblClickHandler.active = true;
			this._dblClickHandler.doubleclick = this.mouseDblClick;
			this.map.addEventListener(MouseEvent.CLICK, this.mouseClick);	
		}

		override protected function unregisterListeners():void{
			this._dblClickHandler.active = false;
			this.map.removeEventListener(MouseEvent.CLICK, this.mouseClick);
		}

		public function mouseClick(event:MouseEvent):void {

			if (drawLayer != null) {

				var name:String = "polygon."+id.toString(); id++;

				var pixel:Pixel = new Pixel(drawLayer.mouseX - this.map.layerContainer.x ,drawLayer.mouseY - this.map.layerContainer.y);
				var lonlat:LonLat = this.map.getLonLatFromLayerPx(pixel);
				var point:Point = new Point(lonlat.lon,lonlat.lat);

				if(newFeature) {					
					lring = new LinearRing([point]);
					polygon = new Polygon(lring);
					var polygonFeature:PolygonFeature = new PolygonFeature(polygon);

					// We create a point the first time to see were we have clicked
					var pointFeature:PointFeature = new PointFeature(point);
					pointFeature.name = id.toString();id++;

					drawLayer.addFeature(pointFeature);
					drawLayer.addFeature(polygonFeature);

					newFeature = false;
				}
				else {
					//When we have at least a 2 points polygon, we can remove the first point					
					if(!_firstPointRemoved && getQualifiedClassName(drawLayer.features[drawLayer.features.length-2].geometry) == "org.openscales.core.geometry::Point") {
						drawLayer.removeFeature(drawLayer.features[drawLayer.features.length-2]);
						_firstPointRemoved = true;
					}
					lring.addComponent(point);
					drawLayer.redraw();
				}
			}		
		}

		public function mouseDblClick(event:MouseEvent):void {
			drawFinalPoly();
		}

		public function drawFinalPoly():void{
			newFeature = true;

			//Change style of finished polygon
			var style:Style = new Style();
			style.fillColor = 0x60FFE9;
			style.strokeColor = 0x60FFE9;

			var feature:VectorFeature = drawLayer.features[drawLayer.features.length - 1];
			if(feature!=null){
				//Apply the new style
				feature.style = style;
				//drawLayer.clear();
				drawLayer.redraw(); 
			}		
		}

		override public function set map(value:Map):void {
			super.map = value;
			this._dblClickHandler.map = value;
		}

		//Getters and Setters

		public function get lring():LinearRing {
			return _lring;
		}

		public function set lring(lring:LinearRing):void {
			_lring = lring;
		}

		public function get polygon():Polygon {
			return _polygon;
		}

		public function set polygon(polygon:Polygon):void {
			_polygon = polygon;
		}

		public function get newFeature():Boolean {
			return _newFeature;
		}

		public function get firstPointRemoved():Boolean {
			return _firstPointRemoved;
		}

		public function set newFeature(value:Boolean):void {
			if (value == true) {
				_firstPointRemoved = false;
			}
			_newFeature = value;
		}

		public function get clickHandler():ClickHandler {
			return _dblClickHandler;
		}
	}
}

