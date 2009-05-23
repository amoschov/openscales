package org.openscales.core
{
    import org.openscales.core.i18n.Lang;
    import org.openscales.core.I18n;

    import flexunit.framework.TestCase;

    /**
     * Test Lang class.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public class I18nTest extends TestCase {

        /**
         * Constructor
         */
        public function I18nTest ( methodName:String= null ) {
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
         * Test 1 : Lang.EN, Lang.FR : __end__
         */
        public function testI18nX1 ( ) : void {
            trace("I18nTest - test 1 :");
            I18n.setLanguage(Lang.EN);
            assertEquals("'Lang.EN' '__end__' exists :", "", I18n.translate("__end__"));
            I18n.setLanguage(Lang.getInstance("fr"));
            assertEquals("'Lang.FR' '__end__' exists :", "", I18n.translate("__end__"));
        }

    }

}
