package org.openscales.core.geometry
{
	import org.openscales.core.basetypes.Bounds;
	
	public class Rectangle extends Geometry
	{
		
		private var _x:Number = NaN;

	    private var _y:Number = NaN;

	    private var _width:Number = NaN;

	    private var _height:Number = NaN;
	    
	    public function Rectangle(x:Number, y:Number, width:Number, heigth:Number) {
	    	super();
	    	
	    	this.x = x;
	        this.y = y;
	
	        this.width = width;
	        this.height = height;
	    }
	    
	    override public function calculateBounds():void {
	        this.bounds = new Bounds(this.x, this.y,
                                    this.x + this.width, 
                                    this.y + this.height);
	    }
	    
	    override public function get length():Number {
		    var length:Number = (2 * this.width) + (2 * this.height);
	        return length;
	    }
	    
	    override public function get area():Number {
	        var area:Number = this.width * this.height;
	        return area;
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
		
		public function get width():Number {
			return this._width;
		}
		
		public function set width(value:Number):void {
			this._width = value;
		}
		
		public function get height():Number {
			return this._height;
		}
		
		public function set height(value:Number):void {
			this._height = value;
		}
		
	}
}