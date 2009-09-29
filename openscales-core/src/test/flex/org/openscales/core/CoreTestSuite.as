package org.openscales.core
{
	import org.openscales.core.configuration.ConfigurationTest;
	import org.openscales.core.geometry.IntersectingTest;
	import org.openscales.core.layer.capabilities.ParsingTest;
	import org.openscales.core.utils.SexagecimalTest;
	import org.openscales.core.utils.StringUtilsTest;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class CoreTestSuite
	{
		public var t1:MapTest;
		public var t2:StringUtilsTest;
		public var t3:SexagecimalTest;
		public var t4:ParsingTest;
		public var t5:IntersectingTest;
		public var t6:ConfigurationTest;
	}
}