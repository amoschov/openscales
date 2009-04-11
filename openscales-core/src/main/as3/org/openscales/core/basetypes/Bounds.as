package org.openscales.core.basetypes
{
	/**
	 * Instances of this class represent bounding boxes.
	 * Data stored as left, bottom, right, top floats.
	 * All values are initialized to 0, however, you should make sure you set them 
	 * before using the bounds for anything.
	 */
	public class Bounds
	{
		private var _left:Number = 0.0;
		private var _bottom:Number = 0.0;
		private var _right:Number = 0.0;
		private var _top:Number = 0.0;
		
		public function Bounds(left:Number = NaN, bottom:Number = NaN, right:Number = NaN, top:Number = NaN):void {
			if (!isNaN(left)) {
				this.left = left;
			}
			if (!isNaN(bottom)) {
				this.bottom = bottom;
			}
			if (!isNaN(right)) {
				this.right = right;
			}
			if (!isNaN(top)) {
				this.top = top;
			}
		}
		
		public function clone():Bounds {
			return new Bounds(this.left, this.bottom, this.right, this.top);
		}
		
		public function equals(bounds:Bounds):Boolean {
			var equals:Boolean = false;
			if (bounds != null) {
				equals = this.left == bounds.left &&
					this.right == bounds.right &&
					this.top == bounds.top &&
					this.bottom == bounds.bottom;
			}
			return equals;
		}
		
		public function toString():String {
			return "left-bottom=(" + this.left + "," + this.bottom + ")"
                 + " right-top=(" + this.right + "," + this.top + ")";
		}
		
		public function toBBOX(decimal:Number = -1):String {
			if (decimal == -1) {
				decimal = 6;
			}
			var mult:Number = Math.pow(10, decimal);
			var bbox:String = Math.round(this.left * mult) / mult + "," + 
                   Math.round(this.bottom * mult) / mult + "," + 
                   Math.round(this.right * mult) / mult + "," + 
                   Math.round(this.top * mult) / mult;
            return bbox;
		}
		
		public function get width():Number {
			return this.right - this.left;
		}
		
		public function get height():Number {
			return this.top - this.bottom;
		}
		
		public function get size():Size {
			return new Size(this.width, this.height);
		}
		
		public function get centerPixel():Pixel {
			return new Pixel((this.left + this.right) / 2, (this.bottom + this.top) / 2);
		}
		
		public function get centerLonLat():LonLat {
			return new LonLat((this.left + this.right) / 2, (this.bottom + this.top) / 2);
		}
		
		public function add(x:Number, y:Number):Bounds {
			return new Bounds(this.left + x, this.bottom + y, this.right + x, this.top + y);
		}
		
		public function extend(object:Object):void {
			var bounds:Bounds = null;
			if (object) {
				switch(object.CLASS_NAME) {
					case "LonLat":
						bounds = new Bounds(object.lon, object.lat, object.lon, object.lat);
						break;
					case "Geometry.Point":
						bounds = new Bounds(object.x, object.y, object.x, object.y);
						break;
					case "Bounds":
						bounds = (Bounds)object;
						break;
				}
				
				if (bounds) {
					this.left = (bounds.left < this.left) ? bounds.left 
                                                     : this.left;
               		this.bottom = (bounds.bottom < this.bottom) ? bounds.bottom 
                                                           : this.bottom;
               		this.right = (bounds.right > this.right) ? bounds.right 
                                                        : this.right;
               		this.top = (bounds.top > this.top) ? bounds.top 
                                                  : this.top;
				}
			}
		}
		
		public function extendFromBounds(bounds:Bounds):void {
			
					this.left = (bounds.left < this.left) ? bounds.left 
                                                     : this.left;
               		this.bottom = (bounds.bottom < this.bottom) ? bounds.bottom 
                                                           : this.bottom;
               		this.right = (bounds.right > this.right) ? bounds.right 
                                                        : this.right;
               		this.top = (bounds.top > this.top) ? bounds.top 
                                                  : this.top;
		}
		
		public function containsLonLat(ll:LonLat, inclusive:Boolean = true):Boolean {
			return this.contains(ll.lon, ll.lat, inclusive);
		}
		
		public function containsPixel(px:Pixel, inclusive:Boolean = true):Boolean {
			return this.contains(px.x, px.y, inclusive);
		}
		
		public function contains(x:Number, y:Number, inclusive:Boolean = true):Boolean {
	        
	        var contains:Boolean = false;
	        if (inclusive) {
	            contains = ((x >= this.left) && (x <= this.right) && 
	                        (y >= this.bottom) && (y <= this.top));
	        } else {
	            contains = ((x > this.left) && (x < this.right) && 
	                        (y > this.bottom) && (y < this.top));
	        }              
	        return contains;
		}
		
		public function intersectsBounds(bounds:Bounds, inclusive:Boolean = true):Boolean {
			var inBottom:Boolean = (bounds.bottom == this.bottom && bounds.top == this.top) ?
                    true : (((bounds.bottom > this.bottom) && (bounds.bottom < this.top)) || 
                           ((this.bottom > bounds.bottom) && (this.bottom < bounds.top))); 
	        var inTop:Boolean = (bounds.bottom == this.bottom && bounds.top == this.top) ?
	                    true : (((bounds.top > this.bottom) && (bounds.top < this.top)) ||
	                           ((this.top > bounds.bottom) && (this.top < bounds.top))); 
	        var inRight:Boolean = (bounds.right == this.right && bounds.left == this.left) ?
	                    true : (((bounds.right > this.left) && (bounds.right < this.right)) ||
	                           ((this.right > bounds.left) && (this.right < bounds.right))); 
	        var inLeft:Boolean = (bounds.right == this.right && bounds.left == this.left) ?
	                    true : (((bounds.left > this.left) && (bounds.left < this.right)) || 
	                           ((this.left > bounds.left) && (this.left < bounds.right))); 
	
	        return (this.containsBounds(bounds, true, inclusive) ||
	                bounds.containsBounds(this, true, inclusive) ||
	                ((inTop || inBottom ) && (inLeft || inRight )));
		}
		
		public function containsBounds(bounds:Bounds, partial:Boolean = false, inclusive:Boolean = true):Boolean {
			var inLeft:Boolean;
	        var inTop:Boolean;
	        var inRight:Boolean;
	        var inBottom:Boolean;
	        
	        if (inclusive) {
	            inLeft = (bounds.left >= this.left) && (bounds.left <= this.right);
	            inTop = (bounds.top >= this.bottom) && (bounds.top <= this.top);
	            inRight= (bounds.right >= this.left) && (bounds.right <= this.right);
	            inBottom = (bounds.bottom >= this.bottom) && (bounds.bottom <= this.top);
	        } else {
	            inLeft = (bounds.left > this.left) && (bounds.left < this.right);
	            inTop = (bounds.top > this.bottom) && (bounds.top < this.top);
	            inRight= (bounds.right > this.left) && (bounds.right < this.right);
	            inBottom = (bounds.bottom > this.bottom) && (bounds.bottom < this.top);
	        }
	        
	        return (partial) ? (inTop || inBottom ) && (inLeft || inRight ) 
	                         : (inTop && inLeft && inBottom && inRight);
		}
		
		public function determineQuadrant(lonlat:LonLat):String {
			var quadrant:String = "";
	        var center:LonLat = this.centerLonLat;
	        
	        /* quadrant += (lonlat.lat < center.lat) ? "b" : "t";
	        quadrant += (lonlat.lon < center.lon) ? "l" : "r"; */
	        
	        if (lonlat.lat < center.lat){
	        	quadrant += "b";
	        }
	        else{
	        	quadrant += "t";
	        }
	        
	        if(lonlat.lon < center.lon){
	        	quadrant += "l";
	        }
	        else{
	        	quadrant += "r";
	        }
	    
	        return quadrant; 
		}
		
		public function fromString(str:String):Bounds {
			var bounds:Array = str.split(",");
			return fromArray(bounds);
		}
		
		public function fromArray(bbox:Array):Bounds {
			return new Bounds(Number(bbox[0]), Number(bbox[1]), Number(bbox[2]), Number(bbox[3]));
		}
		
		public function fromSize(size:Size):Bounds {
			return new Bounds(0, size.h, size.w, 0);
		}
		
		public static function oppositeQuadrant(quadrant:String):String {
			var opp:String = "";
    
		    opp += (quadrant.charAt(0) == 't') ? 'b' : 't';
		    opp += (quadrant.charAt(1) == 'l') ? 'r' : 'l';
		    
		    return opp;
		}
		
		// Getters & setters : _left _bottom _right _top
		
		public function get left():Number
		{
			return _left;
		}
		public function set left(newLeft:Number):void
		{
			_left = newLeft;
		}
		
		public function get bottom():Number
		{
			return _bottom;
		}
		public function set bottom(newBottom:Number):void
		{
			_bottom = newBottom;
		}
		
		public function get right():Number
		{
			return _right;
		}
		public function set right(newRight:Number):void
		{
			_right = newRight;
		}
		
		public function get top():Number
		{
			return _top;
		}
		public function set top(newTop:Number):void
		{
			_top = newTop;
		}

	}
}