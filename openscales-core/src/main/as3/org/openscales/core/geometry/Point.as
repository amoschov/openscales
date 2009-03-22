package org.openscales.core.geometry
{
	import org.openscales.core.Geometry;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	
	public class Point extends Geometry
	{
		
		public var x:Number = NaN;

		public var y:Number = NaN;
		
		public var components:Array = null;
		
		public function Point(x:Object = NaN, y:Object = NaN):void {
			super();
			this.components = new Array();
        
	        this.x = Number(x);
	        this.y = Number(y);
		}
		
		public function clone(obj:Object = null):Object {
			if (obj == null) {
	            obj = new Point(this.x, this.y);
	        }
	
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

	}
}