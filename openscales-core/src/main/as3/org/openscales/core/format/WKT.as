package org.openscales.core.format
{
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.StringUtils;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.MultiPoint;
	import org.openscales.core.geometry.MultiPolygon;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	
	public class WKT extends Format
	{
		
		private var _regExes:Object;
		
		public function WKT(options:Object = null):void {
			
	        this._regExes = {
	            'typeStr': /^\s*(\w+)\s*\(\s*(.*)\s*\)\s*$/,
	            'spaces': /\s+/,
	            'parenComma': /\)\s*,\s*\(/,
	            'doubleParenComma': /\)\s*\)\s*,\s*\(\s*\(/,
	            'trimParens': /^\s*\(?(.*?)\)?\s*$/
	        };
	        super(options);
		}
		
		override public function read(wkt:Object):Object {
			var features:Object, type:String, str:String;
	        var matches:Array = this._regExes.typeStr.exec(wkt);
	        if(matches) {
	            type = matches[1].toLowerCase();
	            str = matches[2];
	            if(this.parse[type]) {
	                features = this.parse[type].apply(this, [str]);
	            }
	        }
	        return features;
		}
		
		override public function write(features:Object):Object {
			var collection:Object, geometry:Geometry, type:String, data:Object, isCollection:Boolean;
	        if(features.constructor == Array) {
	            collection = features;
	            isCollection = true;
	        } else {
	            collection = [features];
	            isCollection = false;
	        }
	        var pieces:Array = [];
	        if(isCollection) {
	            pieces.push('GEOMETRYCOLLECTION(');
	        }
	        for(var i:int=0; i<collection.length; ++i) {
	            if(isCollection && i>0) {
	                pieces.push(',');
	            }
	            geometry = collection[i].geometry;
	            type = getQualifiedClassName(geometry).split('::')[1].toLowerCase();
	            if(!extract[type]) {
	                return null;
	            }
	            data = extract[type]([geometry]);
	            pieces.push(type.toUpperCase() + '(' + data + ')');
	        }
	        if(isCollection) {
	            pieces.push(')');
	        }
	        return pieces.join('');
		}
		
		// FIXME : refactor
		public var extract:Object = {
	        'point': function(point:Pixel):String {
	            return point.x + ' ' + point.y;
	        },
	        'multipoint': function(multipoint:MultiPoint):String {
	            var array:Array = [];
	            for(var i:int=0; i<multipoint.components.length; ++i) {
	                array.push(this.extract.point.apply(this, [multipoint.components[i]]));
	            }
	            return array.join(',');
	        },
	        
	        'linestring': function(linestring:LineString):String {
	            var array:Array = [];
	            for(var i:int=0; i<linestring.components.length; ++i) {
	                array.push(this.extract.point.apply(this, [linestring.components[i]]));
	            }
	            return array.join(',');
	        },
	
	        'multilinestring': function(multilinestring:MultiLineString):String {
	            var array:Array = [];
	            for(var i:int=0; i<multilinestring.components.length; ++i) {
	                array.push('(' +
	                           this.extract.linestring.apply(this, [multilinestring.components[i]]) +
	                           ')');
	            }
	            return array.join(',');
	        },
	        
	        'polygon': function(polygon:Polygon):String {
	            var array:Array = [];
	            for(var i:int=0; i<polygon.components.length; ++i) {
	                array.push('(' +
	                           this.extract.linestring.apply(this, [polygon.components[i]]) +
	                           ')');
	            }
	            return array.join(',');
	        },
	
	        'multipolygon': function(multipolygon:MultiPolygon):String {
	            var array:Array = [];
	            for(var i:int=0; i<multipolygon.components.length; ++i) {
	                array.push('(' +
	                           this.extract.polygon.apply(this, [multipolygon.components[i]]) +
	                           ')');
	            }
	            return array.join(',');
	        }
		};
		
		public var parse:Object = {
			
        'point': function(str:String):Vector {
            var coords:Array = StringUtils.trim(str).split(this.regExes.spaces);
            return new Vector(
                new Point(coords[0], coords[1])
            );
        },

        'multipoint': function(str:String):Vector {
            var points:Array = StringUtils.trim(str).split(',');
            var components:Array = [];
            for(var i:int=0; i<points.length; ++i) {
                components.push(this.parse.point.apply(this, [points[i]]).geometry);
            }
            return new Vector(
            	new MultiPoint(components)
            );
        },

        'linestring': function(str:String):Vector {
            var points:Array = StringUtils.trim(str).split(',');
            var components:Array = [];
            for(var i:int=0; i<points.length; ++i) {
                components.push(this.parse.point.apply(this, [points[i]]).geometry);
            }
            return new Vector(
                new LineString(components)
            );
        },

        'multilinestring': function(str:String):Vector {
            var line:String;
            var lines:Array = StringUtils.trim(str).split(this.regExes.parenComma);
            var components:Array = [];
            for(var i:int=0; i<lines.length; ++i) {
                line = lines[i].replace(this.regExes.trimParens, '$1');
                components.push(this.parse.linestring.apply(this, [line]).geometry);
            }
            return new Vector(
            	new MultiLineString(components)
            );
        },
        
        'polygon': function(str:String):Vector {
            var ring:String, linestring:String, linearring:LinearRing;
            var rings:Array = StringUtils.trim(str).split(this.regExes.parenComma);
            var components:Array = [];
            for(var i:int=0; i<rings.length; ++i) {
                ring = rings[i].replace(this.regExes.trimParens, '$1');
                linestring = this.parse.linestring.apply(this, [ring]).geometry;
                linearring = new LinearRing(linestring.components)
                components.push(linearring);
            }
            return new Vector(
            	new Polygon(components)
            );
        },

        'multipolygon': function(str:String):Vector {
            var polygon:String;
            var polygons:Array = StringUtils.trim(str).split(this.regExes.doubleParenComma);
            var components:Array = [];
            for(var i:int=0; i<polygons.length; ++i) {
                polygon = polygons[i].replace(this.regExes.trimParens, '$1');
                components.push(this.parse.polygon.apply(this, [polygon]).geometry);
            }
            return new Vector(
                new MultiPolygon(components)
            );
        },

        'geometrycollection': function(str:String):Array {
            str = str.replace(/,\s*([A-Za-z])/g, '|$1');
            var wktArray:Array = StringUtils.trim(str).split('|');
            var components:Array = [];
            for(var i:int=0; i<wktArray.length; ++i) {
                components.push(new WKT().read([wktArray[i]]));
            }
            return components;
        }

    };
		
	}
}