package org.opengis.test.metadata.citation {
	import org.opengis.metadata.citation.DateType;
	import org.opengis.metadata.citation.OnLineFunction;
	import org.opengis.metadata.citation.PresentationForm;
	import org.opengis.metadata.citation.Role;
	import flexunit.framework.TestCase;

	/**
	 * Test enums of org.opengis.metadata.citation : DateType, OnLineFunction, PresentationForm, Role.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class CitationCodeListTest extends TestCase {

		/**
		 * Constructor
		 */
		public function CitationCodeListTest(methodName:String=null) {
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
		 * Test 1 : DateType.CREATION, name
		 * Test 2 : OnLineFunction.INFORMATION, identifier
		 * Test 3 : PresentationForm.MAP_DIGITAL
		 * Test 4 : Role.ORIGINATOR
		 */
		public function testCitationCodeListX1():void {
			trace("CitationCodeListTest - test 1 :");
			var dt:DateType=DateType.CREATION;
			assertNotNull("DateType.CREATION:", dt);
			assertEquals("name:", "CREATION", dt.name());

			trace("CitationCodeListTest - test 2 :");
			var olf:OnLineFunction=OnLineFunction.INFORMATION;
			assertNotNull("OnLineFunction.INFORMATION:", olf)
			assertEquals("identifier:", "information", olf.identifier());

			trace("CitationCodeListTest - test 3 :");
			var pf:PresentationForm=PresentationForm.MAP_DIGITAL;
			assertNotNull("PresentationForm.MAP_DIGITAL:", pf)

			trace("CitationCodeListTest - test 4 :");
			var ro:Role=Role.ORIGINATOR;
			assertNotNull("Role.ORIGINATOR;", ro);
		}

	}

}
