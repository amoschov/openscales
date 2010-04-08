package org.openscales.core.layer.ogc
{

	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
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

		public function WMS(name:String = "",
							url:String = "",
							layers:String = "") {

			super(name, url, new WMSParams(layers));
			
			this.singleTile = true;
			
			CACHE_SIZE = 32;

		}
	    override public function get maxExtent():Bounds {
			if(!super.maxExtent)
				return null;
			
			var maxExtent:Bounds =  super.maxExtent.clone();
			if(this.isBaseLayer != true && this.reproject == true && this.projection.srsCode != this.map.baseLayer.projection.srsCode)
			{
				 maxExtent.transform(this.projection,this.map.baseLayer.projection);
			}
			
			return maxExtent;
		}
		
		override public function getURL(bounds:Bounds):String {
			var projection:ProjProjection = this.projection;
			var projectedBounds:Bounds = bounds.clone();
			
			if( this.isBaseLayer != true  && this._reproject == true && projection.srsCode != this.map.baseLayer.projection.srsCode)
			{
			  	projectedBounds.transform(this.map.baseLayer.projection.clone(),projection.clone());
			}

			this.params.bbox = projectedBounds.boundsToString();
			(this.params as WMSParams).width = this.imageSize.w;
			(this.params as WMSParams).height = this.imageSize.h;
            if( this._reproject == false){
			  if (projection != null || this.map.baseLayer.projection != null)
				  (this.params as WMSParams).srs = (projection == null) ? this.map.baseLayer.projection.srsCode : projection.srsCode;
            }
            else{
            	(this.params as WMSParams).srs = projection.srsCode;
            }
			var requestString:String;
			if(this.url.indexOf("?")==-1) requestString = this.url+"?"+this.params.toGETString();
			else requestString=this.url+"&"+this.params.toGETString();

			return requestString;
		}

		override public function addTile(bounds:Bounds, position:Pixel):Tile {
			var url:String = this.getURL(bounds);
			return new ImageTile(this, position, bounds, 
				url, new Size(this.tileWidth, this.tileHeight));
		}

		public function get reproject():Boolean {
			return this._reproject;
		}

		public function set reproject(value:Boolean):void {
			this._reproject = value;
		}
		
		public function get exception():String {
			return (this.params as WMSParams).exceptions;
		}
		
		public function set exception(value:String):void {
			(this.params as WMSParams).exceptions = value;
		}

	}
}

