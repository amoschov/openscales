package org.openscales.core.style.symbolizer
{
	import org.openscales.core.style.stroke.Stroke;
	
	public interface IStrokeSymbolizer
	{
		function get stroke():Stroke;
		
		function set stroke(value:Stroke):void; 
	}
}