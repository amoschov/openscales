package org.opengis.test.referencing.cs {
	import org.opengis.referencing.cs.AxisDirection;
	import org.opengis.referencing.cs.RangeMeaning;
	import flexunit.framework.TestCase;

	/**
	 * Test enums of org.opengis.referencing.cs : AxisDirection, RangeMeaning.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class ReferencingCsCodeListTest extends TestCase {

		/**
		 * Constructor
		 */
		public function ReferencingCsCodeListTest(methodName:String=null) {
			super(methodName);
		}

		/**
		 * Initial state.
		 * Sets up the fixture, this method is called before a test is executed.
		 */
		override public function setUp():void {
		}

		/**
		 * Clean up.
		 * Tears down the fixture, this method is called after a test is executed.
		 */
		override public function tearDown():void {
		}

		/**
		 * Test 1 : AxisDirection.NORTH
		 * Test 2 : AxisDirection.NORTH.opposite()
		 * Test 3 : identifier, name
		 * Test 4 : RangeMeaning.EXACT
		 */
		public function testReferencingCsCodeListX1():void {
			trace("ReferencingCsCodeListTest - test 1 :");
			var ax:AxisDirection=AxisDirection.NORTH;
			assertNotNull("AxisDirection.NORTH:", ax);
			assertEquals("identifier:", "north", ax.identifier());

			trace("ReferencingCsCodeListTest - test 2 :");
			var ax2:AxisDirection=ax.opposite();
			assertNotNull("AxisDirection.NORTH opposite:", ax2)
			assertEquals("opposite:", ax2.opposite().name(), ax.name());

			trace("ReferencingCsCodeListTest - test 3 :");
			assertEquals("SOUTH identifier:", "south", ax2.identifier());
			assertEquals("name:", "SOUTH", ax2.name());

			trace("ReferencingCsCodeListTest - test 4 :");
			var rm:RangeMeaning=RangeMeaning.EXACT;
			assertNotNull("RangeMeaning.EXACT", rm);
		}

	}

}
