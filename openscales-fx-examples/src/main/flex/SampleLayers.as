package
{
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.MultiPointFeature;
	import org.openscales.core.feature.MultiPolygonFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.MultiPolygon;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.layer.osm.Mapnik;
	import org.openscales.core.layer.VectorLayer;

	public class SampleLayers
	{
		/**
		 * void constructor for the SampleLayers class wich is a collection of
		 * static functions returning some sample layers.
		 */
		public function SampleLayers() {
			// Nothing to do
		}

		/**
		 * Returns a sample layer of drawn features
		 */
		static public function baseLayerOSM():Mapnik {
			return new Mapnik("Mapnik", true);
		}
		
		/**
		 * Returns a sample layer of drawn features
		 */
		static public function features():VectorLayer {
			// Create the drawings layer and some useful variables
			var layer:VectorLayer = new VectorLayer("Drawing samples",false,true,"EPSG:4326");
			var style:Style;
			var arrayComponents:Array;
			var arrayVertices:Array;
			var point:org.openscales.core.geometry.Point;
			
			// Add some (black) objects for the tests of inclusion and
			//   intersection with all the features added below.
			style = new Style();
			style.fillColor = 0x999999;
			style.strokeColor = 0x000000;
			style.strokeWidth = 2;
			// A point inside of the MultiPolygon (its first polygon).
			point = new org.openscales.core.geometry.Point(4.649002075147177, 45.78235984585472);
			layer.addFeature(new PointFeature(point,null,style));
			//(layer.features[layer.features.length-1] as VectorFeature).id = "blackPoint1";
			// A point outside of the MultiPolygon but inside an excessive hole
			// of its third polygon.
			point = new org.openscales.core.geometry.Point(4.63114929194725, 45.692262077956364);
			layer.addFeature(new PointFeature(point,null,style));
			//(layer.features[layer.features.length-1] as VectorFeature).id = "blackPoint2";
			// A point outside of the blue Polygon but inside its BBOX.
			point = new org.openscales.core.geometry.Point(4.910228209414947, 45.73119410607873);
			layer.addFeature(new PointFeature(point,null,style));
			//(layer.features[layer.features.length-1] as VectorFeature).id = "blackPoint2";
			// A LineString intersecting all the other objects.
			arrayComponents = new Array();
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.5714111327782625, 45.76368130194846));
			  arrayComponents.push(new org.openscales.core.geometry.Point(5.117294311391419, 45.69513978441103));
			layer.addFeature(new LineStringFeature(new LineString(arrayComponents),null,style));
			//(layer.features[layer.features.length-1] as VectorFeature).id = "blackLineString";
			// A Polygon intersecting all the other objects.
			arrayComponents = new Array();
			arrayVertices = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.5727844237936415, 45.713361819965364));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.0300903319148516, 45.713361819965364));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.0300903319148516, 45.659157810588724));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.5727844237936415, 45.659157810588724));
			arrayComponents.push(new LinearRing(arrayVertices));
			layer.addFeature(new PolygonFeature(new Polygon(arrayComponents),null,style));
			//(layer.features[layer.features.length-1] as VectorFeature).id = "blackPolygon";
			
			// Add a Point.
			// This point is inside a hole of  the sample polygon: it must
			//   be selectable through the polygon.
			style = new Style();
			style.fillColor = 0xFF0000;
			style.strokeColor = 0xFF0000;
			point = new org.openscales.core.geometry.Point(4.830228209414947, 45.73119410607873);
			layer.addFeature(new PointFeature(point,null,style));
			//(layer.features[layer.features.length-1] as VectorFeature).id = "Point";
			
			// Add a MultiPoint.
			style = new Style();
			style.fillColor = 0xFF9900;
			style.strokeColor = 0xFF9900;
			arrayComponents = new Array();
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.841262817300238, 45.790978602336864));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.787704467700456, 45.78044438566825));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.789077758715836, 45.76463932817484));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.779411077427893, 45.737578114943204));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.805557250900384, 45.71959431070957));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.847442626869443, 45.704251544623304));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.877655029207781, 45.70808763101123));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.900314330961535, 45.73541212687354));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.939453124899837, 45.76942921252746));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.899627685453846, 45.78235984585472));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.863922119053991, 45.776613267874524));
			layer.addFeature(new MultiPointFeature(new MultiPoint(arrayComponents),null,style));
			//(layer.features[layer.features.length-1] as VectorFeature).id = "MultiPoint";
			
			// Add a LineString.
			style = new Style();
			style.fillColor = 0x33FF00;
			style.strokeColor = 0x33FF00;
			style.strokeWidth = 3;
			arrayComponents = new Array();
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.841262817300238, 45.806776194899484));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.759552001885187, 45.785711742833584));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.712173461854611, 45.76511833511852));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.72727966302378, 45.73828761221408));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.7980041503157995, 45.709046611476175));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.844009399330996, 45.69274170598194));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.901000976469224, 45.69657858210952));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.927780151269115, 45.73109862122825));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.999877929576513, 45.77182400046717));
			  arrayComponents.push(new org.openscales.core.geometry.Point(4.9483795164998, 45.790499817491956));
			layer.addFeature(new LineStringFeature(new LineString(arrayComponents),null,style));
			//(layer.features[layer.features.length-1] as VectorFeature).id = "LineString";
			
			// Add a MultiLineString.
			style = new Style();
			style.fillColor = 0xFF6600;
			style.strokeColor = 0xFF0000;
			style.strokeWidth = 5;
			arrayComponents = new Array();
			arrayVertices = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.051376342653225, 45.67595227768875));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.06030273425319, 45.69274170598194));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.08708190905308, 45.69466017695171));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.10012817369918, 45.704251544623304));
			arrayComponents.push(new LineString(arrayVertices));
			arrayVertices = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.970352172745865, 45.700894753090175));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.001251220591892, 45.68458747014324));
			  arrayVertices.push(new org.openscales.core.geometry.Point(5.047943115114779, 45.670194742323545));
			arrayComponents.push(new LineString(arrayVertices));
			arrayVertices = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.965545654192038, 45.70569010786783));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.959365844622833, 45.67835107594167));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.924346923730667, 45.66683590649083));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.915420532130705, 45.645718608921435));
			arrayComponents.push(new LineString(arrayVertices));
			layer.addFeature(new MultiLineStringFeature(new MultiLineString(arrayComponents),null,style));
			//(layer.features[layer.features.length-1] as VectorFeature).id = "MultiLineString";
			
			// Add a Polygon.
			style = new Style();
			style.fillColor = 0x0033FF;
			style.strokeColor = 0x0033FF;
			arrayComponents = new Array();
			arrayVertices = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.841262817300238, 45.790978602336864));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.787704467700456, 45.78044438566825));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.789077758715836, 45.76463932817484));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.779411077427893, 45.737578114943204));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.805557250900384, 45.71959431070957));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.847442626869443, 45.704251544623304));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.877655029207781, 45.70808763101123));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.900314330961535, 45.73541212687354));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.939453124899837, 45.76942921252746));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.899627685453846, 45.78235984585472));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.863922119053991, 45.776613267874524));
			arrayComponents.push(new LinearRing(arrayVertices));
			arrayVertices = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.873535156161644, 45.75889092403663));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.860488891515543, 45.75170458597825));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.872161865146266, 45.74547567775447));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.886581420807746, 45.75218370397337));
			arrayComponents.push(new LinearRing(arrayVertices));
			arrayVertices = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.830276489177206, 45.74451732248572));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.823410034100311, 45.73684988805274));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.823410034100311, 45.727743442058525));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.8426361083156175, 45.72726411429607));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.849502563392512, 45.73637063843944));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.844696044838685, 45.74403813868174));
			arrayComponents.push(new LinearRing(arrayVertices));
			layer.addFeature(new PolygonFeature(new Polygon(arrayComponents),null,style));
			//(layer.features[layer.features.length-1] as VectorFeature).id = "Polygon";
			
			// Add a MultiPolygon.
			var polygonArray:Array = new Array();
			style = new Style();
			style.fillColor = 0xFF00FF;
			style.strokeColor = 0xFF00FF;
			// 1st polygon
			arrayComponents = new Array();
			arrayVertices = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.587203979455121, 45.76559733794923));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.581024169885915, 45.74116294948335));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.535018920870719, 45.711443990657614));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.607116699178117, 45.73205720683009));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.652435302685625, 45.72726411429607));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.622909545854975, 45.74403813868174));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.631835937454939, 45.75266281785543));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.651062011670245, 45.747871493947756));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.648315429639488, 45.75793279909815));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.666168212839414, 45.778049967894205));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.670974731393241, 45.79815988146484));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.650375366162556, 45.79815988146484));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.624969482378044, 45.790499817491956));
			arrayComponents.push(new LinearRing(arrayVertices));
			arrayVertices = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.600936889608912, 45.76368130194846));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.601623535116601, 45.75170458597825));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.61672973628577, 45.75170458597825));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.6153564452703915, 45.76032808059674));
			arrayComponents.push(new LinearRing(arrayVertices));
			polygonArray.push(new Polygon(arrayComponents));
			// 2nd polygon
			arrayComponents = new Array();
			arrayVertices = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.6146697997627015, 45.82209079519674));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.613296508747322, 45.817305435010816));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.622909545854975, 45.81778398953689));
			arrayComponents.push(new LinearRing(arrayVertices));
			polygonArray.push(new Polygon(arrayComponents));
			// 3rd polygon
			arrayComponents = new Array();
			arrayVertices = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.603683471639669, 45.704251544623304));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.590637206993569, 45.70185385695145));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.577590942347468, 45.69657858210952));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.576217651332089, 45.68794524062948));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.581710815393605, 45.68266865365893));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.591323852501258, 45.680749771361995));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.602310180624291, 45.68027004050453));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.611236572224254, 45.68027004050453));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.6208496093319065, 45.68122949810618));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.627716064408801, 45.686026539317));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.628402709916491, 45.69370094969332));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.624969482378044, 45.700894753090175));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.6146697997627015, 45.70473106981803));
			arrayComponents.push(new LinearRing(arrayVertices));
			arrayVertices = new Array();
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.6208496093319065, 45.69609898698994));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.613296508747322, 45.68842490567441));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.63046264643956, 45.68266865365893));
			  arrayVertices.push(new org.openscales.core.geometry.Point(4.635269164993386, 45.69513978441103));
			arrayComponents.push(new LinearRing(arrayVertices));
			polygonArray.push(new Polygon(arrayComponents));
			// feature
			layer.addFeature(new MultiPolygonFeature(new MultiPolygon(polygonArray),null,style));
			//(layer.features[layer.features.length-1] as VectorFeature).id = "MultiPolygon";
			
			// return the vector layer
			return layer;
		}
		
		/**
		 * Returns a sample layer using the WFS 1.0.0 protocol
		 */
		/*static public function wfs100():WFS100 {
			// TODO
		}*/
		
		/**
		 * Returns a sample layer using the WFS 1.1.0 protocol
		 */
		/*static public function wfs110():WFS110 {
			// TODO
		}*/
		
	}
}