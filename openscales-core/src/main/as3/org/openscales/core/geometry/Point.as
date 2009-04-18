package org.openscales.core.geometry
{
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	
	public class Point extends Geometry
	{
		
		private var _x:Number = NaN;

		private var _y:Number = NaN;
				
		public function Point(x:Number = NaN, y:Number = NaN):void {
			super();
        
	        this.x = x;
	        this.y = y;
		}
		
		override public function clone():Geometry {
            var obj:Point = new Point(this.x, this.y);
	
	        Util.applyDefaults(obj, this);
	
	        return obj;
		}
		
		override public function calculateBounds():void {
	        this.bounds = new Bounds(this.x, this.y,
                                    this.x, this.y);
		}
		
		public function distanceTo(point:Point):Number {
			var distance:Number = 0.0;
	        if ( (!isNaN(this.x)) && (!isNaN(this.y)) && 
	             (point != null) && (!isNaN(point.x)) && (!isNaN(point.y)) ) {
	             
	             var dx2:Number = Math.pow(this.x - point.x, 2);
	             var dy2:Number = Math.pow(this.y - point.y, 2);
	             distance = Math.sqrt( dx2 + dy2 );
	        }
	        return distance;
		}
		
		public function equals(geom:Object):Boolean {
			var equals:Boolean = false;
	        if (geom != null) {
	            equals = ((this.x == geom.x && this.y == geom.y) ||
	                      (isNaN(this.x) && isNaN(this.y) && isNaN(geom.x) && isNaN(geom.y)));
	        }
	        return equals;
		}
		
		public function toShortString():String {
			return (this.x + ", " + this.y);
		}
		
		public function move(x:Number, y:Number):void {
			this.x = this.x + x;
	        this.y = this.y + y;
		}
		
		public function get x():Number {
			return this._x;
		}
		
		public function set x(value:Number):void {
			this._x = value;
		}
		
		public function get y():Number {
			return this._y;
		}
		
		public function set y(value:Number):void {
			this._y = value;
		}

	}
}