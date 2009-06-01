package org.openscales.core.format
{
	import org.openscales.proj4as.ProjProjection;
	
	import org.openscales.core.Util;
	
	/**
	 * Base class for format reading/writing a variety of formats.
	 * Subclasses of Format are expected to have read and write methods. 
	 */
	public class Format
	{
		
		protected var _internalProj:ProjProjection = null;
		protected var _externalProj:ProjProjection = null;
		
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