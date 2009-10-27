package org.openscales.core.feature
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
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
		private var _IsEditionFeature:Boolean=false;
		
		/**
		 * the geometry of the parent when the feature is an edition feature  
		 **/
		private var _editionFeatureParentGeometry:Collection=null;
		
		//Start drag pixel
		private var _startdrag:Pixel=null;
		
		public function PointFeature(geom:Point=null, data:Object=null, style:Style=null,isEditionFeature:Boolean=false,editionFeatureParentGeometry:Collection=null) 
		{
			//The point is none editable
			super(geom, data, style,false,isEditionFeature);
			if (geom!=null) {
				this.lonlat = new LonLat(this.point.x,this.point.y);
			}
			this._IsEditionFeature=isEditionFeature;
			if(editionFeatureParentGeometry!=null && isEditionFeature) this._editionFeatureParentGeometry=editionFeatureParentGeometry;
			else 
			{
				Trace.error("editionFeatureParentGeometry is reserved for Temporary point");
				this._editionFeatureParentGeometry=null;
			}
		}
		
		override public function registerListeners():void{	
			super.registerListeners()	
			if(this._IsEditionFeature){
				this.addEventListener(MouseEvent.MOUSE_DOWN, this.EditMouseDown);
				this.addEventListener(MouseEvent.MOUSE_UP, this.EditMouseUp);
				//The edition point don"t launch event when it's over by the mouse
				this.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);	
			}
		}
		override public function unregisterListeners():void{
			super.unregisterListeners();
			if(this._IsEditionFeature){
				this.removeEventListener(MouseEvent.MOUSE_DOWN, this.EditMouseDown);
				this.removeEventListener(MouseEvent.MOUSE_UP, this.EditMouseUp);
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
		//EDITION MODE
		
		public function EditMouseDown(evt:MouseEvent):void{
			
				this.buttonMode=true;
				this.startDrag();
				if(this._IsEditionFeature)this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.EDITION_POINT_FEATURE_DRAG_START,this));
		}
		
		public function EditMouseUp(evt:MouseEvent):void{		
			this.buttonMode=false;
			this.stopDrag();
			if(this._IsEditionFeature)this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.EDITION_POINT_FEATURE_DRAG_STOP,this));
		}
		
		public function doubleclick():void{
			var a:String="bob";
		}
		
		
		//END FEATURE Edition Mode
		/**
		 * To obtain feature clone 
		 * */
		override public function clone():Feature{
			var geometryClone:Geometry=this.geometry.clone();
			var PointFeatureClone:PointFeature=new PointFeature(geometryClone as Point,null,this.style,this.isEditionFeature);
			return PointFeatureClone;	
		}	
		 /**
		 * the geometry of the parent when the feature is an edition feature  
		 **/
		public function get editionFeatureParentGeometry():Collection{
			return this._editionFeatureParentGeometry;
		}
		
		
		/**
		 * To know the segment of the Collection the edition point belongs to
		 * @param point:geometry point to test 
		 * @return the segment number
		 * */
		public function getSegmentsIntersection(collection:Collection):int{	
			//We have to improve this algorithm, because we just use  line equation
				var distance:Array=new Array();
				var node:Number=-1;
				var index:Number=0;
				var pointPX:Pixel=this.layer.map.getLayerPxFromLonLat(new LonLat(point.x,point.y));
				for(var j:int=0;j<collection.componentsLength;j++){
					var px:Pixel=null;
					var px2:Pixel=null;
					 index=j+1;
					//For the Ring
					if(j==collection.componentsLength-1)
					{
						px=this.layer.map.getLayerPxFromLonLat(new LonLat((collection.componentByIndex(0) as Point).x,(collection.componentByIndex(0) as Point).y));
						px2=this.layer.map.getLayerPxFromLonLat(new LonLat((collection.componentByIndex(j) as Point).x,(collection.componentByIndex(j) as Point).y));
						index=0;
					} 
					else
					{
					 	px=this.layer.map.getLayerPxFromLonLat(new LonLat((collection.componentByIndex(j) as Point).x,(collection.componentByIndex(j) as Point).y));
					 	px2=this.layer.map.getLayerPxFromLonLat(new LonLat((collection.componentByIndex(j+1) as Point).x,(collection.componentByIndex(j+1) as Point).y));
					}
					var x1:Number=px.x;
					var x2:Number=px2.x;
					var y1:Number=px.y;
					var y2:Number=px2.y;
						//Line equation
					var coeffdir:Number=(y1-y2)/(x1-x2);
					var b:Number=y2+x2*(y2-y1)/(x1-x2);
					distance.push(new Array(Math.floor(Math.abs(coeffdir*pointPX.x+b-pointPX.y)),index));
				}
			 index=0;
			for(var i:int=0;i<distance.length;i++){
				if(i==0)
				{
					node=distance[i][1];
					index=i;
				}
				else
				{
					if(distance[index][0]>distance[i][0])
					{
						index=i;
						node=distance[i][1];
					}
				}
			}
			return node;
		}
	}
}

