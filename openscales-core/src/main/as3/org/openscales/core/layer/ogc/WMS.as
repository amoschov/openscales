package org.openscales.core.layer.ogc
{
	
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.layer.Grid;
	import org.openscales.core.tile.ImageTile;
	import org.openscales.core.tile.Tile;
	import org.openscales.proj.IProjection;
	import org.openscales.proj4as.ProjProjection;
	
	/**
	 * Instances of WMS are used to display data from OGC Web Mapping Services.
	 *  
	 * @author Bouiaw
	 */	
	public class WMS extends Grid
	{
		
		public var DEFAULT_PARAMS:Object = { service: "WMS",
                      version: "1.1.1",
                      request: "GetMap",
                      styles: "",
                      exceptions: "application/vnd.ogc.se_inimage",
                      format: "image/jpeg"
                      };
                     
       	private var _reproject:Boolean = true;
       	
       	public function WMS(name:String, url:String, params:Object = null, isBaseLayer:Boolean = false, 
									visible:Boolean = true, projection:String = null, proxy:String = null) {
										   		
	        super(name, url, params, isBaseLayer, visible, projection, proxy);
	        
	        this.singleTile = true;
	        
	        Util.applyDefaults(
	                       this.params, 
	                       Util.upperCaseObject(this.DEFAULT_PARAMS)
	                       );

       	}
       	
       	override public function getURL(bounds:Bounds):String {
	        if(this.gutter) {
	            bounds = this.adjustBoundsByGutter(bounds);
	        }
	        return this.getFullRequestString(
	                     {BBOX:bounds.boundsToString(),
	                      WIDTH:this.imageSize.w,
	                      HEIGHT:this.imageSize.h});
       	}
       	
       	override public function addTile(bounds:Bounds, position:Pixel):Tile {
	       	var url:String = this.getURL(bounds);
	        return new ImageTile(this, position, bounds, 
	                                             url, this.tileSize);
       	}
       	
       	override public function mergeNewParams(newParams:Array):void {
	       	var upperParams:Array = Util.upperCaseObject(newParams) as Array;
	        super.mergeNewParams(upperParams);
       	}
       	
       	override public function getFullRequestString(newParams:Object = null, altUrl:String = null):String {
	         var projection:ProjProjection = this.projection;
	         if (projection != null || this.map.projection != null)
	        	this.params.SRS = (projection == null) ? this.map.projection.srsCode : projection.srsCode;
	
	        return super.getFullRequestString(newParams, altUrl);
       	}
       	
       	public function get reproject():Boolean {
			return this._reproject;
		}
		
		public function set reproject(value:Boolean):void {
			this._reproject = value;
		}
		
	}
}