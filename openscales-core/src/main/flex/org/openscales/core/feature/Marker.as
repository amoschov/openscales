package org.openscales.core.feature {
	import flash.display.Bitmap;
	
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Symbolizer;

	/**
	 * A Marker is an graphical element localized by a LonLat
	 *
	 * As Marker extends Feature, markers are generally added to FeatureLayer
	 */
	public class Marker extends PointFeature {
		/**
		 * Marker constructor
		 */
		public function Marker(geom:Point=null, data:Object=null, style:Style=null,isEditable:Boolean=false,isEditionFeature:Boolean=false,editionFeatureParentGeometry:Collection=null) {
			super(geom, data, style,isEditable,isEditionFeature,editionFeatureParentGeometry);
		}

		/**
		 * Boolean used to know if that marker has been draw. This is used to draw markers only
		 *  when all the map and layer stuff are ready
		 */
		private var _drawn:Boolean = false;
		
		/**
		 * The image that will be drawn at the feature localization
		 */
		[Embed(source="/images/marker-blue.png")]
		private var _image:Class;

		/**
		 * Draw the marker
		 */
		override protected function executeDrawing(symbolizer:Symbolizer):void {
			
			if (!this._drawn) {
				// Eventually remove old stuff
				while (this.numChildren>0) {
					this.removeChildAt(0);
				}
				this.addChild(new this._image());
				this._drawn=true;
			}
			var marker:Bitmap = this.getChildAt(0) as Bitmap;
			if(marker != null) {
				
				var x:Number; 
	            var y:Number;
	            var resolution:Number = this.layer.map.resolution 
	            var dX:int = -int(this.layer.map.layerContainer.x) + this.left; 
	            var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
	            x = dX + point.x / resolution; 
                y = dY - point.y / resolution;
                
				this.x = x - marker.width / 2;
				this.y = y - marker.height / 2;
			} else {
				trace("No marker found !");
			}
				
		}
		
		
		public function get image():Class {
			return this._image;
		}

		public function set image(value:Class):void {
			this._image=value;
			this._drawn = false;
			
		}
		/**
		 * To obtain feature clone 
		 * */
		override public function clone():Feature{
			var geometryClone:Geometry=this.geometry.clone();
			var MarkerClone:Marker=new Marker(geometryClone as Point,null,this.style,this.isEditable,this.isEditionFeature,this.editionFeatureParentGeometry);
			return MarkerClone;
			
		}	
	}
}

