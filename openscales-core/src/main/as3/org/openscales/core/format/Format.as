package org.openscales.core.format
{
	import org.openscales.commons.Util;
	
	/**
	 * Base class for format reading/writing a variety of formats.
	 * Subclasses of Format are expected to have read and write methods. 
	 */
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