package org.openscales.core.popup
{
	import org.openscales.core.CanvasOL;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	
	public class AnchoredBubble extends Anchored
	{
		
		public static var CORNER_SIZE:Number = 5;
		
		public var rounded:Boolean = false;
		
		public function AnchoredBubble(id:String, lonlat:LonLat, size:Size, contentHTML:String, anchor:Object, closeBox:Boolean):void {
			super(id, lonlat, size, contentHTML, anchor, closeBox);
		}
		
		override public function draw(px:Pixel = null):CanvasOL {
			super.draw(px);

	        this.setContentHTML();
	        
	        this.setRicoCorners(!this.rounded);
	        this.rounded = true;
	
	        return this.canvas;
		}
		
		override public function setSize(size:Size = null):void {
			super.setSize(size);
        
	        if (this.contentCanvas != null) {
	
	            var contentSize:Size = this.size.clone();
	            contentSize.h -= (2 * AnchoredBubble.CORNER_SIZE);
	            contentSize.h -= (2 * this.padding);
	            
	            if (this.map) {        
	                this.setRicoCorners(!this.rounded);
	                this.rounded = true;
	            }    
	        }
		}
		
		override public function setBorder(border:String = null):void {
			this.border = "0";
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
		}
		
		public function getCornersToRound():Object {		
	        var corners:Array = ['tl', 'tr', 'bl', 'br'];

	        var corner:String = Bounds.oppositeQuadrant(this.relativePosition);
	        Util.removeItem(corners, corner);
	
	        return corners.join(" ");
		}
	}
}