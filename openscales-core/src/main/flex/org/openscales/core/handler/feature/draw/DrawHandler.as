package org.openscales.core.handler.feature.draw
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openscales.core.Map;
	import org.openscales.basetypes.LonLat;
	import org.openscales.basetypes.Pixel;
	import org.openscales.core.events.DrawingEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.handler.feature.SelectFeaturesHandler;
	import org.openscales.core.handler.mouse.DragHandler;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.layer.Layer;
	import org.openscales.geometry.LinearRing;
	import org.openscales.geometry.Point;

	public class DrawHandler extends Handler
	{
		
		/**
		 * Selection mode
		 */
		public static const DRAG_MODE:int = 0;
		public static const SELECT_MODE:int = 1;
		public static const DRAW_POINT_MODE:int = 2;
		public static const DRAW_PATH_MODE:int = 3;
		public static const DRAW_POLYGON_MODE:int = 4;
		public static const EDIT_MODE:int = 5;		
		/**
		 * Type of drawing (point, path or polygon)
		 */
		public var drawType:String = "";
		
			
		/**
		 * Layer of drawing, which contains all drawing features
		 */
		private var _drawLayer:FeatureLayer = null;
		
		public var dragHandler:DragHandler = new DragHandler();

		/**
		 * Handler of PointFeature
		 */
		public var pointHandler:DrawPointHandler = new DrawPointHandler(null, false, drawLayer);

		/**
		 * Handler of PolygonFeature
		 */
		public var polygonHandler:DrawPolygonHandler = new DrawPolygonHandler(null, false, drawLayer);

		/**
		 * Handler of PathFeature
		 */
		public var pathHandler:DrawPathHandler = new DrawPathHandler(null, false, drawLayer);
		/**
		 * Edition Handler
		 * */
		public var editionHandler:FeatureLayerEditionHandler = new FeatureLayerEditionHandler(null, drawLayer, false, true, true, true);

		/**
		 * Handler of MultiFeature
		 */
		public var multiFeaturesHandler:DrawMultiHandler = new DrawMultiHandler(null, false, drawLayer);

		/**
		 * Dragging state
		 */
		public var isDragging:Boolean = false; //To know if the feature is dragging

		/**
		 * Mouse handlers
		 */
		public var selectFeaturesHandler:SelectFeaturesHandler; //to select features
		
				
		public function DrawHandler(map:Map=null, active:Boolean=false, drawLayer:FeatureLayer=null)
		{
			super(map, active);
			
			if(drawLayer) {
				this.drawLayer = drawLayer;
			} else {
				this.drawLayer = new FeatureLayer("Drawings");
			}
		}
				
		private function onSelectionUpdated(selectedFeatures:Array):void {
		
		}
		
		private function deleteAllFeatures():void {
			// clear the selected features
			deleteSelectedFeatures();
			// clear the unselected features
			drawLayer.clear();
			// clear the temporary line
			pathHandler.drawContainer.graphics.clear();
			// remove the listener which draw temporary line
			pathHandler.map.removeEventListener(MouseEvent.MOUSE_MOVE, pathHandler.temporaryLine);
			// reset feature handler
			switch (drawType) {
				case "path":  {
					pathHandler.newFeature = true;
					break;
				}
				case "polygon":  {
					polygonHandler.newFeature = true;
					break;
				}
			}
		}
		
		/**
		 * User clicks on delete selected feature button
		 */
		public function deleteSelectedFeatures():void {
			var featuresToDelete:Vector.<Feature> = this.selectFeaturesHandler.selectedFeatures;
			this.selectFeaturesHandler.clearSelection();
			this.drawLayer.removeFeatures(featuresToDelete);
		}
		
		override public function set map(value:Map):void {
			super.map = value;
			if (this.map != null) {
				
				this.selectFeaturesHandler = new SelectFeaturesHandler(this.map, false);
				this.selectFeaturesHandler.onSelectionUpdated = this.onSelectionUpdated;
				this.map.addLayer(drawLayer);
				
				this.selectFeaturesHandler.layers = new Vector.<Layer>();
				this.selectFeaturesHandler.layers.push(drawLayer);
				
				//Properties of MultiHandler
				this.multiFeaturesHandler.map = value;
				this.pointHandler.map = value;
				this.pathHandler.map = value;
				this.polygonHandler.map = value;
				this.editionHandler.map = value;
				this.selectFeaturesHandler.map = value;
				this.dragHandler.map = value;
				
				
			}
		}
		
		/**
		 * Finish a polygon
		 * Force to finalyse a polygon (even it's not finished)
		 */
		public function finishPolygon():void {
			polygonHandler.drawFinalPoly();
			polygonHandler.active = false;
		}

		/**
		 * Finish a path
		 * Force to finalyse a path (event it's not finished)
		 */
		public function finishPath():void {
			pathHandler.drawFinalPath();
			pathHandler.active = false;
		}
			
		public function set mode(mode:int):void {
				switch (mode) {
					case 0:
						selectFeaturesHandler.active = false;
						pointHandler.active = false;
						dragHandler.active = true;
						if (pathHandler.active) {
							this.finishPath();
						} else if (polygonHandler.active) {
							this.finishPolygon();
						}
						drawType = "";
						editionHandler.active = false;
						this.map.dispatchEvent(new DrawingEvent(DrawingEvent.DISABLED));
						break;
					case 1:
						selectFeaturesHandler.active = true;
						pointHandler.active = false;
						if (pathHandler.active) {
							this.finishPath();
						} else if (polygonHandler.active) {
							this.finishPolygon();
						}
						drawType = "";
						dragHandler.active = false;
						editionHandler.active = false;
						this.map.dispatchEvent(new DrawingEvent(DrawingEvent.DISABLED));
						break;

					case 2: //click on button point
						if (drawType != "point") {
							if (pathHandler.active) {
								this.finishPath();
							} else if (polygonHandler.active) {
								this.finishPolygon();
							}
							pointHandler.active = true;
							drawType = "point";
						}
						dragHandler.active = false;
						selectFeaturesHandler.active = false;
						editionHandler.active = false;
						this.map.dispatchEvent(new DrawingEvent(DrawingEvent.ENABLED));
						break;

					case 3: //click on button path
						if (drawType != "path") {
							if (polygonHandler.active) {
								this.finishPolygon();
							}
							pointHandler.active = false;
							pathHandler.active = true;
							editionHandler.active = false;
							drawType = "path";
						}
						dragHandler.active = false;
						selectFeaturesHandler.active = false;
						editionHandler.active = false;
						this.map.dispatchEvent(new DrawingEvent(DrawingEvent.ENABLED));
						break;

					case 4: //click on button polygon
						if (drawType != "polygon") {
							if (pathHandler.active) {
								this.finishPath();
							}
							pointHandler.active = false;
							polygonHandler.active = true;
							editionHandler.active = false;
							drawType = "polygon";
						}
						dragHandler.active = false;
						selectFeaturesHandler.active = false;
						this.map.dispatchEvent(new DrawingEvent(DrawingEvent.ENABLED));
						break;
					case 5:
						if (drawType != "") {
							if (pathHandler.active)
								this.finishPath();
							else if (polygonHandler.active)
								this.finishPolygon();
						}
						editionHandler.active = true;
						dragHandler.active = false;
						selectFeaturesHandler.active = false;
						polygonHandler.active = false;
						pointHandler.active = false;
						pathHandler.active = false;
						drawType = "";
						dragHandler.active = false;
						break;
				}
			}
			
			/**
			 * User clicks on delete last feature button
			 */
			public function onDeleteLastClick(event:Event):void {
				var last:Number = drawLayer.features.length - 1;
				if(last == -1) return;
				
				var lastFeature:Feature = null;
                var pointToDelete:org.openscales.geometry.Point;

				if (drawType == "") {
					drawLayer.removeFeature(drawLayer.features[last]);
				} else if (drawType == "point") {
					drawLayer.removeFeature(drawLayer.features[last]);
				} else if (drawType == "path") {
					//case the last feature is a LineString			
					if (last >= 0 && drawLayer.features[last] is LineStringFeature) {
						// we check if the lineString contain more than 2 points. If not, we delete the feature
						if ((drawLayer.features[last] as LineStringFeature).lineString.componentsLength > 2) {
							pointToDelete = (drawLayer.features[last] as LineStringFeature).lineString.getLastPoint();
							(drawLayer.features[last] as LineStringFeature).lineString.removePoint(pointToDelete);
							pathHandler.lastPoint = (drawLayer.features[last] as LineStringFeature).lineString.getLastPoint();

							//update the starting point of the temporary line
							var pix:Pixel = pathHandler.map.getMapPxFromLonLat(new LonLat(pathHandler.lastPoint.x, pathHandler.lastPoint.y));
							pathHandler.startPoint = pix;
						} else {
							drawLayer.removeFeature(drawLayer.features[last]);
							pathHandler.newFeature = true;
							//remove the listener which draw temporary line
							pathHandler.map.removeEventListener(MouseEvent.MOUSE_MOVE, pathHandler.temporaryLine);
						}
						// clear the temporary line
						pathHandler.drawContainer.graphics.clear();
					} else {
						drawLayer.removeFeature(drawLayer.features[last]);
					}
				} else if (drawType == "polygon") {
					if (last >= 0 && drawLayer.features[last] is PolygonFeature) {
						// we check if the polygon contain more than 2 points. If not, we delete the feature									
						if (((drawLayer.features[last] as PolygonFeature).polygon.componentByIndex(0) as LinearRing).componentsLength > 2) {
							var lineRing:LinearRing = ((drawLayer.features[last] as PolygonFeature).polygon.componentByIndex(0) as LinearRing);
							pointToDelete = lineRing.getLastPoint();
							lineRing.removeComponent(pointToDelete);
						} else {
							drawLayer.removeFeature(drawLayer.features[last]);
							polygonHandler.newFeature = true;
						}
					} else {
						drawLayer.removeFeature(drawLayer.features[last]);
					}
				}
				drawLayer.redraw();
			}
			
			public function set drawLayer(value:FeatureLayer):void {
				this._drawLayer = value;
				this.pointHandler.drawLayer = value;
				this.polygonHandler.drawLayer = value;
				this.pathHandler.drawLayer = value;
				this.editionHandler.layerToEdit = value;
				this.multiFeaturesHandler.drawLayer = value;
			}
			
			public function get drawLayer():FeatureLayer {
				return this._drawLayer;
			}
	}
	
}