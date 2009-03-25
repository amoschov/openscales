
package org.openscales.core.layer
{
	import org.openscales.core.Util;
	
	public class WMSC extends WMS
	{
		public function WMSC(name:String, url:String, params:Object, options:Object = null)
		{
			this.singleTile = false;
			super(name, url, params, options);
			
			Util.extend(this.params, {TILED:"true"});					
		}
		
	}
}