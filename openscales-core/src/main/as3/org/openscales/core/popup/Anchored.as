package org.openscales.core.popup
{
	import org.openscales.commons.basetypes.Bounds;
	import org.openscales.commons.basetypes.LonLat;
	import org.openscales.commons.basetypes.Pixel;
	import org.openscales.commons.basetypes.Size;
	
	/**
	 * Anchored popup
	 */
	public class Anchored extends Popup
	{
		/** 
	     * Relative position of the popup ("br", "tr", "tl" or "bl").
	     * TODO : use an enum for that
	     */
		public var _relativePosition:String = "";

	    /**
	     * Object to which we'll anchor the popup. Must expose 
	     * 'size' (Size) and 'offset' (Pixel) properties.
	     * TODO : use an interface for that
	     */
	    private var _anchor:Object = null;
	    
	    public function Anchored(id:String, lonlat:LonLat, size:Size, contentHTML:String, anchor:Object, closeBox:Boolean):void {
	        super(id, lonlat, size, contentHTML, closeBox);
	
	        this._anchor = anchor;
	    }
	    
	    override public function draw(px:Pixel=null):void {
	    	if (px == null) {
	            if ((this.lonlat != null) && (this.map != null)) {
	                px = this.map.getLayerPxFromLonLat(this.lonlat);
	            }
	        }

	        this.relativePosition = this.calculateRelativePosition(px);
	        
	        super.draw(px);
	    }
	    
	    public function calculateRelativePosition(px:Pixel):String {
	        var lonlat:LonLat = this.map.getLonLatFromLayerPx(px);        
	        
	        var extent:Bounds = this.map.extent;
	        var quadrant:String = extent.determineQuadrant(lonlat);
	        
	        return Bounds.oppositeQuadrant(quadrant);
	    }
	    
	    override public function set position(px:Pixel):void {
	        var newPx:Pixel = this.calculateNewPx(px);
	        super.position = newPx;
	    }
	    
	    override public function set size(size:Size):void {
	    	super.size = size;
	
	        if ((this.lonlat) && (this.map)) {
	            var px:Pixel = this.map.getLayerPxFromLonLat(this.lonlat);
	            this.position = px;
	        }
	    }
	    
	    public function calculateNewPx(px:Pixel):Pixel {
	    	var newPx:Pixel = px.offset(this._anchor.offset);
	
	        var top:Boolean = (this.relativePosition.charAt(0) == 't');
	        newPx.y += (top) ? -this.size.h : this._anchor.size.h;
	        
	        var left:Boolean = (this.relativePosition.charAt(1) == 'l');
	        newPx.x += (left) ? -this.size.w : this._anchor.size.w;
	
	        return newPx;  
	    }
	    
	    public function get relativePosition():String {
        	return this._relativePosition;
        }
        
        public function set relativePosition(value:String):void {
        	this._relativePosition = value;
        }
	}
}