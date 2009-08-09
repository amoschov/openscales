package org.opengis.test.util {
	import org.opengis.util.CodeList;
	import flexunit.framework.TestCase;

	/**
	 * Test org.opengis.util code list base class.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class CodeListTest extends TestCase {

		/**
		 * Values for this test code list.
		 */
		private static var VALUES:Array;

		/**
		 * Constructor
		 */
		public function CodeListTest(methodName:String=null) {
			super(methodName);
		}

		/**
		 * Initial state.
		 * Sets up the fixture, this method is called before a test is executed.
		 */
		override public function setUp():void {
			CodeListTest.VALUES=new Array();
		}

		/**
		 * Clean up.
		 * Tears down the fixture, this method is called after a test is executed.
		 */
		override public function tearDown():void {
			CodeListTest.VALUES=null;
		}

		// It is important to keep in mind that the order that the test methods in a TestCase are run is
		// random. Each test should create its own data and make no assumptions about another test
		// having already run.

		/**
		 * Test 1 : new CodeList([], "MY_CODE_LIST_VALUE", "myCodeListValue")
		 * Test 2 : valueOf("MY_CODE_LIST_VALUE", "myCodeListValue")
		 * Test 3 : identifier, name, ordinal
		 */
		public function testCodeListX1():void {
			trace("CodeListTest - test 1 :");
			var cl:CodeList=new CodeList(CodeListTest.VALUES, "MY_CODE_LIST_VALUE", "myCodeListValue");
			assertNotNull("CodeList:", cl);
			assertEquals("className:", "CodeList", Object.prototype.toString.call(cl).match(/^\[object\s(.*)\]$/)[1]);

			trace("CodeListTest - test 2 :");
			var cl2:CodeList=CodeList.valueOf("MY_CODE_LIST_VALUE", "org.opengis.util::CodeList");
			assertEquals("codeListValue:", cl, cl2);

			trace("CodeListTest - test 3 :");
			assertEquals("identifier:", "myCodeListValue", cl.identifier());
			assertEquals("name:", "MY_CODE_LIST_VALUE", cl.name());
			assertEquals("ordinal", 0, cl.ordinal());
		}

	}

}
