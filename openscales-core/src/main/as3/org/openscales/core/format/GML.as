package org.openscales.core.format
{
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLNode;
	
	import org.openscales.core.Util;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.MultiPolygon;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	
	/**
	 * Read/Wite GML. Supports the GML simple features profile.
	 */
	public class GML extends Format
	{
		public var featureNS:String = "http://openscales.org/OpenScales";
	    
	    public var featureName:String = "featureMember";
	    
	    public var featurePrefix:String = "OpenScales"; 
	    
	    public var layerName:String = "features";
	    
	    public var geometryName:String = "geometry";
	    
	    public var collectionName:String = "FeatureCollection";
	    
	    public var gmlns:String = "http://www.opengis.net/gml";
	    
	    public var gmlprefix:String = "gml";
	    
	    public var wfsns:String = "http://www.opengis.net/wfs";
	    
	    public var wfsprefix:String = "wfs";
    
    	public var extractAttributes:Boolean = true;
    	
    	private var dim:Number;
    	
    	public function GML(options:Object):void {
    		super(options);
    	}
    	
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

	        for (var i:int = 0; i < featureNodes.length(); i++) {
	            var feature:Vector = this.parseFeature(featureNodes[i]);
	
	            if (feature) {
	                features.push(feature);
	            }
	        }
	        return features;
    	}
    	
    	public function parseFeature(xmlNode:XML):Vector {
    		var geom:Collection = null;
	        var p:Object = new Object();
	
	        var feature:Vector = new Vector();
			feature.fid = xmlNode..@fid;
			
	        if (xmlNode..*::the_geom.*::MultiPolygon.length() > 0) {
	            var multipolygon:XML = xmlNode..*::the_geom.*::MultiPolygon[0];
	            
	            geom = new MultiPolygon();
	            var polygons:XMLList = multipolygon..*::Polygon;
	            for (var i:int = 0; i < polygons.length(); i++) {
	                var polygon:Object = this.parsePolygonNode(polygons[i]);
	                geom.addComponents(polygon);
	            }
	        } else if (xmlNode..*::the_geom.*::MultiLineString.length() > 0) {
	            var multilinestring:XML = xmlNode..*::the_geom.*::MultiLineString[0];
	            
	            geom = new MultiLineString();
	            var lineStrings:XMLList = multilinestring..*::LineString;
	            
	            for (i = 0; i < lineStrings.length(); i++) {
	                p = this.parseCoords(lineStrings[i]);
	                if(p.points){
	                    var lineString:LineString = new LineString(p.points);
	                    geom.addComponents(lineString);
	                }
	            }
	        } else if (xmlNode..*::the_geom.*::MultiPoint.length() > 0) {
	            var multiPoint:XML = xmlNode..*::the_geom.*::MultiPoint[0];
	                
	            geom = new MultiPoint();
	            
	            var points:XMLList = multiPoint..*::Point;
	            
	            for (i = 0; i < points.length(); i++) {
	                p = this.parseCoords(points[i]);
	                geom.addComponents(p.points[0]);
	            }
	        } else if (xmlNode..*::the_geom.*::Polygon.length() > 0) {
	            var polygon2:XML = xmlNode..*::the_geom.*::Polygon[0];
	            
	            geom = this.parsePolygonNode(polygon2);
	        } else if (xmlNode..*::the_geom.*::LineString.length() > 0) {
	            var lineString2:XML = xmlNode..*::the_geom.*::LineString[0];
	
	            p = this.parseCoords(lineString2);
	            if (p.points) {
	                geom = new LineString(p.points);
	            }
	        } else if (xmlNode..*::the_geom.*::Point.length() > 0) {
	            var point:XML = xmlNode..*::the_geom.*::Point[0];
	            
	            p = this.parseCoords(point);
	            if (p.points) {
	                geom = p.points[0];
	            }
	        }
	        
	        if(geom) {
                
		        feature.geometry = geom; 
		        if (this.extractAttributes) {
		            feature.attributes = this.parseAttributes(xmlNode);
		        }    
		        
		        return feature;
		      
		      } else {
		      	return null;
		      }
    	}
    	
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
    	
    	public function parsePolygonNode(polygonNode:Object):Polygon {
    		var linearRings:XMLList = polygonNode..*::LinearRing;
	        
	        var rings:Array = [];
	        var p:Object;

	        for (var i:int = 0; i < linearRings.length(); i++) {
	            p = this.parseCoords(linearRings[i]);
	            var ring1:LinearRing = new LinearRing(p.points);
	            rings.push(ring1);
	        }
	        
	        var poly:Polygon = new Polygon(rings);
	        return poly;
    	}
    	
    	public function parseCoords(xmlNode:XML):Object {
    		var x:Number, y:Number, left:Number, bottom:Number, right:Number, top:Number;

	        var p:Object = new Object(); // return value = [points,bounds]
	        
	        if (xmlNode) {
	            p.points = [];

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
	                p.points.push(new Point(x, y));
	            }
	        }
	        return p;
    	}
    	
    	override public function write(features:Object):Object {
    		var featureCollection:XML = new XML("<" + this.wfsprefix + ":" + this.collectionName + " xmlns:" + this.wfsprefix + "=\"" + this.wfsns + "\"></" + this.wfsprefix + ":" + this.collectionName + ">");
	        for (var i:int=0; i < features.length; i++) {
	            featureCollection.appendChild(this.createFeatureXML(features[i]));
	        }
	        return featureCollection;
    	}
    	
    	public function createFeatureXML(feature:Vector):XML {
	        var geometryNode:XML = this.buildGeometryNode(feature.geometry);
	        var geomContainer:XML = new XML("<" + this.gmlprefix + ":" + this.geometryName + " xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":" + this.geometryName + ">");
	        geomContainer.appendChild(geometryNode);
	        var featureNode:XML = new XML("<" + this.gmlprefix + ":" + this.featureName + " xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":" + this.featureName + ">");
	        var featureContainer:XML = new XML("<OpenScales:" + this.featureName + " xmlns:" + this.featurePrefix + "=\"" + this.featureNS + "\"></" + this.featurePrefix + ":" + this.layerName + ">");
	        featureContainer.appendChild(geomContainer);
	        for(var attr:String in feature.attributes) {
	            var attrText:XMLNode = new XMLNode(2, feature.attributes[attr]); 
	            var nodename:String = attr;
	            if (attr.search(":") != -1) {
	                nodename = attr.split(":")[1];
	            }    
	            var attrContainer:XML = new XML("<" + this.featurePrefix + ":" + nodename + " xmlns:" + this.featurePrefix + "=\"" + this.featureNS + "\"></" + this.featurePrefix + ":" + nodename + ">");
	            attrContainer.appendChild(attrText);
	            featureContainer.appendChild(attrContainer);
	        }    
	        featureNode.appendChild(featureContainer);
	        return featureNode;
    	}
    	
    	public function buildGeometryNode(geometry:Object):XML {
	        var gml:XML;
	        if (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPolygon"
	            || getQualifiedClassName(geometry) == "org.openscales.core.geometry::Polygon") {
	                gml = new XML("<" + this.gmlprefix + ":MultiPolygon xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":MultiPolygon>");

	                var polygonMember:XML = new XML("<" + this.gmlprefix + ":polygonMember xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":polygonMember>");
	                
	                var polygon:XML = new XML("<" + this.gmlprefix + ":Polygon xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":Polygon>");
	                var outerRing:XML = new XML("<" + this.gmlprefix + ":outerBoundaryIs xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":outerBoundaryIs>");
	                var linearRing:XML = new XML("<" + this.gmlprefix + ":LinearRing xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":LinearRing>");

	                linearRing.appendChild(this.buildCoordinatesNode(geometry.components[0]));
	                outerRing.appendChild(linearRing);
	                polygon.appendChild(outerRing);
	                polygonMember.appendChild(polygon);
	                
	                gml.appendChild(polygonMember);
	            }
	        else if (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiLineString"
	                 || getQualifiedClassName(geometry) == "org.openscales.core.geometry::LineString") {
	                     gml = new XML("<" + this.gmlprefix + ":MultiLineString xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":MultiLineString>");
	                     
	                     var lineStringMember:XML = new XML("<" + this.gmlprefix + ":lineStringMember xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":lineStringMember>");
	                     
	                     var lineString:XML = new XML("<" + this.gmlprefix + ":LineString xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":LineString>");
	                     
	                     lineString.appendChild(this.buildCoordinatesNode(geometry));
	                     lineStringMember.appendChild(lineString);
	                     
	                     gml.appendChild(lineStringMember);
	                 }
	        else if (getQualifiedClassName(geometry) == "org.openscales.core.geometry::MultiPoint") {
	                     
	                gml = new XML("<" + this.gmlprefix + ":MultiPoint xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":MultiPoint>");
	                var parts:Object = "";
	                parts = geometry.components;   
	                
	                for (var i:int = 0; i < parts.length; i++) { 
	                    var pointMember:XML = new XML("<" + this.gmlprefix + ":pointMember xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":pointMember>");
	                    var point:XML = new XML("<" + this.gmlprefix + ":Point xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":Point>");
	                    point.appendChild(this.buildCoordinatesNode(parts[i]));
	                    pointMember.appendChild(point);
	                    gml.appendChild(pointMember);
	               }     
	        } else if (getQualifiedClassName(geometry) == "org.openscales.core.geometry::Point") {
	        	parts = geometry;
	        	gml = new XML("<" + this.gmlprefix + ":Point xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":Point>");
	        	gml.appendChild(this.buildCoordinatesNode(parts));
	        }
	        return gml; 
    	}
    	
    	public function buildCoordinatesNode(geometry:Object):XML {
    		var coordinatesNode:XML = new XML("<" + this.gmlprefix + ":coordinates xmlns:" + this.gmlprefix + "=\"" + this.gmlns + "\"></" + this.gmlprefix + ":coordinates>");
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
	                path += points[i].x + "," + points[i].y + " ";
	            }
	        } else {
	           path += geometry.x + "," + geometry.y + " ";
	        }    
	        
	        coordinatesNode.appendChild(path);
	        
	        return coordinatesNode;
    	}
    	
	}
}