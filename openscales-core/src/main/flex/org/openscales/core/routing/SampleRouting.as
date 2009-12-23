package org.openscales.core.routing
{
	import org.openscales.core.Map;
	import org.openscales.core.layer.FeatureLayer;

	public class SampleRouting extends AbstractRouting
	{
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
			 var distance:Array=new Array();
			 if(startPoint)
			 {
			 	distanceArray.push(new Array(startPoint.point.distanceTo(startPoint.point),startPoint.geometry));
			 	distance.push(startPoint.point.distanceTo(startPoint.point));
				for(var i:int=0;i<intermediaryPointsNumber();i++){
					distanceArray.push(new Array(startPoint.point.distanceTo(getIntermediaryPointByIndex(i).point),getIntermediaryPointByIndex(i).point));
						distance.push(startPoint.point.distanceTo(getIntermediaryPointByIndex(i).point));
				}
				distance.sort(sortOnValue);
			 }
			 for(i=0;i<distance.length;i++)
			 {
			 	for(var j:int=0;j<distanceArray.length;j++){
			 		if(distance[i]==distanceArray[j][0]){
			 			results.push(distanceArray[j][1]);
			 			break;
			 		}
			 	}
			 }
			/*  FOR (I=0;I<DISTANCEARRAY.LENGTH;I++){
			 	RESULTS.PUSH(DISTANCEARRAY[I][1]);
			 } */
			 if(endPoint) results.push(endPoint.geometry);
			 displayResult(results);
		}
		
		public function sortOnValue(a:Number,b:Number):Number{
			if(a>b) return 1;
			else if(a<b) return -1;
			else return 0;
		}

		
		
	}
}