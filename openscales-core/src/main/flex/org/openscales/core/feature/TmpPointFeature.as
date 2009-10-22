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
				this..addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
		}
		override public function unregisterListeners():void{
				this.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				this.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
		}
		
		override public function onMouseDown(pevt:MouseEvent):void{
			this.buttonMode=true;
			this.startDrag();
		}
		override public function onMouseUp(pevt:MouseEvent):void{
			this.stopDrag();
			
			var lonlat:LonLat=this.layer.map.getLonLatFromLayerPx(new Pixel(this.layer.mouseX,this.layer.mouseY));
			var newVertice:Point=new Point(lonlat.lon,lonlat.lat);
			
			//The vertice represents an existing vertice
			if(this.attributes.id!=null) (this.tmpPointParentGeometry as Collection).replaceComponent(this.attributes.id,newVertice);
			else 	(this.tmpPointParentGeometry as Collection).addComponent(newVertice);
			//we delete temporaries point
			var features:Array=(this.layer as VectorLayer).features;
			for each(var tmpfeature:VectorFeature in features){
				if(tmpfeature is TmpPointFeature) (this.layer as VectorLayer).removeFeature(tmpfeature);
			}
			layer.redraw();
		}
		
		//getters && setters
		
		public function get tmpPointParentGeometry():Geometry{
			return this._tmpPointParentGeometry;
		}
		public function set tmpPointParentGeometry(value:Geometry):void{
			this._tmpPointParentGeometry=value;
		}
	}
}