package org.openscales.core.feature
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Mark;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;
	/**
	 * Feature used to draw a Point geometry on FeatureLayer
	 */
	public class PointFeature extends VectorFeature
	{
		//This attributes is use in features edition mode
		private var IsTemporary:Boolean=false;
		
		public function PointFeature(geom:Point=null, data:Object=null, style:Style=null,isEditable:Boolean=false,isEditionFeature:Boolean=false,editionFeatureParentGeometry:Collection=null) 
		{
			super(geom, data, style,isEditable,isEditionFeature,editionFeatureParentGeometry);
			if (geom!=null) {
				this.lonlat = new LonLat(this.point.x,this.point.y);
			}
		}
		
		override public function registerListeners():void{		
			if(this.IsTemporary){
				this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				this.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
			}
		}
		override public function unregisterListeners():void{
			if(this.IsTemporary){
				this.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				this.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
			}
		}
		
		public function get point():Point {
			return this.geometry as Point;
		}
		
		override protected function executeDrawing(symbolizer:Symbolizer):void {
			
			if(symbolizer is PointSymbolizer){
				
				var pointSymbolizer:PointSymbolizer = (symbolizer as PointSymbolizer);
				if(pointSymbolizer.graphic){
					if(pointSymbolizer.graphic is Mark){
						
						this.drawMark(pointSymbolizer.graphic as Mark);
					}
				}
			}
			
		}
		
		protected function drawMark(mark:Mark):void{
			
			trace("Drawing mark");
			this.configureGraphicsFill(mark.fill);
			this.configureGraphicsStroke(mark.stroke);
			
			
			var x:Number; 
            var y:Number;
            var resolution:Number = this.layer.map.resolution 
            var dX:int = -int(this.layer.map.layerContainer.x) + this.left; 
            var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
			x = dX + point.x / resolution; 
            y = dY - point.y / resolution;
			
			switch(mark.wellKnownName){
				
				case Mark.WKN_SQUARE:{
					this.graphics.drawRect(x-(mark.size/2), y-(mark.size/2),mark.size,mark.size);
					break;
				}
				case Mark.WKN_CIRCLE:{
					this.graphics.drawCircle(x,y,mark.size/2);
					break;
				}
				case Mark.WKN_TRIANGLE:{
					this.graphics.moveTo(x,y-(mark.size/2));
					this.graphics.lineTo(x+mark.size/2,y+mark.size/2);
					this.graphics.lineTo(x-mark.size/2,y+mark.size/2);
					this.graphics.lineTo(x,y-(mark.size/2));
					break;
				}
				// TODO : Implement other well known names and take into account opacity, rotation of the mark
			}
		}
		/**
		 * To obtain feature clone 
		 * */
		override public function clone():Feature{
			var geometryClone:Geometry=this.geometry.clone();
			var PointFeatureClone:PointFeature=new PointFeature(geometryClone as Point,null,this.style,this.isEditable,this.isEditionFeature,this.editionFeatureParentGeometry);
			return PointFeatureClone;
			
		}		
	}
}

