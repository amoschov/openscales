package org.openscales.core.feature
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.style.Style;

	public class TmpPointFeature extends PointFeature
	{
		/**
		 *the geometry of the temporary point parent(Polygon Linestring) 
		 **/
		private var _tmpPointParentGeometry:Geometry=null
		
		/**
		 * Feature is  used to draw a temporary Point geometry on FeatureLayer
		 * The temporary point is used for modify its feature(LineString or Polygon) parent
	 	 */
		public function TmpPointFeature(geom:Point=null, data:Object=null, style:Style=null)
		{
			super(geom, data, style);
		}
		
		override public function registerListeners():void{		
				this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				this.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
				this.addEventListener(MouseEvent.DOUBLE_CLICK,this.ondblclick);
		}
		override public function unregisterListeners():void{
				this.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				this.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
		}
		 public function ondblclick(pevt:MouseEvent):void{
			
		}
		override public function onMouseDown(pevt:MouseEvent):void{
			this.buttonMode=true;
			
			//this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.EDITION_FEATURE_DRAG_START,this));
			
			this.startDrag();		
		}
		override public function onMouseUp(pevt:MouseEvent):void{
			this.stopDrag();
			var lonlat:LonLat=this.layer.map.getLonLatFromLayerPx(new Pixel(this.layer.mouseX,this.layer.mouseY));
			
			var newVertice:Point=new Point(lonlat.lon,lonlat.lat);
			
			
			
			//The vertice represents an existing vertice
			if(this.attributes.id!=null) (this.tmpPointParentGeometry as Collection).replaceComponent(this.attributes.id,newVertice);
			else 	
			{
				//var index:Number=getSegmentsIntersection();
				var index:Number=0;
				(this.tmpPointParentGeometry as Collection).addComponent(newVertice,index);
			}
			//we delete temporaries point
			var features:Array=(this.layer as VectorLayer).features;
			for each(var tmpfeature:VectorFeature in features){
				if(tmpfeature is TmpPointFeature) (this.layer as VectorLayer).removeFeature(tmpfeature);
			}
			layer.redraw();
			//this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.EDITION_FEATURE_DRAG_STOP,this));
		}
		
		/**
		 * To know the segment of the linearRing the point belong to
		 * @param point:geometry point to test 
		 * @return the segment number
		 * */
		//public function getSegmentsIntersection():int{
			/*var tmpLineString:LineString=null;
			var tmpPointArray:Array;
			var segmts:Array=new Array();
		//	if(!this.intersects(point))	return -1;
			
			tmpPointArray=new Array();		
			tmpPointArray.push(this.componentByIndex(this.componentsLength-1),this.componentByIndex(0));
			tmpLineString= new LineString(tmpPointArray);
			if(tmpLineString.intersectPoint(point)) segmts.push(new Array(tmpLineString,0));

			
			for(var i:int=0;i<this.componentsLength-1;i++){
				tmpPointArray=new Array();
				tmpPointArray.push(this.componentByIndex(i),this.componentByIndex(i+1));
				tmpLineString= new LineString(tmpPointArray);
				/*if(tmpLineString.intersectPoint(point)) segmts.push(new Array(tmpLineString,i+1));
				tmpPointArray=null;
				tmpLineString=null;*/
			//}
			
		//	if(segmts.length==1) return segmts[0][1];
			//else
		//	{
		//TODO damien nda ameliorer algo
	/*	var distance:Array=new Array();
		var noeud:Number=-1;
			
				for(var j:int=0;j<(this.tmpPointParentGeometry as Collection).componentsLength;j++){
						var px:Pixel=null;
						var px2:Pixel=null;
						var index:Number=j+1;
						if(j==(this.tmpPointParentGeometry as Collection).componentsLength-1)
						{
							 //px=this.getLayerPxFromPoint((this.tmpPointParentGeometry as Collection).componentByIndex(0) as Point);
							// px2=this.getLayerPxFromPoint((this.tmpPointParentGeometry as Collection).componentByIndex(j) as Point);
							index=0;
						}
						else
						{
						// px=this.getLayerPxFromPoint((this.tmpPointParentGeometry as Collection).componentByIndex(j) as Point);
						// px2=this.getLayerPxFromPoint((this.tmpPointParentGeometry as Collection).componentByIndex(j+1) as Point);
					//	var pointPx:Pixel=this.getLayerPxFromPoint(point);
						}
						var x1:Number=px.x;
						var x2:Number=px2.x;
						var y1:Number=px.y;
						var y2:Number=px2.y;
						//Line equation
						var coeffdir:Number=(y1-y2)/(x1-x2);
						var b:Number=y2+x2*(y2-y1)/(x1-x2);
						
					//	distance.push(new Array(Math.floor(Math.abs(coeffdir*pointPx.x+b-pointPx.y)),index));
			
			}
			var index:Number=0;
			for(var i:int=0;i<distance.length;i++){
				if(i==0)
				{
					noeud=distance[i][1];
					index=i;
				}
				else
				{
					if(distance[index][0]>distance[i][0])
					{
						index=i;
						noeud=distance[i][1];
					}
				}
			}
	return noeud;			
		}*/
		
		
		//getters && setters
		
		public function get tmpPointParentGeometry():Geometry{
			return this._tmpPointParentGeometry;
		}
		public function set tmpPointParentGeometry(value:Geometry):void{
			this._tmpPointParentGeometry=value;
		}
	}
}