package org.openscales.core
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class URLLoaderOL extends URLLoader
	{
		public var _eventCacheID:String;
		public var id:String;
		
		public function URLLoaderOL(request:URLRequest = null):void {
			super(request);
		}
	}
}