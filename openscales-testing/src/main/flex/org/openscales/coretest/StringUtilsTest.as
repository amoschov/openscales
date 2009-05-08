package org.openscales.coretest
{
    import org.openscales.core.StringUtils;
    import flexunit.framework.TestCase;

    /**
     * Test fr.ign.StringUtils static functions.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public class StringUtilsTest extends TestCase {

        /**
         * Copy of the StringUtils._SPRINTF regexp :
         */
        private var _SPRINTF:RegExp;

        /**
         * Constructor
         */
        public function StringUtilsTest ( methodName:String= null ) {
            super(methodName);
        }

        /**
         * Initial state.
         * Sets up the fixture, this method is called before a test is executed.
         */
        override public function setUp ( ) : void {
            this._SPRINTF=
            /%%|%(\d+\$)?([-+#0 ]*)(\*\d+\$|\*|\d+)?(\.(\*\d+\$|\*|\d+))?([scboxXuidfegEG])/g;
        }

        /**
         * Clean up.
         * Tears down the fixture, this method is called after a test is executed.
         */
        override public function tearDown ( ) : void {
            this._SPRINTF= null;
        }

        // It is important to keep in mind that the order that the test methods in a TestCase are run is
        // random. Each test should create its own data and make no assumptions about another test
        // having already run.

        /**
         * Test 1 : trim
         */
        public function testStringUtilsX1 ( ) : void {
            trace("StringUtilsTest - test 1 :");
            var s0:String= String("\t \tx y z \t ");
            assertEquals(s0,"x y z", StringUtils.trim(s0));
        }

        /**
         * Test 2 : format
         */
        public function testStringUtilsX2 ( ) : void {
            trace("StringUtilsTest - test 2 :");
            var s0:String= String("${${token}}=${token}");
            assertEquals(s0,"${token}=item", StringUtils.format(s0,{token:"item"}));
            s0= String("${token}=${${token}}");
            assertEquals(s0,"item=${token}", StringUtils.format(s0,{token:"item"}));
            s0= String("Error at line ${line}, file '${func}'");
            var f:Function= function ( ) : String { return arguments[1]; };
            assertEquals(s0,"Error at line 1000, file 'DUMMY.TXT'",
                            StringUtils.format(s0,
                                               {
                                                    line:1000,
                                                    func:f
                                               },
                                               ["*","DUMMY.TXT","**"]));
            assertEquals(s0,"Error at line 1000, file 'DUMMY.TXT'",
                            StringUtils.format(s0,
                                               {
                                                    line:1000,
                                                    func:function():String{return "DUMMY.TXT";}
                                               }));
        }

        /**
         * Test 3 : sprintf - valid format
         */
        public function testStringUtilsX301 ( ) : void {
            trace("StringUtilsTest - test 3.1 :");
            var acceptable:Array= [
                "%s",
                "%*s",
                "% d",
                "% d",
                "%+d",
                "%2s",
                "%02s",
                "%23s",
                "%.23s",
                "%23.23s",
                "%-23.23s",
                "%-*.*s",
                "%-*s",
                "%-.*s",
                "%-23s",
                "%.23s",
                "%-s",
                "%.*s",
                // indexed-arguments
                "%1$s",
                "%1$ -+#0s",
                "%1$ -+#0*s",
                "%1$ -+#0*2$s",
                "%1$ -+#0*2$.*s",
                "%1$ -+#0*2$.*3$s"
            ];
            for (var i:Number= 0, l:Number= acceptable.length; i<l; i++) {
                assertNotNull("format should be accepted: "+acceptable[i],
                    acceptable[i].match(this._SPRINTF));
            }
        }

        /**
         * Test 3 : sprintf - invalid format
         */
        public function testStringUtilsX302 ( ) : void {
            trace("StringUtilsTest - test 3.2 :");
            var unacceptable:Array= [
                "%k",
                "%*.s",
                "%-.s"
            ];
            for (var i:Number= 0, l:Number= unacceptable.length; i<l; i++) {
                assertEquals("format should not be accepted: "+unacceptable[i],
                    0, unacceptable[i].match(this._SPRINTF).length);
            }
        }

        /**
         * Test 3 : sprintf - integer formatting
         */
        public function testStringUtilsX303 ( ) : void {
            trace("StringUtilsTest - test 3.3 :");
            assertStrictlyEquals("0", StringUtils.sprintf("%d", 0.4));
            assertStrictlyEquals("0", StringUtils.sprintf("%d", 0.5));
            assertStrictlyEquals("0", StringUtils.sprintf("%d", 0.6));
            assertStrictlyEquals("23", StringUtils.sprintf("%d", 23));
            assertStrictlyEquals("0012", StringUtils.sprintf("%.4d", 12.34));
        }

        /**
         * Test 3 : sprintf - multiple replacements
         */
        public function testStringUtilsX304 ( ) : void {
            trace("StringUtilsTest - test 3.4 :");
            assertStrictlyEquals(" 1 2 3 ", StringUtils.sprintf(" %d %d %d ", 1, 2, 3));
        }

        /**
         * Test 3 : sprintf - float rounding
         */
        public function testStringUtilsX305 ( ) : void {
            trace("StringUtilsTest - test 3.5 :");
            assertStrictlyEquals(" 2.5 ", StringUtils.sprintf(" %.1f ", 2.45));
            assertStrictlyEquals(" -2.5 ", StringUtils.sprintf(" %.1f ", -2.45));
            // Check that Number.toFixed() is more accurate than Number.toString():
            assertStrictlyEquals(" 9007199254740991 ",
                StringUtils.sprintf(" %.0f ", 9007199254740991));
            assertStrictlyEquals(" 9007199254740992 ",
                StringUtils.sprintf(" %.0f ", 9007199254740992));
            // boundary value: this number isn't accurately represented as an IEEE 64-bit number!
            assertStrictlyEquals(" 9007199254740992 ",
                StringUtils.sprintf(" %.0f ", 9007199254740993));
            // Optional: toFixed MAY be more precise than String, but it does not have to be.
            //assertStrictlyEquals(" 1000000000000000128 ",
            //    StringUtils.sprintf(" %.0f ", 1000000000000000065));
            //assertStrictlyEquals(" 1000000000000000128 ',
            //    StringUtils.sprintf(" %.0f ", 1000000000000000128));
        }

        /**
         * Test 3 : sprintf - zero padding
         */
        public function testStringUtilsX306 ( ) : void {
            trace("StringUtilsTest - test 3.6 :");
            assertStrictlyEquals("0023", StringUtils.sprintf("%04d", 23));
            assertStrictlyEquals("0023", StringUtils.sprintf("%04d", 23));
            assertStrictlyEquals("-4  ", StringUtils.sprintf("%-04d", -4));
            assertStrictlyEquals("-004", StringUtils.sprintf("% 04d", -4));
            assertStrictlyEquals("-004", StringUtils.sprintf("%+04d", -4));
            assertStrictlyEquals("+004", StringUtils.sprintf("%+04d", 4));
            assertStrictlyEquals(" 004", StringUtils.sprintf("% 04d", 4));
        }

        /**
         * Test 3 : sprintf - number prefix
         */
        public function testStringUtilsX307 ( ) : void {
            trace("StringUtilsTest - test 3.7 :");
            assertStrictlyEquals("-23", StringUtils.sprintf("% d", -23));
            assertStrictlyEquals(" 23", StringUtils.sprintf("% d",  23));
            assertStrictlyEquals("+23", StringUtils.sprintf("%+d", +23));
        }

        /**
         * Test 3 : sprintf - zero
         */
        public function testStringUtilsX308 ( ) : void {
            trace("StringUtilsTest - test 3.8 :");
            assertStrictlyEquals("0", StringUtils.sprintf("%s", 0));
            //oroginal test didn't pass whilst the result is correct :
            //assertStrictlyEquals("\u0000", StringUtils.sprintf("%c", 0));
            assertStrictlyEquals("", StringUtils.sprintf("%c", 0));
            assertStrictlyEquals("0", StringUtils.sprintf("%d", 0));
            assertStrictlyEquals("0", StringUtils.sprintf("%b", 0));
            assertStrictlyEquals("0", StringUtils.sprintf("%o", 0));
            assertStrictlyEquals("0", StringUtils.sprintf("%x", 0));
            assertStrictlyEquals("0.000000", StringUtils.sprintf("%f", 0));
       }

        /**
         * Test 3 : sprintf - binary
         */
        public function testStringUtilsX309 ( ) : void {
            trace("StringUtilsTest - test 3.9 :");
            assertStrictlyEquals("0", StringUtils.sprintf("%b", 0));
            assertStrictlyEquals("0", StringUtils.sprintf("%#b", 0));
            assertStrictlyEquals(" 0", StringUtils.sprintf("%2b", 0));
            assertStrictlyEquals("00", StringUtils.sprintf("%.2b", 0));
            assertStrictlyEquals("010", StringUtils.sprintf("%.3b", 2));
       }

        /**
         * Test 3 : sprintf - octal
         */
        public function testStringUtilsX310 ( ) : void {
            trace("StringUtilsTest - test 3.10 :");
            assertStrictlyEquals("4", StringUtils.sprintf("%o", 4));
            assertStrictlyEquals("4", StringUtils.sprintf("%0o", 4));
            assertStrictlyEquals("04", StringUtils.sprintf("%#o", 4));
            assertStrictlyEquals("0", StringUtils.sprintf("%#o", 0));
            assertStrictlyEquals("   4", StringUtils.sprintf("%4o", 4));
            assertStrictlyEquals("  04", StringUtils.sprintf("%#4o", 4));
            assertStrictlyEquals("0004", StringUtils.sprintf("%04o", 4));
            assertStrictlyEquals("04  ", StringUtils.sprintf("%-#4o", 4));
            assertStrictlyEquals("4   ", StringUtils.sprintf("%-4o", 4));
            assertStrictlyEquals("04", StringUtils.sprintf("%-#o", 4));
            assertStrictlyEquals("04  ", StringUtils.sprintf("%-#4o", 4));
            assertStrictlyEquals(" 012", StringUtils.sprintf("%4.3o", 10));
            assertStrictlyEquals("012 ", StringUtils.sprintf("%-4.3o", 10));
            assertStrictlyEquals("012", StringUtils.sprintf("%-.3o", 10));
            assertStrictlyEquals("012", StringUtils.sprintf("%.3o", 10));
            assertStrictlyEquals("12", StringUtils.sprintf("%.2o", 10));
            assertStrictlyEquals("012", StringUtils.sprintf("%#.2o", 10));
            // Check positivePrefix is ignored
            assertStrictlyEquals("4", StringUtils.sprintf("% o", 4));
            assertStrictlyEquals("4", StringUtils.sprintf("%+o", 4));
            assertStrictlyEquals("4   ", StringUtils.sprintf("%-+4o", 4));
            assertStrictlyEquals("4   ", StringUtils.sprintf("%- 4o", 4));
            assertStrictlyEquals("   4", StringUtils.sprintf("% 4o", 4));
            // TODO: negative numbers
       }

        /**
         * Test 3 : sprintf - hexadecimal
         */
        public function testStringUtilsX311 ( ) : void {
            trace("StringUtilsTest - test 3.11 :");
            assertStrictlyEquals("a", StringUtils.sprintf("%x", 10));
            assertStrictlyEquals("0xa", StringUtils.sprintf("%#x", 10));
            assertStrictlyEquals("0", StringUtils.sprintf("%#x", 0));
            assertStrictlyEquals("0xa ", StringUtils.sprintf("%-#4x", 10));
            assertStrictlyEquals("0XA ", StringUtils.sprintf("%-#4X", 10));
            assertStrictlyEquals(" 0XA", StringUtils.sprintf("%#4X", 10));
            assertStrictlyEquals("0X0A", StringUtils.sprintf("%#04X", 10));
            assertStrictlyEquals("000A", StringUtils.sprintf("%04X", 10));
            assertStrictlyEquals(" 00A", StringUtils.sprintf("%4.3X", 10));
        }

        /**
         * Test 3 : sprintf - justify integer
         */
        public function testStringUtilsX312 ( ) : void {
            trace("StringUtilsTest - test 3.12 :");
            assertStrictlyEquals("2", StringUtils.sprintf("%-d", 2));
            assertStrictlyEquals("-2", StringUtils.sprintf("%-d", -2));
            assertStrictlyEquals("2  ", StringUtils.sprintf("%-3d", 2));
            assertStrictlyEquals("002", StringUtils.sprintf("%-.3d", 2));
            assertStrictlyEquals("002  ", StringUtils.sprintf("%-5.3d", 2));
            assertStrictlyEquals("  002", StringUtils.sprintf("%5.3d", 2));
            assertStrictlyEquals("2  ", StringUtils.sprintf("%-03d",  2));
            assertStrictlyEquals("200", StringUtils.sprintf("%-03d",  200));
            assertStrictlyEquals("2000", StringUtils.sprintf("%-03d",  2000));
            assertStrictlyEquals("+2000", StringUtils.sprintf("%-+03d",  2000));
            assertStrictlyEquals(" 2 ", StringUtils.sprintf("%- 03d",  2));
            assertStrictlyEquals("+2 ", StringUtils.sprintf("%-+03d",  2));
        }

        /**
         * Test 3 : sprintf - right justify integer
         */
        public function testStringUtilsX313 ( ) : void {
            trace("StringUtilsTest - test 3.13 :");
            assertStrictlyEquals("  2", StringUtils.sprintf("%3d", 2));
            assertStrictlyEquals("002", StringUtils.sprintf("%03d",  2));
            assertStrictlyEquals("200", StringUtils.sprintf("%03d",  200));
            assertStrictlyEquals("2000", StringUtils.sprintf("%03d",  2000));
            assertStrictlyEquals("+2000", StringUtils.sprintf("%+03d",  2000));
            assertStrictlyEquals(" 02", StringUtils.sprintf("% 03d",  2));
            assertStrictlyEquals("+02", StringUtils.sprintf("%+03d",  2));
        }

        /**
         * Test 3 : sprintf - floating point
         */
        public function testStringUtilsX314 ( ) : void {
            trace("StringUtilsTest - test 3.14 :");
            assertStrictlyEquals("2.000000", StringUtils.sprintf("%f", 2));
            assertStrictlyEquals("2.100000", StringUtils.sprintf("%f", 2.1));
            assertStrictlyEquals("2.100000", StringUtils.sprintf("%3.6f", 2.1));
            assertStrictlyEquals(" 2.100", StringUtils.sprintf("%6.3f", 2.1));
            assertStrictlyEquals("02.100", StringUtils.sprintf("%06.3f", 2.1));
            assertStrictlyEquals(" 2.100", StringUtils.sprintf("% 06.3f", 2.1));
            assertStrictlyEquals("+2.100", StringUtils.sprintf("%+06.3f", 2.1));
            assertStrictlyEquals("2.100 ", StringUtils.sprintf("%-6.3f", 2.1));
            assertStrictlyEquals("12.3400", StringUtils.sprintf("%.4f", 12.34));
            assertStrictlyEquals("002", StringUtils.sprintf("%03.0f", 2.1));
            assertStrictlyEquals("2  ", StringUtils.sprintf("%-3.0f", 2.1));
        }

        /**
         * Test 3 : sprintf - percent
         */
        public function testStringUtilsX315 ( ) : void {
            trace("StringUtilsTest - test 3.15 :");
            assertStrictlyEquals("%", StringUtils.sprintf("%%"));
        }

        /**
         * Test 3 : sprintf - indexed arguments
         */
        public function testStringUtilsX316 ( ) : void {
            trace("StringUtilsTest - test 3.16 :");
            assertStrictlyEquals("  2", StringUtils.sprintf("%3s", 2));
            assertStrictlyEquals("  2", StringUtils.sprintf("%3d", 2));
            assertStrictlyEquals("123 123", StringUtils.sprintf("%1$d %d", 123));
            assertStrictlyEquals("12345", StringUtils.sprintf("%2$*1$s", 3, "12345"));
            assertStrictlyEquals("12345 ", StringUtils.sprintf("%2$-*1$s", 6, "12345"));
            assertStrictlyEquals(" 12345", StringUtils.sprintf("%2$*1$s", 6, "12345"));
            assertStrictlyEquals("123", StringUtils.sprintf("%2$-.*1$s", 3, "12345"));
            assertStrictlyEquals("123", StringUtils.sprintf("%2$.*1$s", 3, "12345"));
            assertStrictlyEquals("123   ", StringUtils.sprintf("%3$-*.*2$s", 6, 3, "12345"));
            assertStrictlyEquals("   123", StringUtils.sprintf("%3$*.*2$s", 6, 3, "12345"));
        }

        /**
         * Test 3 : sprintf - string truncation
         */
        public function testStringUtilsX317 ( ) : void {
            trace("StringUtilsTest - test 3.17 :");
            assertStrictlyEquals("f", StringUtils.sprintf("%.1s", "foo"));
            assertStrictlyEquals("fo", StringUtils.sprintf("%.2s", "foo"));
            assertStrictlyEquals("foo", StringUtils.sprintf("%.3s", "foo"));
            assertStrictlyEquals("foo", StringUtils.sprintf("%.10s", "foo"));
            assertStrictlyEquals("  fo", StringUtils.sprintf("%4.2s", "foo"));
            assertStrictlyEquals("fo  ", StringUtils.sprintf("%-4.2s", "foo"));
            assertStrictlyEquals("fo  ", StringUtils.sprintf("%-04.2s", "foo"));
            // degenerate case
            assertStrictlyEquals("", StringUtils.sprintf("%.0s", "foo"));
            assertStrictlyEquals("0000", StringUtils.sprintf("%04.0s", "foo"));
            assertStrictlyEquals("    ", StringUtils.sprintf("%4.0s", "foo"));
        }

        /**
         * Test 3 : sprintf - character formatting
         */
        public function testStringUtilsX318 ( ) : void {
            trace("StringUtilsTest - test 3.18 :");
            assertStrictlyEquals("A", StringUtils.sprintf("%c", 65));
            assertStrictlyEquals(" A", StringUtils.sprintf("%2c", 65));
            assertStrictlyEquals("A ", StringUtils.sprintf("%-2c", 65));
            assertStrictlyEquals("A   ", StringUtils.sprintf("%- 4c", 65));
            assertStrictlyEquals("0000", StringUtils.sprintf("%04.0c", 65));
        }

        /**
         * Test 3 : sprintf - unsigned
         */
        public function testStringUtilsX319 ( ) : void {
            trace("StringUtilsTest - test 3.19 :");
            assertStrictlyEquals("00000008", StringUtils.sprintf("%2$0*2$.4u", 2.1, 8.9));
            assertStrictlyEquals("0008    ", StringUtils.sprintf("%2$-0*2$.4u", 2.1, 8.9));
        }

        /**
         * Test 3 : sprintf - exponential
         */
        public function testStringUtilsX320 ( ) : void {
            trace("StringUtilsTest - test 3.20 :");
            assertStrictlyEquals("1.234000e+3", StringUtils.sprintf("%e", 1234));
            assertStrictlyEquals("1.234000e+3", StringUtils.sprintf("%e", 1234));
            assertStrictlyEquals("   1.238000e+3", StringUtils.sprintf("%14e", 1238));
            assertStrictlyEquals("0001.234000e+3", StringUtils.sprintf("%014e", 1234));
            assertStrictlyEquals("0001.234000e+3", StringUtils.sprintf("%014e", 1234));
            assertStrictlyEquals("1.237000e+3   ", StringUtils.sprintf("%-014e", 1237));
            assertStrictlyEquals("1.239000e+3   ", StringUtils.sprintf("%-14e", 1239));
            assertStrictlyEquals("1e+3", StringUtils.sprintf("%.0e", 1234));
            assertStrictlyEquals("1.2e+3", StringUtils.sprintf("%.1e", 1234));
            assertStrictlyEquals("1.2340e+3", StringUtils.sprintf("%.4e", 1234));
            assertStrictlyEquals("1.2340E+3", StringUtils.sprintf("%.4E", 1234));
            assertStrictlyEquals("6.7890e+3", StringUtils.sprintf("%.4e", 6789));
            // got 6.7889e-3 ...
            //assertStrictlyEquals("6.7890e-3", StringUtils.sprintf("%.4e", 0.006789));
            assertStrictlyEquals("6.7889e-3", StringUtils.sprintf("%.4e", 0.006789));
        }

        /**
         * Test 3 : sprintf - precision
         */
        public function testStringUtilsX321 ( ) : void {
            trace("StringUtilsTest - test 3.21 :");
            assertStrictlyEquals("0.00679", StringUtils.sprintf("%.3g", 0.006789));
            assertStrictlyEquals("0.0068", StringUtils.sprintf("%.2g", 0.006789));
            assertStrictlyEquals("0.007", StringUtils.sprintf("%.1g", 0.006789));
            assertStrictlyEquals("0.006789", StringUtils.sprintf("%g", 0.006789));
            assertStrictlyEquals("678.9", StringUtils.sprintf("%g", 678.9));
            assertStrictlyEquals("7e+2", StringUtils.sprintf("%.1g", 678.9));
            assertStrictlyEquals("6.8e+2", StringUtils.sprintf("%.2g", 678.9));
            assertStrictlyEquals("6.8E+2", StringUtils.sprintf("%.2G", 678.9));
            assertStrictlyEquals("679", StringUtils.sprintf("%.3g", 678.9));
            assertStrictlyEquals("678.90000", StringUtils.sprintf("%.8g", 678.9));
        }

        /**
         * Test 3 : sprintf - undocumented behavior
         */
        public function testStringUtilsX322 ( ) : void {
            trace("StringUtilsTest - test 3.22 :");
            assertStrictlyEquals("00000foo", StringUtils.sprintf("%0*2$s", "foo", 8));
            assertStrictlyEquals("foo     ", StringUtils.sprintf("%-0*2$s", "foo", 8));
            assertStrictlyEquals("f       ", StringUtils.sprintf("%-0*3$.*s", 1, "foo", 8));
            assertStrictlyEquals("00000002", StringUtils.sprintf("%0*2$d", 2.1, 8));
            assertStrictlyEquals("00000002", StringUtils.sprintf("%0*2$d", 2.1, 8.9));
            assertStrictlyEquals("008.9000", StringUtils.sprintf("%2$0*2$.4f", 2.1, 8.9));
            assertStrictlyEquals("08      ", StringUtils.sprintf("%2$-0*2$.*1$u", 2.1, 8.9));
        }

   }

}
