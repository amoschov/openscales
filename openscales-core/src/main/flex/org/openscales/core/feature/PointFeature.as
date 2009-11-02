package org.openscales.core.feature
{
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LineString;
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
			var PointFeatureClone:PointFeature=new PointFeature(geometryClone as Point,null,this.style,this.isEditionFeature);
			return PointFeatureClone;	
		}	
		 /**
		 * the geometry of the parent when the feature is an edition feature  
		 **/
		public function get editionFeatureParentGeometry():Collection{
			return this._editionFeatureParentGeometry;
		}
		
		public function set editionFeatureParentGeometry(value:Collection):void{
			this._editionFeatureParentGeometry=value;
		}
		
		/**
		 * To know the segment of the Collection the edition point belongs to
		 * @param point:geometry point to test 
		 * @return the segment number
		 * */
		public function getSegmentsIntersection(collection:Collection):int{	
			
			var arrayResult:Array=new Array();
			var tolerance:Number=3;	
			var LineString1:LineString=null;
			var intersect:Boolean=true;
			var distanceArray:Array=new Array();
			if(collection!=null){
				for(var i:int=0;i<collection.componentsLength-1;i++){		
					LineString1=new LineString(new Array(collection.componentByIndex(i) as Point,collection.componentByIndex(i+1) as Point));
					 intersect=point.bounds.intersectsBounds(LineString1.bounds);
					if(intersect) arrayResult.push(new Array(LineString1,i+1));
				}
			}
			//The last segment
			LineString1=new LineString(new Array(collection.componentByIndex(0) as Point,collection.componentByIndex(collection.componentsLength-1) as Point));
			intersect=point.bounds.intersectsBounds(LineString1.bounds);
			if(intersect) arrayResult.push(new Array(LineString1,i+1));
			
			if(arrayResult.length==1){
				return arrayResult[0][1];
			}
			else if(arrayResult.length>1){
				//There is at less 2 segments	
				//We test if this is followers segments
				if((arrayResult[0][1]+1==arrayResult[1][1]) ||(arrayResult[0][1]==1 && arrayResult[1][1]==collection.componentsLength-1)){
					distanceArray=new Array();
					for(var k:int=0;k<arrayResult.length;k++){
						var pointA:Point=(arrayResult[k][0] as LineString).componentByIndex(0) as Point;
						var pointB:Point=(arrayResult[k][0] as LineString).componentByIndex(1) as Point;
						
						var pointPx:Pixel=this.layer.map.getLayerPxFromLonLat(new LonLat(point.x,point.y));
						
						var pointPxA:Pixel=this.layer.map.getLayerPxFromLonLat(new LonLat(pointA.x,pointA.y));
						
						var pointPxB:Pixel=this.layer.map.getLayerPxFromLonLat(new LonLat(pointB.x,pointB.y));
						
						var scalarPointAPointBPower:Number=Math.pow((pointPxA.x-pointPxB.x),2) +Math.pow((pointPxA.y-pointPxB.y),2);
						
						var scalarPointPointAPower:Number=Math.pow((pointPx.x-pointPxA.x),2)+Math.pow((pointPxA.y-pointPx.y),2);
						
						var scalarAHAB:Number=Math.pow((pointPx.x-pointPxA.x)*(pointPxB.x-pointPxA.x)+(pointPx.y-pointPxA.y)*(pointPxB.y-pointPxA.y),2);
						
						var bob:Number=scalarPointPointAPower-scalarAHAB/scalarPointPointAPower;
						
						var distance:Number=Math.pow((scalarPointPointAPower-scalarAHAB/scalarPointAPointBPower),1/2);
						if(distance<tolerance)
						{
							distanceArray.push(new Array(distance,arrayResult[k][1]));
						} 
					}
					if(distanceArray.length>0)
					{
						distanceArray.sort();
						return distanceArray[0][1];
					}
				}
				else return arrayResult[0][1];
				
			}
			return -1;
		}
	}
}

