package org.openscales.core.handler.sketch
{
	import org.openscales.core.Map;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.layer.VectorLayer;

	public class DrawMultiPointHandler extends Handler
	{
		
		// The layer in which we'll draw
		private var _drawLayer:org.openscales.core.layer.VectorLayer = null;
		
		
		private var id:Number = 0;
		
		public function DrawMultiPointHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.VectorLayer=null)
		{
			super(map, active);
			this.drawLayer = drawLayer;
		}
		
		public function buttonClicked(selectedFeatures:Array):VectorFeature {
			var feature:VectorFeature;
			if (drawLayer != null) {
				feature = this.drawMultiPoint(selectedFeatures); 
			}
			return feature;
		}
		
		private function drawMultiPoint(selectedFeatures:Array):VectorFeature {
			var f:org.openscales.core.feature.VectorFeature;
			var m:org.openscales.core.feature.VectorFeature;
			var array:Array = new Array();
			var multiPoint:MultiPoint = new MultiPoint();
			
			for each(f in selectedFeatures){
					if(f != null) 
					{
						if(f.geometry is Point)
						{
							multiPoint.addPoint(f.geometry as Point);
							drawLayer.removeFeatures(f);
						} 		 
					}
				}
				for each(f in selectedFeatures) {
					if(f.geometry is MultiPoint)
					{
						for(var i:int = 0;i<(f.geometry as MultiPoint).components.length;i++)
						{
							multiPoint.addPoint((f.geometry as MultiPoint).components[i] as Point);
						}
						drawLayer.removeFeatures(f);
					}
				} 
				
			var style:Style = new Style();
			style.fillColor = 0x60FFE9;
			style.strokeColor = 0x60FFE9;
			
			
			var feature:VectorFeature = new VectorFeature(multiPoint,null,style);	 
			drawLayer.addFeatures(feature);
			return(feature);
			
		}
		
		public function get drawLayer():org.openscales.core.layer.VectorLayer {
			return _drawLayer;
		}

		public function set drawLayer(drawLayer:org.openscales.core.layer.VectorLayer):void {
			_drawLayer = drawLayer;
		}
		
	}
}