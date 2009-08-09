
package org.openscales.core.layer.ogc
{
	import org.openscales.core.layer.params.ogc.WMSParams;
	import org.openscales.core.request.ogc.WMSRequest;
	
	/**
	 * Instances of WMSC are used to display data from OGC Web Mapping Services requested as tiles.
	 *  
	 * @author Bouiaw
	 */	

	public class WMSC extends WMS
	{
		public function WMSC(name:String, url:String, params:WMSParams = null, isBaseLayer:Boolean = false, 
									visible:Boolean = true, projection:String = null, proxy:String = null)
		{
			super(name, url, params, isBaseLayer, visible, projection, proxy);
			
			this.singleTile = false;
			
			(this.request.params as WMSParams).tiled= true;				
		}
		
	}
}