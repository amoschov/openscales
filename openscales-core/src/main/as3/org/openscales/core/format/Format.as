package org.openscales.core.format
{
	import org.openscales.core.Trace;
	import org.openscales.proj4as.ProjProjection;
	
	/**
	 * Base class for format reading/writing a variety of formats.
	 * Subclasses of Format are expected to have read and write methods. 
	 */
	public class Format
	{
		
		protected var _internalProj:ProjProjection = null;
		protected var _externalProj:ProjProjection = null;
		
		public function Format() {

		}
		
		public function read(data:Object):Object {
			Trace.warning("Read not implemented.");
			return null;
		}
		
		public function write(features:Object):Object {
			Trace.warning("Write not implemented.");
			return null;
		}
		
	}
}