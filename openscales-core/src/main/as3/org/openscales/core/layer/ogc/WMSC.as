
package org.openscales.core.layer.ogc
{
	import org.openscales.core.Util;
	
	public class WMSC extends WMS
	{
		public function WMSC(name:String, url:String, params:Object, options:Object = null)
		{
			super(name, url, params, options);
			this.singleTile = false;
			
			Util.extend(this.params, {TILED:"true"});					
		}
		
	}
}