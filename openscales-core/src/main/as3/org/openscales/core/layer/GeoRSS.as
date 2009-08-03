package org.openscales.core.layer
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Request;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.Marker;
	
	/**
	 * Add GeoRSS Point features to your map.
	 * 
	 * @author Bouiaw
	 */	
	public class GeoRSS extends FeatureLayer
	{
	
		private var _location:String = null;
    	
    	/**
    	 * GeoRSS constructor
    	 * 
    	 * @param name
    	 * @param url
    	 * @param isBseLayer
    	 * @param visible
    	 * @param projection
    	 * @param proxy
    	 */
    	public function GeoRSS(name:String, url:String, isBaseLayer:Boolean = false, visible:Boolean = true, 
    							projection:String = null, proxy:String = null) {
    		
	        super(name, isBaseLayer, visible, projection, proxy);
	        
	        this.location = url;
	     	
			new Request(location, URLRequestMethod.GET, this.parseData, null , null, this.proxy);

    	}
		
		public function parseData(event:Event):void {
			var loader:URLLoader = event.target as URLLoader;
			
			var doc:XML = new XML(loader.data);
	        
	        this.name = null;
	        try {
	            this.name = doc.*::title[0].firstChild.nodeValue;
	        }
	        catch (e:Error) {
	            this.name = doc.title[0].firstChild.nodeValue;
	        }
	        
	        var itemlist:XMLList = null;
	        try {
	            itemlist = doc.*::item;
	        }
	        catch (e:Error) {
	            itemlist = doc.item;
	        }
	
	        if (itemlist.length == 0) {
	            try {
	                itemlist = doc.*::entry;
	            }
	            catch(e:Error) {
	                itemlist = doc.entry;
	            }
	        }
	
	        for (var i:int = 0; i < itemlist.length; i++) {
	            var data:Object = {};
	            var point:XMLList = itemlist[i].*::point;
	            var lat:XMLList = itemlist[i].*::lat;
	            var lon:XMLList = itemlist[i].*::long;
	            if (point.length > 0) {
	                var locationArray:Array = point[0].firstChild.nodeValue.split(" ");
	                
	                if (locationArray.length != 2) {
	                    locationArray = point[0].firstChild.nodeValue.split(",");
	                }
	            } else if (lat.length > 0 && lon.length > 0) {
	                locationArray = [Number(lat[0].firstChild.nodeValue), Number(lon[0].firstChild.nodeValue)];
	            } else {
	                continue;
	            }
	            var location:LonLat = new LonLat(Number(location[1]), Number(location[0]));

	            var title:String = "Untitled";
	            try {
	              title = itemlist[i].title[0].firstChild.nodeValue;
	            }
	            catch (e:Error) { title="Untitled"; }

	            var descr_nodes:XMLList = null;
	            try {
	                descr_nodes = itemlist[i].*::description;
	            }
	            catch (e:Error) {
	                descr_nodes = itemlist[i].description;
	            }
	            if (descr_nodes.length == 0) {
	                try {
	                    descr_nodes = itemlist[i].*::summary;
	                }
	                catch (e:Error) {
	                    descr_nodes = itemlist[i].summary;
	                }
	            }
	
	            var description:String = "No description.";
	            try {
	              description = descr_nodes[0].firstChild.nodeValue;
	            }
	            catch (e:Error) { description="No description."; }
	
				var link:String = null;
	            try {
	              link = itemlist[i].link[0].firstChild.nodeValue;
	            } 
	            catch (e:Error) {
	              try {
	                link = itemlist[i].link[0].@href;
	              }
	              catch (e:Error) {}
	            }
	
				i/* f (link != null) {
					this.icon = new Icon(link);
				}
	
	            data.icon = this.icon == null ? 
	                                     new Marker() : 
	                                     this.icon.clone();
	            data.popupSize = new Size(250, 120);
	            if ((title != null) && (description != null)) {
	                var contentHTML:String = '<div class="olLayerGeoRSSClose">[x]</div>'; 
	                contentHTML += '<div class="olLayerGeoRSSTitle">';
	                if (link) contentHTML += '<a class="link" href="'+link+'" target="_blank">';
	                contentHTML += title;
	                if (link) contentHTML += '</a>';
	                contentHTML += '</div>';
	                contentHTML += '<div style="" class="olLayerGeoRSSDescription">';
	                contentHTML += description;
	                contentHTML += '</div>';
	                data['popupContentHTML'] = contentHTML;                
	            }
	            var feature:Feature = new Feature(this, location, data);
	            this.features.push(feature);
	            var marker:Marker = feature.createMarker();
	            marker.addEventListener(MouseEvent.CLICK, this.markerClick);
	            
	            this.addMarker(marker); */
	        }
		}
		
		public function markerClick(evt:MouseEvent):void {
			/* Method to refactor */
			var markerClicked:Object = evt.currentTarget as Marker;
			var sameMarkerClicked:Boolean = (markerClicked == markerClicked.layer.selectedFeature);
	        markerClicked.layer.selectedFeature = (!sameMarkerClicked) ? this : null;
	        for(var i:int=0; i < markerClicked.layer.map.popups.length; i++) {
	            markerClicked.layer.map.removePopup(markerClicked.layer.map.popups[i]);
	        }
	        if (!sameMarkerClicked) {
	            var popup:Object = markerClicked.createPopup();
	            markerClicked.addEventListener(MouseEvent.CLICK, function():void { 
	              for(var i:int=0; i < markerClicked.layer.map.popups.length; i++) { 
	                markerClicked.layer.map.removePopup(markerClicked.layer.map.popups[i]); 
	              } 
	            });
	            markerClicked.layer.map.addPopup(popup); 
	        }
		}
		
		
		//Getters and Setters
		public function get location():String {
			return this._location;
		}
		
		public function set location(value:String):void {
			this._location = value;
		}
		
	}
}