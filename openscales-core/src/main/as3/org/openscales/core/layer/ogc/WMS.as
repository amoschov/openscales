package org.openscales.core.layer.ogc
{
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.layer.Grid;
	import org.openscales.core.layer.params.ogc.WMSParams;
	import org.openscales.core.tile.ImageTile;
	import org.openscales.core.tile.Tile;
	import org.openscales.proj4as.ProjProjection;
	
	/**
	 * Instances of WMS are used to display data from OGC Web Mapping Services.
	 *  
	 * @author Bouiaw
	 */	
	public class WMS extends Grid
	{
                     
       	private var _reproject:Boolean = true;
       	
       	public function WMS(name:String, url:String, params:WMSParams = null, isBaseLayer:Boolean = false, 
									visible:Boolean = true, projection:String = null, proxy:String = null) {
										
			if (params == null)
				params = new WMSParams("");
										   		
	        super(name, url, params, isBaseLayer, visible, projection, proxy);
	        
	        this.singleTile = true;

       	}
       	
       	override public function getURL(bounds:Bounds):String {
	        if(this.gutter) {
	            bounds = this.adjustBoundsByGutter(bounds);
	        }
	        
	        (this.params as WMSParams).bbox = bounds.boundsToString();
	        (this.params as WMSParams).width = this.imageSize.w;
	        (this.params as WMSParams).height = this.imageSize.h;
	        
	        return this.getFullRequestString();
       	}
       	
       	override public function addTile(bounds:Bounds, position:Pixel):Tile {
	       	var url:String = this.getURL(bounds);
	        return new ImageTile(this, position, bounds, 
	                                             url, this.tileSize);
       	}
       	
       	override public function getFullRequestString(altUrl:String = null):String {
	         var projection:ProjProjection = this.projection;
	         if (projection != null || this.map.projection != null)
	        	(this.params as WMSParams).srs = (projection == null) ? this.map.projection.srsCode : projection.srsCode;
	
	        return super.getFullRequestString(altUrl);
       	}
       	
       	public function get reproject():Boolean {
			return this._reproject;
		}
		
		public function set reproject(value:Boolean):void {
			this._reproject = value;
		}
		
	}
}