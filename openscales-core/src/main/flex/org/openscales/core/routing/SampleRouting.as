package org.openscales.core.routing
{
	import org.openscales.core.Map;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.layer.FeatureLayer;

	public class SampleRouting extends AbstractRouting
	{
		private var _vertices:Array=new Array(new Point(4.8,45.0),new Point(4.9,45.80),new Point(4.9,45.9));
		
		public function SampleRouting(map:Map=null, resultsLayer:FeatureLayer=null, host:String=null, key:String=null)
		{
			super(map, resultsLayer, host, key);
		}
		override public function  sendRequest():void{
			var results:Array=new Array();
			for(var i:int=0;i<_vertices.length;i++){
				results.push(_vertices[i]);
			}
			if(intermediaryPointsNumber()>0){				
				for(var i:int=0;i<intermediaryPointsNumber();i++){
					results.push(getIntermediaryPointByIndex(i).geometry);
				}
			}
			 displayResult(results);
		}
		
	}
}