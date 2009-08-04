package org.openscales.core.security.Requesters
{
	import flash.display.Loader;
	
	import org.openscales.core.RequestLayer1;
	import org.openscales.core.basetypes.maps.HashMap;
	
	public class GeoIgnSecurityRequester  implements ISecurityRequester 
	{
		public function GeoIgnSecurityRequester()
		{
		}
		/**
		 *@inherited
		 **/
		public function executeRequest(request:RequestLayer1):Loader
		 {
		 	return null;
		 }
		 /**
		 *@inherited 
		 **/
		public function canExecuteRequest(request:RequestLayer1):Boolean
		 {
		 	return false;
		 }
		 /**
		 * @inherited
		 * */
		 public function addParams(params:HashMap):void
		 {
		 	
		 }
	}
}