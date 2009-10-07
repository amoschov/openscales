package org.openscales.core.handler.sketch
{	
	import org.openscales.core.Map;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.proj4as.ProjProjection;

	/**
	 * Handler base class for Drawing Handler
	 */	
	public class AbstractDrawHandler extends Handler
	{
		private var _drawLayer:org.openscales.core.layer.VectorLayer;

		public function AbstractDrawHandler(map:Map=null, active:Boolean=false, drawLayer:org.openscales.core.layer.VectorLayer=null)
		{
			super(map, active);
			this.drawLayer = drawLayer;
		}
		
		override public function set map(value:Map):void{
			if(value!=null){
				super.map=value;
				if(map.baseLayer!=null){
					this.drawLayer.projection=new ProjProjection(this.map.baseLayer.projection.srsCode);
				}
			}
		}
		//Getters and setters

		public function get drawLayer():VectorLayer{
			return _drawLayer;
		}
		public function set drawLayer(value:VectorLayer):void{
			_drawLayer = value;
		}
	}
}

