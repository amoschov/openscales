package org.openscales.core.layer.ogc
{	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Map;
	import org.openscales.core.Request;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.feature.WFSFeature;
	import org.openscales.core.format.Format;
	import org.openscales.core.format.WFSFormat;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.layer.capabilities.GetCapabilities;
	import org.openscales.core.layer.params.ogc.WFSParams;
	import org.openscales.core.tile.WFSTile;
	import org.openscales.proj4as.ProjProjection;
	
	/**
	 * Instances of WFS are used to display data from OGC Web Feature Services.
	 *  
	 * @author Bouiaw
	 */
	public class WFS extends VectorLayer
	{
	
		/**
	     * The ratio of image/tile size to map size (this is the untiled
	     *     buffer)
	     */
		private var _ratio:Number = 2;
	   	
	   	/**
	     *  Determines whether the layer is in vector mode or marker mode.
	     */                   
		private var _vectorMode:Boolean = true;
		
		private var _params:WFSParams = null;
		
		private var _url:String = null;
		
		private var _tile:WFSTile = null;
		
		private var _writer:Format = null;
		
		/** 
		 * TODO: is this attribute used ?!
		 * 
	     *  If featureClass is defined, an old-style markers
	     *     based WFS layer is created instead of a new-style vector layer. If
	     *     sent, this should be a subclass of OpenLayers.Feature
	     */
		private var _featureClass:Class = null;
		
		private var _featureNS:String = null;
				
		private var _geometryColumn:String = null;
		
		/**
	     * 	 Should the WFS layer parse attributes from the retrieved
	     *     GML? Defaults to false. If enabled, parsing is slower, but 
	     *     attributes are available in the attributes property of 
	     *     layer features.
	     */
		private var _extractAttributes:Boolean = true;
		
		/**
		 * An HashMap containing the capabilities of the layer.
		 */
		private var _capabilities:HashMap = null;
		
		/**
		 * Do we get capabilities ?
		 */
		private var _useCapabilities:Boolean = false;
		
		/**
		 * WFS class constructor
		 * 
		 * @param name Layer's name
		 * @param url The WFS server url to request
		 * @param params
		 * @param isBaseLayer
		 * @param visible
		 * @param projection
		 * @param proxy
		 * @param capabilities
		 * @param useCapabilities
		 */	                    
	    public function WFS(name:String, url:String, params:WFSParams = null, isBaseLayer:Boolean = false, visible:Boolean = true, 
							projection:String = null, proxy:String = null, useCapabilities:Boolean=false, capabilities:HashMap=null) {
	    	
	    	this.capabilities = capabilities;
	    	this.useCapabilities = useCapabilities;
	        
	        super(name, isBaseLayer, visible, projection, proxy);
	        
	        if (!this.renderer || !this.vectorMode) {
	            this.vectorMode = false; 
	            if (!this.featureClass) {
	                this.featureClass = WFSFeature;
	            }   
	        }
	        
	        if (!(this.geometryColumn)) {
	            this.geometryColumn = "the_geom";
	        }    
	        
	        if (params != null)
	       		this.params = params;
	       	else
	       		this.params = new WFSParams("");
	        
	        this.url = url;	        
	    }
	    
	    override public function destroy(setNewBaseLayer:Boolean = true):void {
	        if (this.vectorMode) {
	            super.destroy();
	        }
	    }
	    
	    override public function set map(map:Map):void {
	        if (this.vectorMode) {
	            super.map = map;
	            
	            // GetCapabilities request made here in order to have the proxy set 
	            if (url != null && url != "" && this.capabilities == null && useCapabilities == true) {
	    			var getCap:GetCapabilities = new GetCapabilities("wfs", url, this.capabilitiesGetter, this.proxy);
	    		}
	        }
	    }
	    
	    /**
	    * Method called when we pan, drag or change zoom to move the layer.
	    * 
	    * @param bounds The new bounds delimiting the layer view
	    * @param zoomChanged Zoom changed or not
	    * @param dragging Drag action or not
	    */
	    override public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean = false):void {
	        if (this.vectorMode) {
	            super.moveTo(bounds, zoomChanged, dragging);
	        }  
	        
	        if (dragging) {
	        } else {
	
		        if (this.minZoomLevel && this.map.zoom < this.minZoomLevel) {

		        
			        if (bounds == null) {
			            bounds = this.map.extent;
			        }
			
			        var firstRendering:Boolean = (this.tile == null);
			
			        var outOfBounds:Boolean = (!firstRendering &&
			                           !this.tile.bounds.containsBounds(bounds));
			
			        if ( zoomChanged || firstRendering || (!dragging && outOfBounds) ) {
			            var center:LonLat = bounds.centerLonLat;
			            var tileWidth:Number = bounds.width * this._ratio;
			            var tileHeight:Number = bounds.height * this._ratio;
			            var tileBounds:Bounds = this.extent;
			            
			            if (tileBounds.containsBounds(this.maxExtent)) {
			            	tileBounds = this.maxExtent;
			            }
			            			
			            var tileSize:Size = this.map.size;
			            tileSize.w = tileSize.w * this._ratio;
			            tileSize.h = tileSize.h * this._ratio;
		
			            var ul:LonLat = new LonLat(tileBounds.left, tileBounds.top);
			            var pos:Pixel = this.map.getLayerPxFromLonLat(ul);
						
						this.params.bbox = tileBounds.boundsToString();
			            var url:String = this.getFullRequestString();
			        
			            if (!this.tile) {
			                this.tile = new org.openscales.core.tile.WFSTile(this, pos, tileBounds, 
			                                                     url, tileSize);
			                this.tile.draw();
			               	this.featuresBbox = tileBounds;
			            } 
			            
			            
			            else {

			            	if ( !this.featuresBbox.containsBounds(tileBounds)) {
				     			
				     			if (this.capabilities != null && 
				     				!this.featuresBbox.containsBounds(this.capabilities.getValue("Extent"))) {
									
									this.featuresBbox.extendFromBounds((tileBounds));
									
				                	this.params.bbox = this.featuresBbox.boundsToString();
					                url = this.getFullRequestString();				            		
				            		 
				            		this.tile.url = url;			            		
				            		this.tile.loadFeaturesForRegion(this.tile.requestSuccess);
								}		                	
				                				                
			            	}		            	
			            } 
			        }
			 	}
	        }
	    }
	    
	    /**
	    * Method called on map resize
	    */
	     override public function onMapResize():void {	
	        if(this.vectorMode) {
	            super.onMapResize();
	        }
	    } 
	    
		/**
		 * TODO: Has to be refactored
		 */
	    override public function clone(obj:Object):Object {
	        if (obj == null) {
	            obj = new WFS(this.name,
                               this.url,
                               this.params);
	        }

	        if (this.vectorMode) {
	            obj = super.clone([obj]);
	        }
	
	        return obj;
	    }
	    
	    /** 
	     * Combine the layer's url with its params and these newParams. 
	     *
	     * @param newParams
	     * @param altUrl Use this as the url instead of the layer's url
	     */
		private function getFullRequestString(altUrl:String = null):String {
			
			var url:String;
			
			if (altUrl != null)
				url = altUrl;
			else
				url = this.url;
				
			var requestString:String = url;
			
	        var projection:ProjProjection = this.projection;
	        if (projection != null || this.map.projection != null)
	        	this.params.srs = (projection == null) ? this.map.projection.srsCode : projection.srsCode;
	
	
			var lastServerChar:String = url.charAt(url.length - 1);
            if ((lastServerChar == "&") || (lastServerChar == "?")) {
                requestString += this.params.toGETString();
            } 
            else {
                if (url.indexOf('?') == -1) {
                    requestString += '?' + this.params.toGETString();
                } 
                else {
                    requestString += '&' + this.params.toGETString();
                }
            }
			
			
	        return requestString;
		}
		
		/**
	     * Write out the data to a WFS server.
	     */
		public function commit():void {
			if (!this.writer) {
	            this.writer = new WFSFormat(this);
	        }
	
	        var data:Object = this.writer.write(this.features);
	        
	        var url:String = this.url;
	        var proxy:String;
	        
	        if (this.proxy && this.url.indexOf("http") == 0) {
	            proxy = this.proxy;
	        }
	
	        var successfailure:Function = commitSuccessFailure;
	        
	        new Request(url, URLRequestMethod.POST, successfailure, data, null, proxy);
		}
		
		/**
		 * Callback method for commit request
		 */
		public function commitSuccessFailure(event:Event):void {
			var loader:URLLoader = event.target as URLLoader;
			var response:String = loader.data as String;
	        if (response.indexOf('SUCCESS') != -1) {
	            this.commitReport('WFS Transaction: SUCCESS', response);
	            
	            for(var i:int = 0; i < this.features.length; i++) {
	                features[i].state = null;
	            }    
	            // TBD redraw the layer or reset the state of features
	            // foreach features: set state to null
	        } else if (response.indexOf('FAILED') != -1 ||
	            response.indexOf('Exception') != -1) {
	            this.commitReport('WFS Transaction: FAILED', response);
	        }
		}
		
		/**
		 * Called by the callback method to report the request result
		 */
		public function commitReport(string:String, response:String):void{
			Trace.info(string);
		}
		
		/*public function refresh():void {
			if (this.tile) {
	            if (this.vectorMode) {
	                this.renderer.clear();
	                Util.clearArray(this.features);
	            }
	            this.tile.draw();
	        }
		}*/
		
		public function set typename(value:String):void {
			this.params.typename = value;
		}
		
		public function get typename():String {
			return this.params.typename;
		}
		
		public function get capabilities():HashMap {
			return this._capabilities;
		}
		
		public function set capabilities(value:HashMap):void {
			this._capabilities = value;
		}
		
		/**
		 * TODO: Refactor this to use events
		 * 
		 * Callback method called by the capabilities retriever.
		 * 
		 * @param caller The GetCapabilities instance which call it.
		 */
		public function capabilitiesGetter(caller:GetCapabilities):void {
			if (this.params != null) {
				this._capabilities = caller.getLayerCapabilities(this.params.typename);
				
			}
			if (this._capabilities != null) {
				this.projection = new ProjProjection(this._capabilities.getValue("SRS"));
			}
        }
        
        public function get vectorMode():Boolean {
			return this._vectorMode;
		}
		
		public function set vectorMode(value:Boolean):void {
			this._vectorMode = value;
		}
		
		public function get params():WFSParams {
			return this._params;
		}
		
		public function set params(value:WFSParams):void {
			this._params = value;
		}
		
		public function get url():String {
			return this._url;
		}
		
		public function set url(value:String):void {
			this._url = value;
		}
		
		public function get tile():org.openscales.core.tile.WFSTile {
			return this._tile;
		}
		
		public function set tile(value:org.openscales.core.tile.WFSTile):void {
			this._tile = value;
		}
		
		public function get writer():Format {
			return this._writer;
		}
		
		public function set writer(value:Format):void {
			this._writer = value;
		}
		
		public function get featureClass():Class {
			return this._featureClass;
		}
		
		public function set featureClass(value:Class):void {
			this._featureClass = value;
		}
		
		public function get featureNS():String {
			return this._featureNS;
		}
		
		public function set featureNS(value:String):void {
			this._featureNS = value;
		}
		
		public function get geometryColumn():String {
			return this._geometryColumn;
		}
		
		public function set geometryColumn(value:String):void {
			this._geometryColumn = value;
		}
		
		public function get extractAttributes():Boolean {
			return this._extractAttributes;
		}
		
		public function set extractAttributes(value:Boolean):void {
			this._extractAttributes = value;
		}
		
		public function get useCapabilities():Boolean {
			return this._useCapabilities;
		}
		
		public function set useCapabilities(value:Boolean):void {
			this._useCapabilities = value;
		}
		
	}
}