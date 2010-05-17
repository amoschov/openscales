package org.openscales.core.format
{
	import flash.utils.getQualifiedClassName;
	
	import mx.core.ComponentDescriptor;
	
	import org.openscales.core.StringUtils;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.MultiPointFeature;
	import org.openscales.core.feature.MultiPolygonFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.MultiPolygon;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;

	/**
	 * Read/Write WKT.
	 */
	public class WKTFormat extends Format
	{
		
		private var _regExes:Object;
		
		/**
		 * Create a new parser for WKT
		 *
		 * @return A new WKT parser.
		 */
		public function WKTFormat()
		{
			this._regExes = {
					'typeStr': /^\s*(\w+)\s*\(\s*(.*)\s*\)\s*$/,
					'spaces': /\s+/,
					'parenComma': /\)\s*,\s*\(/,
					'doubleParenComma': /\)\s*\)\s*,\s*\(\s*\(/,
					'trimParens': /^\s*\(?(.*?)\)?\s*$/
				};
		}
		
		/**
		 * Deserialize a WKT string and return a vector feature or an
		 * array of vector features
		 *
		 * @param wkt A WKT string
		 *
		 * @return A feature or array of features for GEOMETRYCOLLECTION WKT.
		 */
		override public function read(wkt:Object):Object
		{
			var features:Object, type:String, args:String;
			var regex:RegExp = this._regExes.typeStr;
			var matches:Array = regex.exec(wkt as String);
			if (matches)
			{
				type = matches[1].toLowerCase();
				args = matches[2];
				features = parse(args, type);
			}
			return features;
		}
		
		/**
		 * Serialize a feature or array of features into a WKT string.
		 *
		 * @param features A feature or array of features
		 *
		 * @return The WKT string representation of the input geometries
		 */
		override public function write(features:Object):Object
		{
			var collection:Object, geom:Geometry, type:String, data:Object, isCollection:Boolean;
			
			if(features.constructor == Array)
			{
				collection = features;
				isCollection = true;
			}
			else
			{
				collection = [features];
				isCollection = false;
			}
			var pieces:Array = [];
			if(isCollection)
			{
				pieces.push('GEOMETRYCOLLECTION(');
			}
			for(var i:int=0; i<collection.length; ++i)
			{
				if(isCollection && i>0)
				{
					pieces.push(',');
				}
				geom = collection[i].geometry;
				type = getQualifiedClassName(geom).split('::')[1].toLowerCase();
				data = extract(geom);
				if (data == null)
					return null;
				pieces.push(type.toUpperCase() + '(' + data + ')');
			}
			if(isCollection)
			{
				pieces.push(')');
			}
			return pieces.join('');
		}
		
		private function extract(geometry:Geometry):String
		{
			if (geometry is Point)
			{
				return Point(geometry).x + ' ' + Point(geometry).y;
			}
			else if (geometry is MultiPoint)
			{
				var array:Array = [];
				for (var i:int = 0; i < MultiPoint(geometry).componentsLength; ++i)
					array.push(extract(MultiPoint(geometry).componentByIndex(i)));
				return array.join(',');
			}
			else if (geometry is LineString)
			{
				array = [];
				for (i = 0; i < LineString(geometry).componentsLength; ++i)
					array.push(extract(LineString(geometry).componentByIndex(i)));
				return array.join(',');
			}
			else if (geometry is MultiLineString)
			{
				array = [];
				for (i = 0; i < MultiLineString(geometry).componentsLength; ++i)
					array.push('(' + extract(MultiLineString(geometry).componentByIndex(i)) + ')');
				return array.join(',');
			}
			else if (geometry is Polygon)
			{
				array = [];
				for(i = 0; i < Polygon(geometry).componentsLength; ++i)
					array.push('(' + extract(Polygon(geometry).componentByIndex(i)) + ')');
				return array.join(',');
			}
			else if (geometry is MultiPolygon)
			{
				array = [];
				for(i = 0; i < MultiPolygon(geometry).componentsLength; ++i)
					array.push('(' + extract(MultiPolygon(geometry).componentByIndex(i)) + ')');
				return array.join(',');
			}
			return null;
		}
		
		private function parse(args:String, type:String):Object
		{
			if (type == "point")
			{
				var coords:Array = StringUtils.trim(args).split(this._regExes.spaces);
				return new PointFeature(new Point(coords[0], coords[1]));
			}
			else if (type == "multipoint")
			{
				var points:Array = StringUtils.trim(args).split(',');
				var components:Vector.<Geometry> = new Vector.<Geometry>(points.length);
				for (var i:int = 0; i < points.length; ++i)
					components[i] = parse(points[i], "point").geometry;
				return new MultiPointFeature(new MultiPoint(components));
			}
			else if (type == "linestring")
			{
				points = StringUtils.trim(args).split(',');
				components = new Vector.<Geometry>(points.length);
				for (i = 0; i < points.length; ++i)
					components[i] = parse(points[i], "point").geometry;
				return new LineStringFeature(new LineString(components));
			}
			else if (type == "multilinestring")
			{
				var line:String;
				var lines:Array = StringUtils.trim(args).split(this._regExes.parenComma);
				components = new Vector.<Geometry>(lines.length);
				for(i = 0; i < lines.length; ++i)
				{
					line = lines[i].replace(this._regExes.trimParens, '$1');
					components[i]=parse(line, "linestring").geometry;
				}
				return new MultiLineStringFeature( new MultiLineString(components) );
			}
			else if (type == "polygon")
			{
				var ring:String, lineString:LineString, linearRing:LinearRing;
				var rings:Array = StringUtils.trim(args).split(this._regExes.parenComma);
				components = new Vector.<Geometry>(rings.length);
				for(i = 0; i < rings.length; ++i)
				{
					ring = rings[i].replace(this._regExes.trimParens, '$1');
					lineString = parse(ring, "linestring").geometry;
					
					var ringComponents:Vector.<Geometry> = new Vector.<Geometry>(lineString.componentsLength);
					for (var j:int = 0; j < lineString.componentsLength; ++j)
						ringComponents[j]=lineString.componentByIndex(j);
					linearRing = new LinearRing(ringComponents);
					
					components[i] = linearRing;
				}
				return new PolygonFeature( new Polygon(components) );
			}
			else if (type == "multipolygon")
			{
				var polygon:String;
				var polygons:Array = StringUtils.trim(args).split(this._regExes.doubleParenComma);
				components =new Vector.<Geometry>(polygons.length);
				for(i = 0; i < polygons.length; ++i)
				{
					polygon = polygons[i].replace(this._regExes.trimParens, '$1');
					components[i] = parse(polygon, "polygon").geometry;
				}
				return new MultiPolygonFeature( new MultiPolygon(components) );
			}
			else if (type == "geometrycollection")
			{
				args = args.replace(/,\s*([A-Za-z])/g, '|$1');
				var wktArray:Array = StringUtils.trim(args).split('|');
				components = new Vector.<Geometry>(wktArray.length);
				for(i = 0; i < wktArray.length; ++i)
					components[i] = Vector.<Geometry>(new WKTFormat().read([wktArray[i]]));
				return components;
			}
			return null;
		}
		
	}
}