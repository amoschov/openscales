package org.openscales.core.feature {
	import flash.display.DisplayObject;
	
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.marker.DisplayObjectMarker;
	import org.openscales.core.style.marker.WellKnownMarker;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;

	/**
	 * Feature used to draw a Point geometry on FeatureLayer
	 */
	public class PointFeature extends Feature {
		//This attributes is use in features edition mode
		private var _isEditionFeature:Boolean = false;

		/**
		 * the geometry of the parent when the feature is an edition feature
		 **/
		private var _editionFeatureParentGeometry:Collection = null;

		//Start drag pixel
		private var _startdrag:Pixel = null;

		public function PointFeature(geom:Point=null, data:Object=null, style:Style=null, isEditionFeature:Boolean=false, editionFeatureParentGeometry:Collection=null) {
			//The point is none editable
			super(geom, data, style, false, isEditionFeature);
			
			this._isEditionFeature = isEditionFeature;
			if (editionFeatureParentGeometry != null && isEditionFeature)
				this._editionFeatureParentGeometry = editionFeatureParentGeometry;
			else {
				this._editionFeatureParentGeometry = null;
			}
		}
		
		override public function get lonlat():LonLat {
			var value:LonLat = null;
			if (this.point != null) {
				value=  new LonLat(this.point.x, this.point.y);
			}
			return value;
		}

		override public function destroy():void {
			this._editionFeatureParentGeometry = null;
			this._startdrag = null;
			super.destroy();
		}

		public function get point():Point {
			return this.geometry as Point;
		}

		override public function draw():void {
			var numChildren:Number = this.numChildren;
			for (var i:Number = 0; i < numChildren; i++) {

				this.removeChildAt(i);
			}
			super.draw();
		}

		override protected function executeDrawing(symbolizer:Symbolizer):void {

			var x:Number;
			var y:Number;
			var resolution:Number = this.layer.map.resolution
			var dX:int = -int(this.layer.map.layerContainer.x) + this.left;
			var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
			x = dX + point.x / resolution;
			y = dY - point.y / resolution;

			if (symbolizer is PointSymbolizer) {
				var pointSymbolizer:PointSymbolizer = (symbolizer as PointSymbolizer);
				if (pointSymbolizer.graphic) {
					if (pointSymbolizer.graphic is WellKnownMarker) {
						this.drawMark(pointSymbolizer.graphic as WellKnownMarker, x, y);
					} else if (pointSymbolizer.graphic is DisplayObjectMarker) {

						this.drawFlashGraphic(pointSymbolizer.graphic as DisplayObjectMarker, x, y);
					}
				}
			}
		}

		protected function drawFlashGraphic(marker:DisplayObjectMarker, x:Number, y:Number):void {

			var instance:DisplayObject = marker.instance;
			instance.x += x;
			instance.y += y;

			this.addChild(instance);
		}

		protected function drawMark(mark:WellKnownMarker, x:Number, y:Number):void {

			var x:Number;
			var y:Number;
			var resolution:Number = this.layer.map.resolution
			var dX:int = -int(this.layer.map.layerContainer.x) + this.left;
			var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
			x = dX + point.x / resolution;
			y = dY - point.y / resolution;

			mark.fill.configureGraphics(this.graphics);
			mark.stroke.configureGraphics(this.graphics);

			switch (mark.wellKnownName) {

				case WellKnownMarker.WKN_SQUARE:  {
					this.graphics.drawRect(x - (mark.size / 2), y - (mark.size / 2), mark.size, mark.size);
					break;
				}
				case WellKnownMarker.WKN_CIRCLE:  {
					this.graphics.drawCircle(x, y, mark.size / 2);
					break;
				}
				case WellKnownMarker.WKN_TRIANGLE:  {
					this.graphics.moveTo(x, y - (mark.size / 2));
					this.graphics.lineTo(x + mark.size / 2, y + mark.size / 2);
					this.graphics.lineTo(x - mark.size / 2, y + mark.size / 2);
					this.graphics.lineTo(x, y - (mark.size / 2));
					break;
				}
				// TODO : Implement other well known names and take into account opacity, rotation of the mark
			}
		}

		/**
		 * To obtain feature clone
		 * */
		override public function clone():Feature {
			var geometryClone:Geometry = this.geometry.clone();
			var PointFeatureClone:PointFeature = new PointFeature(geometryClone as Point, null, this.style);
			return PointFeatureClone;
		}

		/**
		 * the geometry of the parent when the feature is an edition feature
		 **/
		public function get editionFeatureParentGeometry():Collection {
			return this._editionFeatureParentGeometry;
		}

		public function set editionFeatureParentGeometry(value:Collection):void {
			this._editionFeatureParentGeometry = value;
		}

		/**
		 * To know the segment of the Collection the edition point belongs to
		 * @param point:geometry point to test
		 * @param detectionTolerance:Number
		 * @return the segment number
		 * */
		public function getSegmentsIntersection(collection:Collection, detectionTolerance:Number=8):int {

			var arrayResult:Array = new Array();
			var LineString1:LineString = null;
			var intersect:Boolean = false;
			var distanceArray:Array = new Array();
			if (collection != null) {
				for (var i:int = 0; i < collection.componentsLength - 1; i++) {
					var point1:Point = collection.componentByIndex(i) as Point;
					var point2:Point = collection.componentByIndex(i + 1) as Point;

					if (point1 != null && point2 != null) {
						var top:Number = Math.max(point1.y, point2.y);
						var right:Number = Math.max(point1.x, point2.x);
						var bottom:Number = Math.min(point1.y, point2.y);
						var left:Number = Math.min(point1.x, point2.x);
						if (point.y <= top && point.y >= bottom && point.x >= left && point.x <= right) {
							intersect = true;
						}
						if (intersect)
							arrayResult.push(new Array(new LineString(new Array(point1, point2)), i + 1));

					}
					intersect = false;
				}
			}
			//The last segment
			if ((collection.componentByIndex(0) as Point).x != (collection.componentByIndex(collection.componentsLength - 1) as Point).x || (collection.componentByIndex(0) as Point).y != (collection.componentByIndex(collection.componentsLength - 1) as Point).y) {
				point1 = collection.componentByIndex(0) as Point;
				point2 = collection.componentByIndex(collection.componentsLength - 1) as Point;

				if (point1 != null && point2 != null) {
					top = Math.max(point1.y, point2.y);
					right = Math.max(point1.x, point2.x);
					bottom = Math.min(point1.y, point2.y);
					left = Math.min(point1.x, point2.x);
					if (point.y <= top && point.y >= bottom && point.x >= left && point.x <= right) {
						intersect = true;
					}
					if (intersect)
						arrayResult.push(new Array(new LineString(new Array(point1, point2)), collection.componentsLength));

				}
			}
			distanceArray = new Array();
			for (var k:int = 0; k < arrayResult.length; k++) {
				//Scalar product to find the closest point with tolerance
				var pointA:Point = (arrayResult[k][0] as LineString).componentByIndex(0) as Point;
				var pointB:Point = (arrayResult[k][0] as LineString).componentByIndex(1) as Point;

				var pointPx:Pixel = this.layer.map.getLayerPxFromLonLat(new LonLat(point.x, point.y));

				var pointPxA:Pixel = this.layer.map.getLayerPxFromLonLat(new LonLat(pointA.x, pointA.y));

				var pointPxB:Pixel = this.layer.map.getLayerPxFromLonLat(new LonLat(pointB.x, pointB.y));

				pointPx = this.layer.map.getMapPxFromLayerPx(pointPx);
				pointPxA = this.layer.map.getMapPxFromLayerPx(pointPxA);
				pointPxB = this.layer.map.getMapPxFromLayerPx(pointPxB);



				var scalarPointAPointBPower:Number = Math.pow((pointPxA.x - pointPxB.x), 2) + Math.pow((pointPxA.y - pointPxB.y), 2);

				var scalarPointPointAPower:Number = Math.pow((pointPx.x - pointPxA.x), 2) + Math.pow((pointPxA.y - pointPx.y), 2);

				var scalarAHAB:Number = Math.pow((pointPx.x - pointPxA.x) * (pointPxB.x - pointPxA.x) + (pointPx.y - pointPxA.y) * (pointPxB.y - pointPxA.y), 2);

				var scalarPointPointBPower:Number = Math.pow((pointPx.x - pointPxB.x), 2) + Math.pow((pointPxB.y - pointPx.y), 2);

				var distance:Number = Math.pow((scalarPointPointAPower - scalarAHAB / scalarPointAPointBPower), 1 / 2);

				if (distance < detectionTolerance) {
					distanceArray.push(new Array(distance, arrayResult[k][1]));
				}
			}
			if (distanceArray.length > 1) {
				distanceArray.sort();
				return distanceArray[0][1];
			} else if (distanceArray.length == 1)
				return distanceArray[0][1];
			return -1;
		}
	}
}

