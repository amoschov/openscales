package org.openscales.proj4as
{
	import org.openscales.commons.geometry.Point;
	
	public interface Projection
	{
		
		function transform(point:Point):Point;
		function inverseTransform(point:Point):Point; 
		
	}
}