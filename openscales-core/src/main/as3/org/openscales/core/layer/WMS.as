package org.openscales.core.layer
{
	
	import org.openscales.core.Tile;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.tile.Image;
	
	public class WMS extends Grid
	{
		
		public var DEFAULT_PARAMS:Object = { service: "WMS",
                      version: "1.1.1",
                      request: "GetMap",
                      styles: "",
                      exceptions: "application/vnd.ogc.se_inimage",
                      format: "image/jpeg"
                      };
                     
       	public var reproject:Boolean = true;
       	
       	public function WMS(name:String, url:String, params:Object, options:Object = null):void {
	        super(name, url, params, options);
	        Util.applyDefaults(
	                       this.params, 
	                       Util.upperCaseObject(this.DEFAULT_PARAMS)
	                       );

	        if (options == null || options.isBaseLayer == null) {
	            this.isBaseLayer = ((this.params.TRANSPARENT != "true") && 
	                                (this.params.TRANSPARENT != true));
	        }
       	}
       	
       	override public function getURL(bounds:Bounds):String {
	        if(this.gutter) {
	            bounds = this.adjustBoundsByGutter(bounds);
	        }
	        return this.getFullRequestString(
	                     {BBOX:bounds.toBBOX(),
	                      WIDTH:this.imageSize.w,
	                      HEIGHT:this.imageSize.h});
       	}
       	
       	override public function addTile(bounds:Bounds, position:Pixel):Tile {
	       	var url:String = this.getURL(bounds);
	        return new Image(this, position, bounds, 
	                                             url, this.tileSize);
       	}
       	
       	override public function mergeNewParams(newParams:Array):void {
	       	var upperParams:Array = Util.upperCaseObject(newParams) as Array;
	        super.mergeNewParams(upperParams);
       	}
       	
       	override public function getFullRequestString(newParams:Object = null, altUrl:String = null):String {
	        var projection:String = this.map.getProjection();
	        this.params.SRS = (projection == "none") ? null : projection;
	
	        return super.getFullRequestString(newParams, altUrl);
       	}
		
	}
}