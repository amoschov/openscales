package org.openscales.core.popup
{
	import flash.display.Sprite;
	
	import org.openscales.core.PopupOL;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	
	public class Anchored extends PopupOL
	{
		public var relativePosition:String = null;

	    private var anchor:Object = null;
	    
	    public function Anchored(id:String, lonlat:LonLat, size:Size, contentHTML:String, anchor:Object, closeBox:Boolean):void {
	        super(id, lonlat, size, contentHTML, closeBox);
	
	        this.anchor = (anchor != null) ? anchor 
	                                       : { size: new Size(0,0),
	                                           offset: new Pixel(0,0)};
	    }
	    
	    override public function draw(px:Pixel = null):void {
	    	if (px == null) {
	            if ((this.lonlat != null) && (this.map != null)) {
	                px = this.map.getLayerPxFromLonLat(this.lonlat);
	            }
	        }

	        this.relativePosition = this.calculateRelativePosition(px);

	    }
	    
	    public function calculateRelativePosition(px:Pixel):String {
	        var lonlat:LonLat = this.map.getLonLatFromLayerPx(px);        
	        
	        var extent:Bounds = this.map.getExtent();
	        var quadrant:String = extent.determineQuadrant(lonlat);
	        
	        return Bounds.oppositeQuadrant(quadrant);
	    }
	    
	    override public function set position(px:Pixel):void {
	        var newPx:Pixel = this.calculateNewPx(px);
	        super.position = newPx;
	    }
	    
	    override public function setSize(size:Size = null):void {
	    	super.setSize(size);
	
	        if ((this.lonlat) && (this.map)) {
	            var px:Pixel = this.map.getLayerPxFromLonLat(this.lonlat);
	            this.position = px;
	        }
	    }
	    
	    public function calculateNewPx(px:Pixel):Pixel {
	    	var newPx:Pixel = px.offset(this.anchor.offset);
	
	        var top:Boolean = (this.relativePosition.charAt(0) == 't');
	        newPx.y += (top) ? -this.size.h : this.anchor.size.h;
	        
	        var left:Boolean = (this.relativePosition.charAt(1) == 'l');
	        newPx.x += (left) ? -this.size.w : this.anchor.size.w;
	
	        return newPx;  
	    }
	}
}