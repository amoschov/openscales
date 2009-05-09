/**
 * Copyright 2009 Institut Geographique National France, released under the MIT license.
 */
package org.openscales.coretest.i18n
{
    import flash.events.Event;
    import flexunit.framework.TestCase;

    import org.openscales.core.i18n.Lang;
    import org.openscales.core.i18n.events.LanguageEvent;
    import org.openscales.core.i18n.LocalizedClassProperties;

    import org.foo.MyClass;
    import org.foo.MyClass2;

    /**
     * Test org.openscales.core.i18n.LocalizedClassProperties class.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public class LocalizedClassPropertiesTest extends TestCase {

        /**
         * localized class properties test 1.
         */
        private var _lcp1:LocalizedClassProperties;

         /**
         * localized class properties test 2.
         */
        private var _lcp2:LocalizedClassProperties;

       /**
         * passthrough data for test 1.
         */
        private var _data1:Object;

        /**
         * Constructor
         */
        public function LocalizedClassPropertiesTest ( methodName:String= null ) {
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
            this._lcp1= null;
            this._lcp2= null;
            this._data1= null;
        }

        // It is important to keep in mind that the order that the test methods in a TestCase are run is
        // random. Each test should create its own data and make no assumptions about another test
        // having already run.

        /**
         * Test 1 : org/foo/MyClass_en.properties,
         *          org/foo/MyClass_fr.properties
         */
        public function testLocalizedClassPropertiesX1 ( ) : void {
            trace("LocalizedClassPropertiesTest - test 1 :");
            this._lcp1= new LocalizedClassProperties(MyClass);
            assertNotNull("lcp1:", this._lcp1);
            this._lcp1.addEventListener(
                LanguageEvent.LOADED_LANG,
                addAsync(
                    onLanguageLoaded,
                    500,
                    this._data1));
            this._lcp1.addEventListener(
                LanguageEvent.FAILED_LOADING_LANG,
                addAsync(
                    onLanguageFailedLoaded,
                    500,
                    this._data1));
            // try to load org/foo/MyClass_en.properties :
            trace("loading 'en' ...");
            this._lcp1.language= Lang.EN;
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
                assertEquals("ok key:","loaded", this._lcp1.translate("ok"));
                this._data1.lang= Lang.FR;
                // try to load org/foo/MyClass_fr.properties that does not exist :
                trace("loading 'fr' ...");
                this._lcp1.language= Lang.FR;
                break;
            case "fr" :
                fail("LocalizedClassPropertiesTest - test 1 should have failed");
                break;
            default   :
                fail("LocalizedClassPropertiesTest - test 1 weird !");
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
                fail("LocalizedClassPropertiesTest - test 1 not should have failed");
                break;
            case "fr" :
                trace("'fr' not loaded");
                assertEquals("'en' still current lang :", Lang.EN, this._lcp1.language);
                break;
            default   :
                fail("LocalizedClassPropertiesTest - test 1 really weird !");
                break;
            }
        }

        /**
         * Test 2 : in memory loading ...
         */
        public function testLocalizedClassPropertiesX2 ( ) : void {
            trace("LocalizedClassPropertiesTest - test 2 :");
            this._lcp2= new LocalizedClassProperties(MyClass2);
            assertNotNull("lcp2:", this._lcp2);
            this._lcp2.addEventListener(
                LanguageEvent.CHANGE_LANG,
                addAsync(
                    onLanguageChanged,
                    500));
            this._lcp2.setLocale(Lang.EN,
                {
                    "first.property" : "one",
                    "a text" : "whitespace property"
                });
            assertTrue("'en' loaded :", this._lcp2.contains(Lang.EN));
            this._lcp2.language= Lang.EN;
            assertEquals("'first.property' :", "one", this._lcp2.translate("first.property"));
            assertEquals("'a text' :", "whitespace property", this._lcp2.translate("a text"));
            this._lcp2.setLocale(Lang.FR,
                {
                    "first.property" : "un",
                    "a text" : "une propriété avec des espaces"
                });
            assertTrue("'fr' loaded :", this._lcp2.contains(Lang.FR));
            this._lcp2.language= Lang.FR;
            assertEquals("'first.property' :", "un", this._lcp2.translate("first.property"));
            assertEquals("'a text' :", "une propriété avec des espaces", this._lcp2.translate("a text"));
        }

        /**
         * Test 1 : asynchronous check : LanguageEvent.CHANGE_LANG thrown ...
         */
        private function onLanguageChanged ( e:Event ) : void {
            assertEquals("CHANGE_LANG received :", LanguageEvent.CHANGE_LANG, e.type);
            trace("CHANGE_LANG received !")
        }

   }

}
