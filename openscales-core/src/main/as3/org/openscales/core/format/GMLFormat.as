package org.openscales.core.format
{
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLNode;

	import org.openscales.core.Util;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.MultiPolygon;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.proj4as.Proj4as;
	import org.openscales.proj4as.ProjPoint;
	import org.openscales.proj4as.ProjProjection;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.MultiPointFeature;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.feature.MultiPolygonFeature;
	import org.openscales.core.Trace;

	/**
	 * Read/Write GML. Supports the GML simple features profile.
	 */
	public class GMLFormat extends Format
	{
		protected var _featureNS:String = "http://openscales.org/OpenScales";

		protected var _featureName:String = "featureMember";

		protected var _featurePrefix:String = "OpenScales"; 

		protected var _layerName:String = "features";

		protected var _geometryName:String = "geometry";

		protected var _collectionName:String = "FeatureCollection";

		protected var _gmlns:String = "http://www.opengis.net/gml";

		protected var _gmlprefix:String = "gml";

		protected var _wfsns:String = "http://www.opengis.net/wfs";

		protected var _wfsprefix:String = "wfs";

		private var _extractAttributes:Boolean = true;

		private var _dim:Number;

		/**
		 * GMLFormat constructor
		 *
		 * @param extractAttributes
		 *
		 */
		public function GMLFormat(extractAttributes:Boolean = true) {
			this.extractAttributes = extractAttributes;
		}

		/**
		 * Read data
		 *
		 * @param data data to read/parse.
		 *
		 * @return features.
		 */
		override public function read(data:Object):Object {
			var dataXML:XML = null;
			if (typeof data == "string") { 
				dataXML = new XML(data);
			} else {
				dataXML = XML(data);
			}

			var featureNodes:XMLList = dataXML..*::featureMember;
			if (featureNodes.length() == 0) { return []; }

			var dim:int;
			var coordNodes:XMLList = featureNodes[0].*::posList;
			if (coordNodes.length() == 0) {
				coordNodes = featureNodes[0].*::pos;
			}
			if (coordNodes.length() > 0) {
				dim = coordNodes[0].@*::srsDimension;
			}    
			this.dim = (dim == 3) ? 3 : 2;

			var features:Array = [];

Trace.debug("GMLFormat.read : featureNodes.length()="+featureNodes.length());
			for (var i:int = 0; i < featureNodes.length(); i++) {
				var feature:VectorFeature = this.parseFeature(featureNodes[i]);

				if (feature) {
					features.push(feature);
				}
			}
			return features;
		}

		/**
		 *    It creates the geometries that are then attached to the returned
		 *    feature, and calls parseAttributes() to get attribute data out.
		 *
		 * @param node A XML feature node.
		 *
		 * @return A vetor of feature
		 */
		public function parseFeature(xmlNode:XML):VectorFeature {
			var geom:Collection = null;
			var p:Array = new Array();

			var feature:VectorFeature = null;

			if (xmlNode..*::the_geom.*::MultiPolygon.length() > 0) {
				var multipolygon:XML = xmlNode..*::the_geom.*::MultiPolygon[0];

				geom = new MultiPolygon();
				var polygons:XMLList = multipolygon..*::Polygon;
				for (var i:int = 0; i < polygons.length(); i++) {
					var polygon:Polygon = this.parsePolygonNode(polygons[i]);
					geom.addComponent(polygon);
				}
			} else if (xmlNode..*::the_geom.*::MultiLineString.length() > 0) {
				var multilinestring:XML = xmlNode..*::the_geom.*::MultiLineString[0];

				geom = new MultiLineString();
				var lineStrings:XMLList = multilinestring..*::LineString;

				for (i = 0; i < lineStrings.length(); i++) {
					p = this.parseCoords(lineStrings[i]);
					if(p){
						var lineString:LineString = new LineString(p);
						geom.addComponent(lineString);
					}
				}
			} else if (xmlNode..*::the_geom.*::MultiPoint.length() > 0) {
				var multiPoint:XML = xmlNode..*::the_geom.*::MultiPoint[0];

				geom = new MultiPoint();

				var points:XMLList = multiPoint..*::Point;

				for (i = 0; i < points.length(); i++) {
					p = this.parseCoords(points[i]);
					geom.addComponents(p[0]);
				}
			} else if (xmlNode..*::the_geom.*::Polygon.length() > 0) {
				var polygon2:XML = xmlNode..*::the_geom.*::Polygon[0];

				geom = this.parsePolygonNode(polygon2);
			} else if (xmlNode..*::the_geom.*::LineString.length() > 0) {
				var lineString2:XML = xmlNode..*::the_geom.*::LineString[0];

				p = this.parseCoords(lineString2);
				if (p) {
					geom = new LineString(p);
				}
			} else if (xmlNode..*::the_geom.*::Point.length() > 0) {
				var point:XML = xmlNode..*::the_geom.*::Point[0];

				geom = new MultiPoint();
				p = this.parseCoords(point);
				if (p) {
					geom.addComponent(p[0]);
				}
			}

			if (geom) {
				// Test more specific geom before because for is operator, a lineString is a multipoint for example (inheritance) 
				if (geom is MultiPolygon) {
					feature = new MultiPolygonFeature(geom as MultiPolygon);
				} else if (geom is Polygon) {
					feature = new PolygonFeature(geom as Polygon);
				} else if (geom is MultiLineString) {
					feature = new MultiLineStringFeature(geom as MultiLineString);
				} else if (geom is LineString) {
					feature = new LineStringFeature(geom as LineString);
				} else if (geom is MultiPoint) {
					feature = new MultiPointFeature(geom as MultiPoint);
				} else if (geom is Point) {
					feature = new PointFeature(geom as Point);
				} else {
					trace("Unrecognized geometry);"); 
					return null; 
				}

				feature.name = xmlNode..@fid;

				if (this.extractAttributes) {
					feature.attributes = this.parseAttributes(xmlNode);
				}    

				return feature;

			} else {
				return null;
			}
		}

		/**
		 * Parse attributes
		 *
		 * @param node A XML feature node.
		 *
		 * @return An attributes object.
		 */
		public function parseAttributes(xmlNode:XML):Object {
			var nodes:XMLList = xmlNode.children();
			var attributes:Object = {};
			for(var i:int = 0; i < nodes.length(); i++) {
				var name:String = nodes[i].localName();
				var value:Object = nodes[i].valueOf();
				if(name == null){
					continue;    
				}

				// Check for a leaf node
				if((nodes[i].children().length() == 1)
					&& !(nodes[i].children().children()[0] is XML)) {
					attributes[name] = value.children()[0].toXMLString();
				}
				Util.extend(attributes, this.parseAttributes(nodes[i]));
			}   
			return attributes;
		}

		/**
		 * Given a GML node representing a polygon geometry
		 *
		 * @param node
		 *
		 * @return A polygon geometry.
		 */
		public function parsePolygonNode(polygonNode:Object):Polygon {
			var linearRings:XMLList = polygonNode..*::LinearRing;
			// Optimize by specifying the array size
			var rings:Array = new Array(linearRings.length());
			for (var i:int = 0; i < linearRings.length(); i++) {
				rings[i] = new LinearRing(this.parseCoords(linearRings[i]));
			}
Trace.debug("GMLFormat.parsePolygonNode : rings="+rings.length);
			return new Polygon(rings);
		}

		/**
		 * Return an array of coords
		 */ 
		public function parseCoords(xmlNode:XML):Array {
			var x:Number, y:Number, left:Number, bottom:Number, right:Number, top:Number;

			var points:Array = new Array();

			if (xmlNode) {

				var coordNodes:XMLList = xmlNode.*::posList;

				if (coordNodes.length() == 0) { 
					coordNodes = xmlNode.*::pos;
				}    

				if (coordNodes.length() == 0) {
					coordNodes = xmlNode.*::coordinates;
				}    

				var coordString:String = coordNodes[0].text();

				var nums:Array = (coordString) ? coordString.split(/[, \n\t]+/) : [];

				while (nums[0] == "") 
					nums.shift();

				while (nums[nums.length-1] == "") 
					nums.pop();

				for(var i:int = 0; i < nums.length; i = i + this.dim) {
					x = Number(nums[i]);
					y = Number(nums[i+1]);
					var p:Point = new Point(x, y);
					if (this._internalProj != null, this._externalProj != null)
						p.transform(this.externalProj, this.internalProj);
					points.push(p);
				}
				return points
			}
			return points;
		}

		/**
		 * Generate a GML document object given a list of features.
		 *
		 * @param features List of features to serialize into an object.
		 *
		 * @return An object representing the GML document.
		 */
		override public function write(features:Object):Object {
			var featureCollection:XML = new XML("<" + this._wfsprefix + ":" + this._collectionName + " xmlns:" + this._wfsprefix + "=\"" + this._wfsns + "\"></" + this._wfsprefix + ":" + this._collectionName + ">");
			for (var i:int=0; i < features.length; i++) {
				featureCollection.appendChild(this.createFeatureXML(features[i]));
			}
			return featureCollection;
		}

		/**
		 * Accept a Vector feature, and build a GML node for it.
		 *
		 * @param feature The feature to be built as GML.
		 *
		 * @return A node reprensting the feature in GML.
		 */
		public function createFeatureXML(feature:VectorFeature):XML {
			var geometryNode:XML = this.buildGeometryNode(feature.geometry);
			var geomContainer:XML = new XML("<" + this._gmlprefix + ":" + this._geometryName + " xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":" + this._geometryName + ">");
			geomContainer.appendChild(geometryNode);
			var featureNode:XML = new XML("<" + this._gmlprefix + ":" + this._featureName + " xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":" + this._featureName + ">");
			var featureContainer:XML = new XML("<OpenScales:" + this._featureName + " xmlns:" + this._featurePrefix + "=\"" + this._featureNS + "\"></" + this._featurePrefix + ":" + this._layerName + ">");
			featureContainer.appendChild(geomContainer);
			for(var attr:String in feature.attributes) {
				var attrText:XMLNode = new XMLNode(2, feature.attributes[attr]); 
				var nodename:String = attr;
				if (attr.search(":") != -1) {
					nodename = attr.split(":")[1];
				}    
				var attrContainer:XML = new XML("<" + this._featurePrefix + ":" + nodename + " xmlns:" + this._featurePrefix + "=\"" + this._featureNS + "\"></" + this._featurePrefix + ":" + nodename + ">");
				attrContainer.appendChild(attrText);
				featureContainer.appendChild(attrContainer);
			}    
			featureNode.appendChild(featureContainer);
			return featureNode;
		}

		/**
		 * create a GML Object
		 *
		 * @param geometry
		 *
		 * @return an XML
		 */
		public function buildGeometryNode(geometry:Object):XML {
			var gml:XML;
			if (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPolygon"
				|| getQualifiedClassName(geometry) == "org.openscales.core.geometry::Polygon") {
				gml = new XML("<" + this._gmlprefix + ":MultiPolygon xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":MultiPolygon>");

				var polygonMember:XML = new XML("<" + this._gmlprefix + ":polygonMember xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":polygonMember>");

				var polygon:XML = new XML("<" + this._gmlprefix + ":Polygon xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":Polygon>");
				var outerRing:XML = new XML("<" + this._gmlprefix + ":outerBoundaryIs xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":outerBoundaryIs>");
				var linearRing:XML = new XML("<" + this._gmlprefix + ":LinearRing xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":LinearRing>");

				linearRing.appendChild(this.buildCoordinatesNode(geometry.components[0]));
				outerRing.appendChild(linearRing);
				polygon.appendChild(outerRing);
				polygonMember.appendChild(polygon);

				gml.appendChild(polygonMember);
			}
			else if (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiLineString"
				|| getQualifiedClassName(geometry) == "org.openscales.core.geometry::LineString") {
				gml = new XML("<" + this._gmlprefix + ":MultiLineString xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":MultiLineString>");

				var lineStringMember:XML = new XML("<" + this._gmlprefix + ":lineStringMember xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":lineStringMember>");

				var lineString:XML = new XML("<" + this._gmlprefix + ":LineString xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":LineString>");

				lineString.appendChild(this.buildCoordinatesNode(geometry));
				lineStringMember.appendChild(lineString);

				gml.appendChild(lineStringMember);
			}
			else if (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPoint") {

				gml = new XML("<" + this._gmlprefix + ":MultiPoint xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":MultiPoint>");
				var parts:Object = "";
				parts = geometry.components;   

				for (var i:int = 0; i < parts.length; i++) { 
					var pointMember:XML = new XML("<" + this._gmlprefix + ":pointMember xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":pointMember>");
					var point:XML = new XML("<" + this._gmlprefix + ":Point xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":Point>");
					point.appendChild(this.buildCoordinatesNode(parts[i]));
					pointMember.appendChild(point);
					gml.appendChild(pointMember);
				}     
			} else if (getQualifiedClassName(geometry) == "org.openscales.core.geometry::Point") {
				parts = geometry;
				gml = new XML("<" + this._gmlprefix + ":Point xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":Point>");
				gml.appendChild(this.buildCoordinatesNode(parts));
			}
			return gml; 
		}

		/**
		 * Builds the coordinates XmlNode
		 *
		 * @param geometry
		 *
		 * @return created xmlNode
		 */
		public function buildCoordinatesNode(geometry:Object):XML {
			var coordinatesNode:XML = new XML("<" + this._gmlprefix + ":coordinates xmlns:" + this._gmlprefix + "=\"" + this._gmlns + "\"></" + this._gmlprefix + ":coordinates>");
			coordinatesNode.@decimal = ".";
			coordinatesNode.@cs = ",";
			coordinatesNode.@ts = " ";

			var points:Array = null;
			if (geometry.components) {
				if (geometry.components.length > 0) {
					points = geometry.components;
				}
			}

			var path:String = "";
			if (points) {
				for (var i:int = 0; i < points.length; i++) {
					if (this.internalProj != null && this.externalProj != null)
						(points[i] as Point).transform(this.internalProj, this.externalProj);
					path += points[i].x + "," + points[i].y + " ";
				}
			} else {
				if (this.internalProj != null && this.externalProj != null) {
					var p:ProjPoint = new ProjPoint(geometry.x, geometry.y);
					Proj4as.transform(internalProj, externalProj, p);
					geometry.x = p.x;
					geometry.y = p.y;
				}
				path += geometry.x + "," + geometry.y + " ";
			}    

			coordinatesNode.appendChild(path);

			return coordinatesNode;
		}


		//Getters and Setters

		public function get extractAttributes():Boolean {
			return this._extractAttributes;
		}

		public function set extractAttributes(value:Boolean):void {
			this._extractAttributes = value;
		}

		public function get dim():Number {
			return this._dim;
		}

		public function set dim(value:Number):void {
			this._dim = value;
		}

		public function get internalProj():ProjProjection {
			return this._internalProj;
		}

		public function set internalProj(value:ProjProjection):void {
			this._internalProj = value;
		}

		public function get externalProj():ProjProjection {
			return this._externalProj;
		}

		public function set externalProj(value:ProjProjection):void {
			this._externalProj = value;
		}

	}
}

