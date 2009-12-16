package org.openscales.core.routing
{
	import org.openscales.core.Map;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.layer.FeatureLayer;

	public class SampleRouting extends AbstractRouting
	{
		private var _vertices:Array=new Array(new Point(4.8,45.0),new Point(4.9,45.80),new Point(4.9,45.9));
		
		public function SampleRouting(map:Map=null,active:Boolean=false, resultsLayer:FeatureLayer=null)
		{
			super(map,active,resultsLayer);
		}
		/**
		 *This function returns the points list ordered by distances from the start point 
		 * 
		 **/
		override public function  sendRequest():void{
			 var results:Array=new Array();
			 var distanceArray:Array=new Array();
			 if(startPoint)
			 {
			 	distanceArray.push(new Array(startPoint.point.distanceTo(startPoint.point),startPoint.geometry));
			 	if(intermediaryPointsNumber()>0 || endPoint){
					for(var i:int=0;i<_vertices.length;i++){
					distanceArray.push(new Array(startPoint.point.distanceTo(_vertices[i] as Point),_vertices[i]));
					}
				}
				for(i=0;i<intermediaryPointsNumber();i++){
					distanceArray.push(new Array(startPoint.point.distanceTo(getIntermediaryPointByIndex(i).point),getIntermediaryPointByIndex(i).point));
				}
				distanceArray.sort();
			 }
			 for (i=0;i<distanceArray.length;i++){
			 	results.push(distanceArray[i][1]);
			 }
			 if(endPoint) results.push(endPoint.geometry);
			 displayResult(results);
		}
		
	}
}