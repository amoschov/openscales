package org.openscales.core.format
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.openscales.core.feature.CustomMarkerFeature;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.LinearRing;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.request.DataRequest;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.fill.SolidFill;
	import org.openscales.core.style.marker.WellKnownMarker;
	import org.openscales.core.style.stroke.Stroke;
	import org.openscales.core.style.symbolizer.LineSymbolizer;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.PolygonSymbolizer;
	import org.openscales.proj4as.ProjProjection;
	

	/**
	 * Read KML xml files
	 * 
	 * alpha support
	 */
	public class KMLFormat extends Format
	{
		private namespace opengis="http://www.opengis.net/kml/2.2";
		private namespace google="http://earth.google.com/kml/2.0";
		private var _proxy:String;
		private var _externalImages:Object = {};
		private var _images:Object = {};
		[Embed(source="/assets/images/marker-blue.png")]
		private var _defaultImage:Class;

		// features
		private var iconsfeatures:Array = new Array();
		private var linesfeatures:Array = new Array();
		private var polygonsfeatures:Array = new Array();
		// styles
		private var lineStyles:Object = new Object();
		private var pointStyles:Object = new Object();
		private var polygonStyles:Object = new Object();
		
		public function KMLFormat() {
		}

		public function set proxy(value:String):void {
			this._proxy = value;
		}
		
		/**
		 * return the RGB color of a kml:color
		 */
		private function KMLColorsToRGB(data:String):Number {
			var color:String = data.substr(6,2);
			color = color+data.substr(4,2);
			color = color+data.substr(2,2);
			return parseInt(color,16);
		}

		/**
		 * Return the alpha part of a kml:color
		 */
		private function KMLColorsToAlpha(data:String):Number {
			return parseInt(data.substr(0,2),16)/255;
		}

		private function updateImages(e:Event):void {
			var _url:String = e.target.loader.name;
			var _imgs:Array = _images[_url];
			_images[_url] = null;
			var _bm:Bitmap = Bitmap(_externalImages[_url].loader.content); 
			var _bmd:BitmapData = _bm.bitmapData;
			for each(var _img:Sprite in _imgs) {
				var _image:Bitmap = new Bitmap(_bmd.clone());
				_image.x = -_image.width/2;
				_image.y = -_image.height;
				_img.addChild(_image);
			}
		}
		
		private function updateImagesError(e:Event):void {
			var _url:String = e.target.loader.name;
			var _imgs:Array = _images[_url];
			_images[_url] = null;
			_externalImages[_url] = null;
			
			for each(var _img:Sprite in _imgs) {
				var _marker:Bitmap = new _defaultImage();
				_marker.y = -_marker.height;
				_marker.x = -_marker.width/2;
				_img.addChild(_marker);
			}
		}

		/**
		 * load styles
		 */
		private function loadStyles(styles:XMLList):void {

			use namespace google;
			use namespace opengis;
			
			for each(var style:XML in styles) {
				var id:String = "";
				if(style.@id=="")
					continue;
				id = "#"+style.@id.toString();

				var color:Number;
				var alpha:Number=1;
				if(style.color != undefined) {
					color = KMLColorsToRGB(style.color.text());
					alpha = KMLColorsToAlpha(style.color.text())
				}

				if(style.IconStyle != undefined) {
					pointStyles[id] = new Object();
					pointStyles[id]["icon"] = null
					if(style.IconStyle.Icon != undefined && style.IconStyle.Icon.href != undefined) {
						try {
							var _url:String = style.IconStyle.Icon.href.text();
							var _req:DataRequest
							_req = new DataRequest(_url, updateImages, updateImagesError);
							_req.proxy = this._proxy;
							//_req.security = this._security; // FixMe: should the security be managed here ?
							_req.send();
							_externalImages[_url] = _req;
							pointStyles[id]["icon"] = _url;
							_images[_url] = new Array();
						} catch(e:Error) {
							pointStyles[id]["icon"] = null;
						}
					}
					if(style.IconStyle.color != undefined) {
						pointStyles[id]["color"] = KMLColorsToRGB(style.IconStyle.color.text());
						pointStyles[id]["alpha"] = KMLColorsToAlpha(style.IconStyle.color.text());
					}
					if(style.IconStyle.scale != undefined)
						pointStyles[id]["scale"] = Number(style.IconStyle.scale.text());
					if(style.IconStyle.heading != undefined) //0 to 360°
						pointStyles[id]["rotation"] = Number(style.IconStyle.headingtext());
					// TODO implement offset support + rotation effect
				}
				
				if(style.LineStyle != undefined) {
					var Lcolor:Number = color;
					var Lalpha:Number = alpha;
					var Lwidth:Number = 1;
					if(style.LineStyle.color != undefined) {
						Lcolor = KMLColorsToRGB(style.LineStyle.color.text());
						Lalpha = KMLColorsToAlpha(style.LineStyle.color.text());
					}
					if(style.LineStyle.width != undefined) {
						Lwidth = parseInt(style.LineStyle.width.text());
					}
					var Lrule:Rule = new Rule();
					Lrule.name = id;
					Lrule.symbolizers.push(new LineSymbolizer(new Stroke(Lcolor, Lwidth, Lalpha)));
					Lrule.symbolizers.push(new LineSymbolizer(new Stroke(Lcolor, Lwidth, Lalpha)));
					lineStyles[id] = new Style();
					lineStyles[id].name = id;
					lineStyles[id].rules.push(Lrule);
				}
				
				if(style.PolyStyle != undefined) {
					var Pcolor:Number = 0x96A621;
					var Palpha:Number = 1;
					var Pfill:SolidFill = new SolidFill();;
					Pfill.color = Pcolor;
					Pfill.opacity = Palpha;
					var Prule:Rule;
					var Pstroke:Stroke = new Stroke();
					Pstroke.width = 1;
					if(style.PolyStyle.color != undefined) {
						Pcolor = KMLColorsToRGB(style.PolyStyle.color.text());
						Palpha = KMLColorsToAlpha(style.PolyStyle.color.text());
						Pfill = new SolidFill();
						Pfill.color = Pcolor;
						Pfill.opacity = Palpha;
						Pstroke.color = Pcolor;
					}
					if(style.PolyStyle.fill != undefined && style.PolyStyle.fill.text() == "0") {
						Pfill = null;
					}
					if( lineStyles[id]!=undefined &&
						(style.PolyStyle.outline == undefined || style.PolyStyle.outline.text() == "1") ) {
						Pstroke.color = Lcolor;
						Pstroke.width = Lwidth;
					}
					var Pps:PolygonSymbolizer = new PolygonSymbolizer(Pfill, Pstroke);
					Prule = new Rule();
					Prule.name = id;
					Prule.symbolizers.push(Pps);
					Prule.symbolizers.push(Pps);
					polygonStyles[id] = new Style();
					polygonStyles[id].rules.push(Prule);
					polygonStyles[id].name = id;
				}
			}
		}
		
		/**
		 * load placemarks
		 */
		private function loadPlacemarks(placemarks:XMLList):void {

			use namespace google;
			use namespace opengis;

			for each(var placemark:XML in placemarks) {
				var coordinates:Array;
				var point:Point;
				var htmlContent:String = "";
				var attributes:Object = new Object();
				
				if(placemark.name != undefined) {
					attributes["name"] = placemark.name.text();
					htmlContent = htmlContent + "<b>" + placemark.name.text() + "</b><br />";   
				}
				
				if(placemark.description != undefined) {
					attributes["description"] = placemark.description.text();
					htmlContent = htmlContent + placemark.description.text() + "<br />";
				}
				
				for each(var extendedData:XML in placemark.ExtendedData.Data) {
					if(extendedData.value)
						attributes[extendedData.@name] = extendedData.value.text();
					htmlContent = htmlContent + "<b>" + extendedData.@name + "</b> : " + extendedData.value.text() + "<br />";
				}		
				attributes["popupContentHTML"] = htmlContent;
				
				var _id:String;

				// LineStrings
				if(placemark.LineString != undefined)
				{
					var _Lstyle:Style = Style.getDefaultLineStyle();
					if(placemark.styleUrl != undefined)
					{
						_id = placemark.styleUrl.text();
						if(lineStyles[_id] != undefined)
							_Lstyle = lineStyles[_id];
					}
					var _Ldata:String = placemark.LineString.coordinates.text();
					_Ldata = _Ldata.replace("\n"," ");
					_Ldata = _Ldata.replace(/^\s*(.*?)\s*$/g, "$1");
					coordinates = _Ldata.split(" ");
					var points:Array = new Array();
					for each(var coords:String in coordinates) {
						var _coords:Array = coords.split(",");
						if(_coords.length<2)
							continue;
						point = new Point(_coords[0].toString(),
							_coords[1].toString());
						if (this._internalProj != null, this._externalProj != null) {
							point.transform(this.externalProj, this.internalProj);
						}
						points.push(point);
					}
					var line:LineString = new LineString(points);
					linesfeatures.push(new LineStringFeature(line,attributes,_Lstyle));
				}
				
				// Polygons
				if(placemark.Polygon != undefined) {
					var _Pstyle:Style = Style.getDefaultSurfaceStyle();
					if(placemark.styleUrl != undefined)
					{
						_id = placemark.styleUrl.text();
						if(polygonStyles[_id] != undefined)
							_Pstyle = polygonStyles[_id];
					}
					var _Pdata:String = placemark.Polygon.outerBoundaryIs.LinearRing.coordinates.text();
					_Pdata = _Pdata.replace("\n"," ");
					_Pdata = _Pdata.replace(/^\s*(.*?)\s*$/g, "$1");
					coordinates = _Pdata.split(" ");
					var Ppoints:Array = new Array();
					var Pcoords:String;
					var _Pcoords:Array;
					for each(Pcoords in coordinates) {
						_Pcoords = Pcoords.split(",");
						if(_Pcoords.length<2)
							continue;
						point = new Point(_Pcoords[0].toString(),
										  _Pcoords[1].toString());
						if (this._internalProj != null, this._externalProj != null) {
							point.transform(this.externalProj, this.internalProj);
						}
						Ppoints.push(point);
					}
					var lines:Array = new Array();
					lines.push(new LinearRing(Ppoints));
					if(placemark.Polygon.innerBoundaryIs != undefined) {
						try {
							_Pdata = placemark.Polygon.innerBoundaryIs.LinearRing.coordinates.text();
							_Pdata = _Pdata.replace("\n"," ");
							_Pdata = _Pdata.replace(/^\s*(.*?)\s*$/g, "$1");
							coordinates = _Pdata.split(" ");
							Ppoints = new Array();
							for each(Pcoords in coordinates) {
								_Pcoords = Pcoords.split(",");
								if(_Pcoords.length<2)
									continue;
								point = new Point(_Pcoords[0].toString(),
												  _Pcoords[1].toString());
								if (this._internalProj != null, this._externalProj != null) {
									point.transform(this.externalProj, this.internalProj);
								}
								Ppoints.push(point);
							}
							lines.push(new LinearRing(Ppoints));
						} catch(e:Error) {
						}
					}
					polygonsfeatures.push(new PolygonFeature(new Polygon(lines),attributes,_Pstyle));
				}
				
				//Points
				// rotation is not supported yet
				if(placemark.Point != undefined)
				{
					coordinates = placemark.Point.coordinates.text().split(",");
					point = new Point(coordinates[0], coordinates[1]);
					if (this._internalProj != null, this._externalProj != null) {
						point.transform(this.externalProj, this.internalProj);
					}
					if(placemark.styleUrl != undefined) {
						_id = placemark.styleUrl.text();
						if(pointStyles[_id] != undefined) { // style
							if(pointStyles[_id]["icon"]!=null) { // icon
								var _icon:String = pointStyles[_id]["icon"];
								var customMarker:CustomMarkerFeature;
								if(_images[_icon]!=null) { // image not loaded so we will wait for it
									var _img:Sprite = new Sprite();
									_images[_icon].push(_img);
									customMarker = new CustomMarkerFeature(_img,point,attributes,null,0,0);
								}
								else if(_externalImages[_icon]!=null) { // image allready loaded, we copy the loader content
									var Image:Bitmap = new Bitmap(new Bitmap(_externalImages[_icon].loader.content).bitmapData.clone());
									Image.y = -Image.height;
									Image.x = -Image.width/2;
									customMarker = new CustomMarkerFeature(Image,point,attributes,null,0,0);
								}
								else { // image failed to load
									var _marker:Bitmap = new _defaultImage();
									_marker.y = -_marker.height;
									_marker.x = -_marker.width/2;
									customMarker = new CustomMarkerFeature(_marker,point,attributes,null,0,0);
								}
								iconsfeatures.push(customMarker);
							}
							else { // style without icon
								var _style:Style = Style.getDefaultPointStyle()
								if(pointStyles[_id]["color"] != undefined)
								{
									var _fill:SolidFill = new SolidFill(pointStyles[_id]["color"], pointStyles[_id]["alpha"]);
									var _stroke:Stroke = new Stroke(pointStyles[_id]["color"], pointStyles[_id]["alpha"]);
									var _mark:WellKnownMarker = new WellKnownMarker(WellKnownMarker.WKN_SQUARE, _fill, _stroke);
									var _symbolizer:PointSymbolizer = new PointSymbolizer();
									_symbolizer.graphic = _mark;
									var _rule:Rule = new Rule();
									_rule.name = _id;
									_rule.symbolizers.push(_symbolizer);
									_style = new Style();
									_style.name = _id;
									_style.rules.push(_rule);
								}
								iconsfeatures.push(new PointFeature(point, attributes, _style));
							}
						}
						else // no matching style
							iconsfeatures.push(new PointFeature(point, attributes, Style.getDefaultPointStyle()));
					}
					else // no style
						iconsfeatures.push(new PointFeature(point, attributes, Style.getDefaultPointStyle()));
				}
			}
		}
		
		/**
		 * Read data
		 *
		 * @param data data to read/parse.
		 *
		 * @return array of features.
		 */
		override public function read(data:Object):Object {
			var dataXML:XML = data as XML;

			use namespace google;
			use namespace opengis;

			var styles:XMLList = dataXML..Style;
			loadStyles(styles.copy());
			var placemarks:XMLList = dataXML..Placemark;
			loadPlacemarks(placemarks.copy());
			
			var _features:Array = polygonsfeatures.concat(linesfeatures, iconsfeatures);

			return _features;
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

