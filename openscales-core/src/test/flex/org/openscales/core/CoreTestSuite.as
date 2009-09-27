package org.openscales.core
{
	import org.openscales.core.geometry.IntersectingTest;
	import org.openscales.core.layer.capabilities.ParsingTest;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class CoreTestSuite
	{
		public var t1:StringUtilsTest;
		public var t2:SexagecimalTest;
		public var t3:ParsingTest;
		public var t4:IntersectingTest;
	}
}