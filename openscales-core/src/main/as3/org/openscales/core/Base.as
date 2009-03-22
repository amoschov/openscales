package org.openscales.core
{
	import mx.rpc.http.mxml.HTTPService;
	
	public class Base
	{
		public var options:Object = null;
		public var transport:HTTPService;
		
		public function setOptions(options:Object):void {
			this.options = {
			  method:       'post',
			  parameters:   ''
			}
			Util.extend(this.options, options || {});
		}
		
		public function responseIsSuccess():Boolean {
			if (this.transport.lastResult) {
				return true;
			} else {
				return false;
			}
		}
		
		public function responseIsFailure():Boolean {
			return !this.responseIsSuccess();
		}
	}
}