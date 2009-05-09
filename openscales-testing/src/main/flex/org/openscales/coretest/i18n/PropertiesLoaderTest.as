package org.openscales.coretest.i18n
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import org.openscales.core.i18n.PropertiesLoader;
    import flexunit.framework.TestCase;

    /**
     * Test PropertiesLoader class.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public class PropertiesLoaderTest extends TestCase {

        /**
         * loader test 1.
         */
        private var _rpl1:PropertiesLoader;

        /**
         * loader test 2.
         */
        private var _rpl2:PropertiesLoader;

        /**
         * loader test 3.
         */
        private var _rpl3:PropertiesLoader;

        /**
         * aggregated properties test 3.
         */
        private var _prs3:Object;

        /**
         * Constructor
         */
        public function PropertiesLoaderTest ( methodName:String= null ) {
            super(methodName);
        }

        /**
         * Initial state.
         * Sets up the fixture, this method is called before a test is executed.
         */
        override public function setUp ( ) : void {
            this._prs3= {
                en:{},
                fr:{}
            };
        }

        /**
         * Clean up.
         * Tears down the fixture, this method is called after a test is executed.
         */
        override public function tearDown ( ) : void {
            this._rpl1= null;
            this._rpl2= null;
            this._rpl3= null;
            this._prs3= null;
        }

        // It is important to keep in mind that the order that the test methods in a TestCase are run is
        // random. Each test should create its own data and make no assumptions about another test
        // having already run.

        /**
         * Test 1 : new PropertiesLoader(), source=none.txt
         */
        public function testPropertiesLoaderX1 ( ) : void {
            trace("PropertiesLoaderTestX1 - test 1 :");
            this._rpl1= new PropertiesLoader();
            assertNotNull("rpl1:", this._rpl1);
            this._rpl1.addEventListener(
                IOErrorEvent.IO_ERROR,
                addAsync(
                    checkOkAsyncPropertiesLoaderX1,
                    500,
                    {},
                    checkNOkAsyncPropertiesLoaderX1));
            this._rpl1.source= "none.txt";
            this._rpl1.loadTextData();
        }

        /**
         * Test 1 : asynchronous check : IOErrorEvent.IO_ERROR thrown ...
         */
        private function checkOkAsyncPropertiesLoaderX1 ( e:Event, data:Object ) : void {
            this._rpl1.errorText= (e as IOErrorEvent).text;
            assertNotNull("errorText:", this._rpl1.errorText);
            trace(this._rpl1.errorText+" ### OK catched");
            assertNull("properties:", this._rpl1.properties);
        }

        /**
         * Test 1 : asynchronous check : no IOErrorEvent.IO_ERROR thrown ...
         */
        private function checkNOkAsyncPropertiesLoaderX1 ( data:Object ) : void {
            fail("PropertiesLoaderTestX1 - test 1 should have failed");
        }

        /**
         * Test 2 : new PropertiesLoader(), source=test2.properties
         */
        public function testPropertiesLoaderX2 ( ) : void {
            trace("PropertiesLoaderTestX2 - test 2 :");
            this._rpl2= new PropertiesLoader();
            assertNotNull("rpl2:", this._rpl2);
            this._rpl2.addEventListener(
                Event.COMPLETE,
                addAsync(
                    checkOkAsyncPropertiesLoaderX2,
                    500,
                    {},
                    checkNOkAsyncPropertiesLoaderX2));
            this._rpl2.source= "test2.properties";
            this._rpl2.loadTextData();
        }

        /**
         * Test 2 : asynchronous check : Event.COMPLETE thrown ...
         */
        private function checkOkAsyncPropertiesLoaderX2 ( e:Event, data:Object ) : void {
            assertNull("errorText:", this._rpl2.errorText);
            this._rpl2.properties= this._rpl2.parse(this._rpl2.data);
            assertNotNull("properties:", this._rpl2.properties);
            for (var p:String in this._rpl2.properties) {
                trace("["+p+"]=["+this._rpl2.properties[p]+"]");
            }
            this._rpl2.close();
        }

        /**
         * Test 2 : asynchronous check : no Event.COMPLETE thrown ...
         */
        private function checkNOkAsyncPropertiesLoaderX2 ( data:Object ) : void {
            fail("PropertiesLoaderTest - test 2 should not have failed");
        }

        /**
         * Test 3 : new PropertiesLoader(), source=test2.properties, test3.properties
         */
        public function testPropertiesLoaderX3 ( ) : void {
            trace("PropertiesLoaderTestX3 - test 3 :");
            this._rpl3= new PropertiesLoader();
            assertNotNull("rpl3:", this._rpl3);
            this._rpl3.addEventListener(
                Event.COMPLETE,
                addAsync(
                    checkOkAsyncPropertiesLoaderX3,
                    500,
                    {lang:"en"},
                    checkNOkAsyncPropertiesLoaderX3));
            this._rpl3.source= "test2.properties";
            this._rpl3.loadTextData();
        }

        /**
         * Test 3 : asynchronous check : Event.COMPLETE thrown ...
         */
        private function checkOkAsyncPropertiesLoaderX3 ( e:Event, data:Object ) : void {
            assertNull("errorText:", this._rpl3.errorText);
            this._prs3[data.lang]= this._rpl3.parse(this._rpl3.data);
            assertNotNull("properties:", this._prs3[data.lang]);
            if (data.lang=="en") {
                this._rpl3.addEventListener(
                    Event.COMPLETE,
                    addAsync(
                        checkOkAsyncPropertiesLoaderX3,
                        500,
                        {lang:"fr"},
                        checkNOkAsyncPropertiesLoaderX3));
                this._rpl3.source= "test3.properties";
                this._rpl3.loadTextData();
            }
            for (var l:String in this._prs3) {
                for (var p:String in this._prs3[l]) {
                    trace("["+l+"]["+p+"]=["+this._prs3[l][p]+"]");
                }
            }
        }

        /**
         * Test 3 : asynchronous check : no Event.COMPLETE thrown ...
         */
        private function checkNOkAsyncPropertiesLoaderX3 ( data:Object ) : void {
            fail("PropertiesLoaderTest - test 3 should not have failed");
        }

    }

}
