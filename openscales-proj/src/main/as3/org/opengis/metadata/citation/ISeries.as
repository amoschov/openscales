/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/citation/Series.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.citation
{
    /**
     * Information about the series, or aggregate dataset, to which a dataset belongs.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public interface ISeries {

        /**
         * Name of the series, or aggregate dataset, of which the dataset is a part.
         *
         * @return The name of the series or aggregate dataset, null if none.
         */
        function get name ( ) : String;

        /**
         * Information identifying the issue of the series.
         *
         * @return Information identifying the issue of the series.
         */
        function get issueIdentification ( ) : String;

        /**
         * Details on which pages of the publication the article was published.
         *
         * @return Details on which pages of the publication the article was published.
         */
        function get page ( ) : String;

    }

}
