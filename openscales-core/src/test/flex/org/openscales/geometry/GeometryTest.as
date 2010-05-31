package org.openscales.geometry
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.sampler.getSize;
	
	import org.flexunit.Assert;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.geometry.Point;
	
	public class GeometryTest
	{
		/**
		 * Test all the cases for a LinearRing.
		 */
		[Test] public function testGeometryToVertices():void {
		
		  var startTime:Date;
		  var endTime:Date;
		  var nbVector3d:uint = 1000000;
		  var nbvector2:uint = (nbVector3d *2);
		  startTime = new Date();
		  var vectorPointraw:Vector.<Number> = new Vector.<Number>(nbvector2);
		  for(var i:uint=0;i < nbvector2;i++){
			  vectorPointraw[i]= 18899898;
			  vectorPointraw[++i]= 89894598;
		  }
		  endTime = new Date()
		  Trace.debug("creation of 1000000 vector raw  " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds and size : " + getSize(vectorPointraw));
		  
		  startTime = new Date();
		  var x:Number,y:Number;
		  for(i=0;i <nbvector2;i++){
			  x = vectorPointraw[i];
			  y = vectorPointraw[++i];
		 }
		  endTime = new Date()
		  Trace.debug("affectation of 1000000 vector raw  " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds and size : " + getSize(vectorPointraw));
		  vectorPointraw = null;
		  
     	  startTime = new Date();
		  var arraypointpixel:Vector.<Pixel> = new Vector.<Pixel>(nbVector3d);
		  for(i=0;i <nbVector3d;i++){
			  arraypointpixel[i]= new Pixel(18899898,89894598);
		  }
		  endTime = new Date()
		  Trace.debug("creation of 1000000 Pixel  " + (endTime.getTime() - startTime.getTime()).toString() + " millisecondsand size : " + getSize(arraypointpixel));
		  arraypointpixel = null;
		  startTime = new Date();
		  var arraypointlonlat:Vector.<LonLat> = new Vector.<LonLat>(nbVector3d);
		  for(i=0;i <nbVector3d;i++){
			  arraypointlonlat[i]= new LonLat(18899898,89894598);
		  }
		  endTime = new Date()
		  Trace.debug("creation of 1000000 lonlat  " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds and size : " + getSize(arraypointlonlat));
		  arraypointlonlat = null;

			
			startTime = new Date();
			var arraypoint:Vector.<org.openscales.geometry.Point> = new Vector.<org.openscales.geometry.Point>(nbVector3d);
			for(i=0;i <nbVector3d;i++){
				arraypoint[i]= new org.openscales.geometry.Point(18899898,89894598);
			}
			endTime = new Date()
			Trace.debug("creation of 1000000 point geometry openscales " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds and size : " + getSize(arraypoint));
			
			startTime = new Date();
			var pointOpenscales:org.openscales.geometry.Point;
			for(i=0;i <nbVector3d;i++){
				pointOpenscales = arraypoint[i];
			}
			endTime = new Date()
			Trace.debug("affectation of 1000000 point geometry openscales " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds and size : " + getSize(arraypoint));
			
			
			arraypoint= null;
			
			startTime = new Date();
			var arraypointFlash:Vector.<flash.geom.Point> = new Vector.<flash.geom.Point>(nbVector3d);
			for(i=0;i <nbVector3d;i++){
				arraypointFlash[i]= new flash.geom.Point(18899898,89894598);
			}
			endTime = new Date()
			Trace.debug("creation of 1000000 point  " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds and size : " + getSize(arraypointFlash));
			
			startTime = new Date();
			var pointFlash:flash.geom.Point;
			for(i=0;i <nbVector3d;i++){
				pointFlash = arraypointFlash[i];
			}
			endTime = new Date()
			Trace.debug("afectation of 1000000 point  " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds and size : " + getSize(arraypointFlash));
			arraypointFlash = null;
			
			startTime = new Date();
			var arraypoint3d:Vector.<Vector3D> = new Vector.<Vector3D>(nbVector3d);
			for(i=0;i <nbVector3d;i++){
				arraypoint3d[i]= new Vector3D(18899898,89894598,86589478598);
			}
			endTime = new Date()
			Trace.debug("creation of 1000000 Vector3D " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds and size : " + getSize(arraypoint3d));
			
			startTime = new Date();
			var point3D:Vector3D;
			for(i=0;i <nbVector3d;i++){
				point3D = arraypoint3d[i];
				x= point3D.x;
				y= point3D.y;
			}
			endTime = new Date()
			Trace.debug("afectation of 1000000 Vector3D " + (endTime.getTime() - startTime.getTime()).toString() + " milliseconds and size : " + getSize(arraypoint3d));
			
			arraypoint3d = null;
			
			
			
			//size of object
			Trace.debug("---------------------------size of object---------------------------");
			var lonlat:LonLat = new LonLat( Number.MAX_VALUE, Number.MAX_VALUE); 
			Trace.debug(" lonlat size : " + getSize(lonlat)); 
			var pixel:Pixel = new Pixel( Number.MAX_VALUE, Number.MAX_VALUE); 
			Trace.debug(" Pixel size : " + getSize(pixel)); 
			var poinFlash:flash.geom.Point = new flash.geom.Point( Number.MAX_VALUE, Number.MAX_VALUE); 
			Trace.debug(" flash.geom.Point size : " + getSize(poinFlash));
			var poinOpenscales:org.openscales.geometry.Point = new org.openscales.geometry.Point( Number.MAX_VALUE, Number.MAX_VALUE); 
			Trace.debug(" org.openscales.core.geometry.Point size : " + getSize(poinOpenscales));
			var vector3D:Vector3D = new Vector3D( Number.MAX_VALUE, Number.MAX_VALUE, Number.MAX_VALUE, Number.MAX_VALUE); 
			Trace.debug(" Vector3D size : " + getSize(vector3D));
			
		}
	}
}