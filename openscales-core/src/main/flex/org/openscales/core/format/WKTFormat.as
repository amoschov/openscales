package org.openscales.core.format
{
	import flash.utils.getQualifiedClassName;
	
	import mx.core.ComponentDescriptor;
	
	import org.openscales.StringUtils;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.MultiPointFeature;
	import org.openscales.core.feature.MultiPolygonFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.geometry.Geometry;
	import org.openscales.geometry.LineString;
	import org.openscales.geometry.LinearRing;
	import org.openscales.geometry.MultiLineString;
	import org.openscales.geometry.MultiPoint;
	import org.openscales.geometry.MultiPolygon;
	import org.openscales.geometry.Point;
	import org.openscales.geometry.Polygon;

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
			var i:int = 0;
			var j:int = collection.length
			for(i; i<j; ++i)
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
			var i:int;
			var j:int;
			if (geometry is Point)
			{
				return Point(geometry).x + ' ' + Point(geometry).y;
			}
			else if (geometry is MultiPoint)
			{
				var array:Array = [];
				j = MultiPoint(geometry).componentsLength;
				for (i = 0; i < j; ++i)
					array.push(extract(MultiPoint(geometry).componentByIndex(i)));
				return array.join(',');
			}
			else if (geometry is LineString)
			{
				array = [];
				j = LineString(geometry).componentsLength;
				for (i = 0; i < j; ++i)
					array.push(extract(LineString(geometry).componentByIndex(i)));
				return array.join(',');
			}
			else if (geometry is MultiLineString)
			{
				array = [];
				j = MultiLineString(geometry).componentsLength;
				for (i = 0; i < j; ++i)
					array.push('(' + extract(MultiLineString(geometry).componentByIndex(i)) + ')');
				return array.join(',');
			}
			else if (geometry is Polygon)
			{
				array = [];
				j = Polygon(geometry).componentsLength;
				for(i = 0; i < j; ++i)
					array.push('(' + extract(Polygon(geometry).componentByIndex(i)) + ')');
				return array.join(',');
			}
			else if (geometry is MultiPolygon)
			{
				array = [];
				j = MultiPolygon(geometry).componentsLength;
				for(i = 0; i < j; ++i)
					array.push('(' + extract(MultiPolygon(geometry).componentByIndex(i)) + ')');
				return array.join(',');
			}
			return null;
		}
		
		private function parse(args:String, type:String):Object
		{
			var i:int;
			var j:int;
			var coords:Array;
			var points:Array;
			var components:Vector.<Geometry>;
			var componentsNumber:Vector.<Number>;
			var point:Point;
			var realIndice:uint;
			
			if (type == "point")
			{
				coords = StringUtils.trim(args).split(this._regExes.spaces);
				return new PointFeature(new Point(coords[0], coords[1]));
			}
			else if (type == "multipoint")
			{
				points = StringUtils.trim(args).split(',');
				componentsNumber = new Vector.<Number>(points.length*2);
				j = points.length 
				realIndice = 0;
				for (i = 0; i < j; ++i){
					point = parse(points[i], "point").geometry as Point;
					realIndice = i *2;
					componentsNumber[realIndice] = point.x;
					componentsNumber[realIndice + 1] = point.y; 
				}
				return new MultiPointFeature(new MultiPoint(componentsNumber));
			}
			else if (type == "linestring")
			{
				points = StringUtils.trim(args).split(',');
				componentsNumber = new Vector.<Number>(points.length*2);
				j = points.length;
				realIndice = 0;
				for (i = 0; i < j; ++i){
					point = parse(points[i], "point").geometry;
					realIndice = i *2;
					componentsNumber[realIndice] = point.x;
					componentsNumber[realIndice + 1] = point.y; 
				}
				return new LineStringFeature(new LineString(componentsNumber));
			}
			else if (type == "multilinestring")
			{
				var line:String;
				var lines:Array = StringUtils.trim(args).split(this._regExes.parenComma);
				components = new Vector.<Geometry>(lines.length);
				j = lines.length;
				for(i = 0; i < j; ++i)
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
				j = rings.length;
				for(i = 0; i < j; ++i)
				{
					ring = rings[i].replace(this._regExes.trimParens, '$1');
					lineString = parse(ring, "linestring").geometry;
					var l:int = lineString.componentsLength * 2;
					var ringComponents:Vector.<Number> = new Vector.<Number>(l);
					ringComponents = lineString.getcomponentsClone();
					point = lineString.getPointAt(0)
					ringComponents[l-2] = point.x;
					ringComponents[l-1] = point.y;
					
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
				j = polygons.length;
				for(i = 0; i < j; ++i)
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
				j = wktArray.length;
				for(i = 0; i < j; ++i)
					components[i] = Vector.<Geometry>(new WKTFormat().read([wktArray[i]]));
				return components;
			}
			return null;
		}
		
	}
}