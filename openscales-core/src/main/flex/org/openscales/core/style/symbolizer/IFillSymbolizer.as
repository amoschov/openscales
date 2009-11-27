package org.openscales.core.style.symbolizer
{
	import org.openscales.core.style.fill.SolidFill;
	
	public interface IFillSymbolizer
	{
		function get fill():SolidFill;
		
		function set fill(value:SolidFill):void;	
	}
}