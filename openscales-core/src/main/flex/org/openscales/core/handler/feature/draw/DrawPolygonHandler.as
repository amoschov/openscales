package org.openscales.core.handler.feature.draw
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.style.Style;

	/**
	 * This handler manage the function draw of the polygon.
	 * Active this handler to draw a polygon.
	 */
	public class DrawPolygonHandler extends AbstractDrawHandler
	{
		/**
		 * polygon feature which is currently drawn
		 * */
		 
		 private var _polygonFeature:PolygonFeature=null;
		
		/**
		 * @private
		 **/
		
		private var _firstPointFeature:PointFeature=null;
		
		/**
		 *  @private 
		 * */
		private var _newFeature:Boolean = true;
		
		/**
		 *@private
		 */
		private var _dblClickHandler:ClickHandler = new ClickHandler();
		
		/**
		 * As we draw a first point to know where we started the polygon
		 */
		private var _firstPointRemoved:Boolean = false;
		
		/**
		 * Single id of the polygon
		 */
		private var id:Number = 0;
		
		/**
		 * The Sprite used for drawing the temporary line
		 */
		private var _drawContainer:Sprite = new Sprite();
		/**
		 * position of the first point drawn
		 * */
		private var _firstPointPixel:Pixel=null;
		/**
		 * position of the last point drawn
		 * */
		private var _lastPointPixel:Pixel=null;

		/**
		 * Constructor of the polygon handler
		 * 
		 * @param map the map reference
		 * @param active determine if the handler is active or not
		 * @param drawLayer The layer on which we'll draw
		 */
		public function DrawPolygonHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.FeatureLayer=null)
		{
			super(map, active, drawLayer);
		}

		override protected function registerListeners():void{
			this._dblClickHandler.active = true;
			this._dblClickHandler.doubleClick = this.mouseDblClick;
			if (this.map) {
				this.map.addEventListener(MouseEvent.CLICK, this.mouseClick);	
			}
		}

		override protected function unregisterListeners():void{
			this._dblClickHandler.active = false;
			if (this.map) {
				this.map.removeEventListener(MouseEvent.CLICK, this.mouseClick);
			}
		}
		
		protected function mouseClick(event:MouseEvent):void {

			if (drawLayer != null) {

				var name:String = "polygon."+id.toString(); id++;
				_drawContainer.graphics.clear();
				//we determine the point where the user clicked
				var pixel:Pixel = new Pixel(map.mouseX ,map.mouseY);
				this._lastPointPixel= new Pixel(map.mouseX ,map.mouseY);
				var lonlat:LonLat = this.map.getLonLatFromMapPx(pixel);
                var point:Point = new Point(lonlat.lon,lonlat.lat);
				var lring:LinearRing=null;
				var polygon:Polygon=null;
				//2 cases, and very different. If the user starts the polygon or if the user is drawing the polygon
				if(newFeature) {					
					 lring = new LinearRing([point]);
					 polygon = new Polygon([lring]);
					this._firstPointPixel= new Pixel(map.mouseX ,map.mouseY);
				
					
					this._polygonFeature=new PolygonFeature(polygon,null,null,true);
					
					
					//this._polygonFeature=new PolygonFeature(				
					this._polygonFeature.style = Style.getDrawSurfaceStyle();

					// We create a point the first time to see were the user clicked
					this._firstPointFeature=  new PointFeature(point,null,Style.getDefaultPointStyle());
					
					//add the point feature to the drawLayer, and the polygon (which contains only one point for the moment)
					drawLayer.addFeature(this._firstPointFeature);
					drawLayer.addFeature(this._polygonFeature);
					this._polygonFeature.unregisterListeners();
					this._firstPointFeature.unregisterListeners();

					newFeature = false;
					
					this.map.addEventListener(MouseEvent.MOUSE_MOVE,drawTemporaryPolygon);
				}
				else {
					if(this._firstPointFeature!=null){
						drawLayer.removeFeature(this._firstPointFeature);
						this._firstPointFeature=null;
					}
					//add the point to the linearRing
					 lring=(this._polygonFeature.geometry as Polygon).componentByIndex(0) as LinearRing;
					lring.addComponent(point);
				}
				//final redraw layer
				drawLayer.redraw();
				
			}		
		}

		public function mouseDblClick(LastPX:Pixel):void {
			drawFinalPoly();
		}
		
		
		public function drawTemporaryPolygon(event:MouseEvent=null):void{
			//position of the last point drawn
			
			_drawContainer.graphics.clear();
			_drawContainer.graphics.beginFill(0x00ff00,0.5);
			_drawContainer.graphics.lineStyle(2, 0x00ff00);		
			_drawContainer.graphics.moveTo(map.mouseX, map.mouseY);
			_drawContainer.graphics.lineTo(this._firstPointPixel.x, this._firstPointPixel.y);
			_drawContainer.graphics.moveTo(map.mouseX, map.mouseY);
			_drawContainer.graphics.lineTo(this._lastPointPixel.x, this._lastPointPixel.y);	
			_drawContainer.graphics.endFill();
		}
		/**
		 * Finish the polygon
		 */
		public function drawFinalPoly():void{
			//Change style of finished polygon
			var style:Style = Style.getDefaultSurfaceStyle();
			_drawContainer.graphics.clear();
			//We finalize the last feature (of course, it's a polygon)
			//var feature:Feature = drawLayer.features[drawLayer.features.length - 1];
			
			if(this._polygonFeature!=null){
				//the user just drew one point, it's not a real polygon so we delete it 
				
				(drawLayer as FeatureLayer).removeFeature(this._firstPointFeature);
				//Check if the polygon (in fact, the linearRing) contains at least 3 points (if not, it's not a polygon)
				if((this._polygonFeature.polygon.componentByIndex(0) as LinearRing).componentsLength>2){
					//Apply the "finished" style
					this._polygonFeature.style = style;	
					this._polygonFeature.registerListeners();				
				}
				else{
					drawLayer.removeFeature(this._polygonFeature);
				}
				drawLayer.redraw();
			}
			//the polygon is finished
			newFeature = true;
			//remove listener for temporaries polygons
			this.map.removeEventListener(MouseEvent.MOUSE_MOVE,drawTemporaryPolygon); 
		}

		override public function set map(value:Map):void {
			super.map = value;
			this._dblClickHandler.map = value;
			if(map!=null) map.addChild(_drawContainer);
		}

		//Getters and Setters

		/**
		 * @private
		 * */
		public function set newFeature(value:Boolean):void {
			_newFeature = value;
		}
		/**
		 * To know if we create a new feature, or if some points are already added
		 */
		public function get newFeature():Boolean {
			return _newFeature;
		}
		
		/**
		 *this attribute is used to see a point the first time 
		 * the user clicks 
		 **/
		public function get firstPointRemoved():Boolean {
			return _firstPointRemoved;
		}
		/**
		 * Handler which manage the doubleClick, to finalize the polygon
		 */
		public function get clickHandler():ClickHandler {
			return _dblClickHandler;
		}
	}
}

