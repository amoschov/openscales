
package org.openscales.core.layer.ogc
{
	import org.openscales.core.Util;
	
	/**
	 * Instances of WMSC are used to display data from OGC Web Mapping Services requested as tiles.
	 *  
	 * @author Bouiaw
	 */	

	public class WMSC extends WMS
	{
		public function WMSC(name:String, url:String, params:Object = null, isBaseLayer:Boolean = false, 
									visible:Boolean = true, projection:String = null, proxy:String = null)
		{
			super(name, url, params, isBaseLayer, visible, projection, proxy);
			
			this.singleTile = false;
			
			Util.extend(this.params, {TILED:"true"});					
		}
		
	}
}