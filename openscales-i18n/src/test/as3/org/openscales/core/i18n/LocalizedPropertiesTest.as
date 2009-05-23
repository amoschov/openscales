package org.openscales.core.i18n
{
    import flash.events.Event;
    import flexunit.framework.TestCase;

    import org.openscales.core.i18n.Lang;
    import org.openscales.core.i18n.events.LanguageEvent;
    import org.openscales.core.i18n.LocalizedProperties;

    /**
     * Test org.openscales.core.i18n.LocalizedProperties class.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public class LocalizedPropertiesTest extends TestCase {

        /**
         * localized properties test 1.
         */
        private var _lp1:LocalizedProperties;

        /**
         * passthrough data for test 1.
         */
        private var _data1:Object;

        /**
         * Constructor
         */
        public function LocalizedPropertiesTest ( methodName:String= null ) {
            super(methodName);
        }

        /**
         * Initial state.
         * Sets up the fixture, this method is called before a test is executed.
         */
        override public function setUp ( ) : void {
            this._data1= {lang:Lang.EN};
        }

        /**
         * Clean up.
         * Tears down the fixture, this method is called after a test is executed.
         */
        override public function tearDown ( ) : void {
            this._lp1= null;
            this._data1= null;
        }

        // It is important to keep in mind that the order that the test methods in a TestCase are run is
        // random. Each test should create its own data and make no assumptions about another test
        // having already run.

        /**
         * Test 1 : testLocalizedProperties_en.properties, testLocalizedProperties_fr.properties
         */
        public function testLocalizedPropertiesX1 ( ) : void {
            trace("LocalizedPropertiesTest - test 1 :");
            this._lp1= new LocalizedProperties("testLocalizedProperties");
            assertNotNull("lp1:", this._lp1);
            this._lp1.addEventListener(
                LanguageEvent.LOADED_LANG,
                addAsync(
                    onLanguageLoaded,
                    500,
                    this._data1));
            this._lp1.addEventListener(
                LanguageEvent.FAILED_LOADING_LANG,
                addAsync(
                    onLanguageFailedLoaded,
                    500,
                    this._data1));
            // try to load testLocalizedProperties_en.properties :
            trace("loading 'en' ...");
            this._lp1.language= Lang.EN;
        }

        /**
         * Test 1 : asynchronous check : LanguageEvent.LOADED_LANG thrown ...
         */
        private function onLanguageLoaded ( e:Event, data:Object ) : void {
            trace("LOADED_LANG received ("+data.lang+")!");
            switch (data.lang.code) {
            case "en" :
                trace("... 'en' loaded");
                assertEquals("'en' loaded :", Lang.EN, (e as LanguageEvent).language);
                assertEquals("ok key:","loaded", this._lp1.translate("ok"));
                this._data1.lang= Lang.FR;
                // try to load testLocalizedProperties_fr.properties that does not exist :
                trace("loading 'fr' ...");
                this._lp1.language= Lang.FR;
                break;
            case "fr" :
                fail("LocalizedPropertiesTest - test 1 should have failed");
                break;
            default   :
                fail("LocalizedPropertiesTest - test 1 weird !");
                break;
            }
        }

        /**
         * Test 1 : asynchronous check : no LanguageEvent.LOADED_LANG thrown ...
         */
        private function onLanguageFailedLoaded ( e:Event, data:Object ) : void {
            trace("no LOADED_LANG received ("+data.lang+")!");
            switch (data.lang.code) {
            case "en" :
                fail("LocalizedPropertiesTest - test 1 not should have failed");
                break;
            case "fr" :
                trace("'fr' not loaded");
                assertEquals("'en' still current lang :", Lang.EN, this._lp1.language);
                break;
            default   :
                fail("LocalizedPropertiesTest - test 1 really weird !");
                break;
            }
        }

   }

}
