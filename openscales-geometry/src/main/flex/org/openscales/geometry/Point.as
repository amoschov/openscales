package org.openscales.geometry
{
	
	import org.openscales.basetypes.Bounds;
	import org.openscales.proj4as.Proj4as;
	import org.openscales.proj4as.ProjPoint;
	import org.openscales.proj4as.ProjProjection;
	
	/**
	 * Class to represent a point geometry.
	 */
	public class Point extends Geometry
	{

		private var _x:Number = NaN;

		private var _y:Number = NaN;

		public function Point(x:Number = NaN, y:Number = NaN) {
			super();

			this._x = x;
			this._y = y;
		}		
		
		/**
		 * To get this geometry clone
		 * */
		override public function clone():Geometry{
			return new Point(this._x,this._y);
		}
		
		/**
		 * Return an array of all the vertices (Point) of this geometry
		 */
		override public function toVertices():Vector.<Point> {
			return new <Point>[ this.clone() as Point ];
		}
		
		override public function calculateBounds():void {
			this.bounds = new Bounds(this._x, this._y, this._x, this._y);
		}

		override public function distanceTo(point:Geometry, options:Object=null):Number{
			var distance:Number = 0.0;
			if ( (!isNaN(this._x)) && (!isNaN(this._y)) && 
				((point as Point) != null) && (!isNaN((point as Point).x)) && (!isNaN((point as Point).y)) ) {

				var dx2:Number = Math.pow(this._x - (point as Point).x, 2);
				var dy2:Number = Math.pow(this._y - (point as Point).y, 2);
				distance = Math.sqrt( dx2 + dy2 );
			}
			return distance;
		}

		public function equals(point:Point):Boolean {
			var equals:Boolean = false;
			if (point != null) {
				equals = ((this._x == point.x && this._y == point.y) ||
					(isNaN(this._x) && isNaN(this._y) && isNaN(point.x) && isNaN(point.y)));
			}
			return equals;
		}

		override public function toShortString():String {
			return (this._x + ", " + this._y);
		}

		public function move(x:Number, y:Number):void {
			this._x = this._x + x;
			this._y = this._y + y;
		}
				
		/**
		 * Determine if the input geometry intersects this one.
		 * 
		 * @param geometry Any type of geometry.
		 * @return Boolean defining if the input geometry intersects this one.
		 */
		override public function intersects(geom:Geometry):Boolean {
			return ((geom is Point) ? this.equals(geom as Point) : geom.intersects(this)); 
    	}
	
		/**
		 * Method to convert the point (x/y) from a projection sysrtem to an other.
		 *
		 * @param source The source projection
		 * @param dest The destination projection
		 */
		override public function transform(source:ProjProjection, dest:ProjProjection):void {
			var p:ProjPoint = new ProjPoint(this._x, this._y);
			Proj4as.transform(source, dest, p);
			this._x = p.x;
			this._y = p.y;
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

