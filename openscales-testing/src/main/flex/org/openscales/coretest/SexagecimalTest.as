package org.openscales.coretest
{
    import org.openscales.core.Util;

    import flexunit.framework.TestCase;

    /**
     * Test Lang class.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public class SexagecimalTest extends TestCase {

        /**
         * Data set for tests
         */
        private static var _PMS:Array=[
            {//Greenwich:
                dms:"0dE",
                dec:0.0,
                dir:[],
                sexa:"   0° 00' 00.000\""
            },
            {//Washington
                dms:"77° 3' 2.3'' W",
                dec:-77.050638889,
                dir:null,
                sexa:" -77° 03' 02.300\""
            },
            {//Paris
                dms:"2.2014025",
                dec:2.337229167,
                dir:["E","W"],
                sexa:"   2° 20' 14.025\" E"
            }
        ];

        /**
         * Constructor
         */
        public function SexagecimalTest ( methodName:String= null ) {
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
         * Test 1 : dms to degree
         */
        public function testSexagecimalX1 ( ) : void {
            trace("SexagecimalTest - test 1 :");
            var dec:Number;
            for (var i:Number= 0, l:Number= _PMS.length; i<l; i++) {
                    dec= Util.dmsToDeg(_PMS[i].dms);
                    assertEquals("dmsToDeg :",_PMS[i].dec.toFixed(6), dec.toFixed(6));
            }
        }

        /**
         * Test 2 : degree to dms
         */
        public function testSexagecimalX2 ( ) : void {
            trace("SexagecimalTest - test 2 :");
            var dms:String;
            for (var i:Number= 0, l:Number= _PMS.length; i<l; i++) {
                    dms= Util.degToDMS(_PMS[i].dec, _PMS[i].dir, 3);
                    assertEquals("degToDMS :",_PMS[i].sexa, dms);
            }
        }

    }

}
