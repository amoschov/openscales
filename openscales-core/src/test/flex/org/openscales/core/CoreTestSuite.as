package org.openscales.core
{
	import org.openscales.core.configuration.ConfigurationTest;
	import org.openscales.core.format.KMLFormatTest;
	import org.openscales.core.format.WKTFormatTest;
	import org.openscales.core.layer.LayerTest;
	import org.openscales.core.layer.capabilities.ParsingTest;
	import org.openscales.core.utils.SexagecimalTest;
	import org.openscales.core.utils.StringUtilsTest;
	import org.openscales.geometry.GeometryTest;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class CoreTestSuite
	{
		//public var t1:GeometryTest;
		public var t1:MapTest;
		public var t2:StringUtilsTest;
		public var t3:SexagecimalTest;
		public var t4:ParsingTest;
		public var t6:ConfigurationTest;
		public var t7:KMLFormatTest;
		public var t8:LayerTest;
		public var t9:WKTFormatTest;
	}
}