package org.openscales.core.popup
{
	import org.openscales.commons.Util;
	import org.openscales.commons.basetypes.Bounds;
	import org.openscales.commons.basetypes.LonLat;
	import org.openscales.commons.basetypes.Pixel;
	import org.openscales.commons.basetypes.Size;
	
	public class AnchoredBubble extends Anchored
	{
		
		public static var CORNER_SIZE:Number = 5;
		
		public var rounded:Boolean = true;
		
		public function AnchoredBubble(id:String, lonlat:LonLat, size:Size, contentHTML:String, anchor:Object, closeBox:Boolean):void {
			super(id, lonlat, size, contentHTML, anchor, closeBox);
		}
		
		override public function draw(px:Pixel = null):void {
			super.draw(px);

	        this.setContentHTML();
	        
	        this.setRicoCorners(!this.rounded);
	        this.rounded = true;
		}
		
		override public function setSize(size:Size = null):void {
			super.setSize(size);
	
            var contentSize:Size = this.size.clone();
            contentSize.h -= (2 * AnchoredBubble.CORNER_SIZE);
            contentSize.h -= (2 * this.padding);
            
            if (this.map) {        
                this.setRicoCorners(!this.rounded);
                this.rounded = true;
            }    
		}
		
		public function setRicoCorners(firstTime:Boolean):void {
			var corners:Object = this.getCornersToRound();
	        var options:Object = {corners: corners,
	                       bgColor: "transparent",
	                         blend: false};
	
	        if (firstTime) {
	            //Corner.round(this.canvas, options);
	        } else {
	            //Corner.reRound(this.groupCanvas, options);
	            //set the popup color and opacity
	            
	        }
	        graphics.beginFill(0x000000,0.5)
	        graphics.drawRect(this.positionP.x, this.positionP.y, this.size.w, this.size.h);
	        graphics.endFill();
		}
		
		public function getCornersToRound():Object {		
	        var corners:Array = ['tl', 'tr', 'bl', 'br'];

	        var corner:String = Bounds.oppositeQuadrant(this.relativePosition);
	        Util.removeItem(corners, corner);
	
	        return corners.join(" ");
		}
	}
}