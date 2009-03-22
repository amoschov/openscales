package org.openscales.core
{
	import org.openscales.core.feature.Vector;
	
	public class Format
	{
		
		public function Format(options:Object = null):void {
			Util.extend(this, options);
		}
		
		public function read(data:Object):Object {
			trace("Read not implemented.");
			return null;
		}
		
		public function write(features:Object):Object {
			trace("Write not implemented.");
			return null;
		}
		
	}
}