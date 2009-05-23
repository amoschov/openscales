package org.openscales.core.i18n
{
    import org.openscales.core.i18n.Lang;
    import flexunit.framework.TestCase;

    /**
     * Test Lang class.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public class LangTest extends TestCase {

        /**
         * Constructor
         */
        public function LangTest ( methodName:String= null ) {
            super(methodName);
        }

        /**
         * Initial state.
         * Sets up the fixture, this method is called before a test is executed.
         */
        override public function setUp ( ) : void {
        }

        /**
         * Clean up.
         * Tears down the fixture, this method is called after a test is executed.
         */
        override public function tearDown ( ) : void {
        }

        // It is important to keep in mind that the order that the test methods in a TestCase are run is
        // random. Each test should create its own data and make no assumptions about another test
        // having already run.

        /**
         * Test 1 : en, Lang.FR, size()
         */
        public function testLangX1 ( ) : void {
            trace("LangTest - test 1 :");
            assertTrue("'en' exists :", Lang.validate("en"));
            assertTrue("'Lang.FR' code is 'fr'", "fr", Lang.FR.code);
            trace("supported languages :"+Lang.size());
        }

    }

}
