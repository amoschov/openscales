package org.openscales.core.geometry
{
	import org.openscales.core.Geometry;
	import org.openscales.core.basetypes.Bounds;
	
	public class Rectangle extends Geometry
	{
		
		public var x:Number = NaN;

	    public var y:Number = NaN;

	    public var width:Number = NaN;

	    public var height:Number = NaN;
	    
	    public function Rectangle(x:Number, y:Number, width:Number, heigth:Number):void {
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
	    
	    override public function getLength():Number {
		    var length:Number = (2 * this.width) + (2 * this.height);
	        return length;
	    }
	    
	    override public function getArea():Number {
	        var area:Number = this.width * this.height;
	        return area;
	    }
		
	}
}