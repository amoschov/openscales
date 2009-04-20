package org.openscales.core.layer.ogc
{	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Map;
	import org.openscales.core.Request;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.format.Format;
	import org.openscales.core.format.WFS;
	import org.openscales.core.layer.Grid;
	import org.openscales.core.layer.Vector;
	import org.openscales.core.layer.capabilities.GetCapabilities;
	import org.openscales.core.tile.WFS;
	import org.openscales.proj.IProjection;
	
	public class WFS extends org.openscales.core.layer.Vector
	{
		
		public var DEFAULT_PARAMS:Object = { service: "WFS",
	                      version: "1.1.0",
	                      request: "GetFeature" };
		
		private var _ratio:Number = 2;
	                      
		private var _vectorMode:Boolean = true;
		
		private var _params:Object = null;
		
		private var _url:String = null;
		
		private var _tile:org.openscales.core.tile.WFS = null;
		
		private var _writer:Format = null;
		
		private var _featureClass:Class = null;
		
		private var _featureNS:String = null;
				
		private var _geometryColumn:String = null;
		
		private var _extractAttributes:Boolean = true;
		
		private var _capabilities:HashMap = null;
			                    
	    public function WFS(name:String, url:String, params:Object, options:Object = null, capabilities:HashMap=null):void {
	    	
	    	this.capabilities = capabilities;
	    	
	    	if (url != null && url != "" && this.capabilities == null) {
	    		var getCap:GetCapabilities = new GetCapabilities("wfs", url, this.capabilitiesGetter);
	    	}
		    	
	        if (options == null) { options = {}; } 
	        
	        super(name, options)
	        
	        if (this.featureClass || !org.openscales.core.layer.Vector || !org.openscales.core.feature.Vector) {
	            this.vectorMode = false;
	        } 
	        
	        if (!this.renderer || !this.vectorMode) {
	            this.vectorMode = false; 
	            if (!this.featureClass) {
	                this.featureClass = org.openscales.core.feature.WFS;
	            }   
	        }
	        
	        if (!(this.geometryColumn)) {
	            this.geometryColumn = "the_geom";
	        }    
	        
	        this.params = params;
	        Util.applyDefaults(this.params, Util.upperCaseObject(this.DEFAULT_PARAMS));
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
	        }
	    }
	    
	    override public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean = false):void {
	        if (this.vectorMode) {
	            super.moveTo(bounds, zoomChanged, dragging);
	        }  
	        
	        if (dragging) {
	        } else {
	        	
		        //Commented to avoid the reload of vectorial features
		      /*  if ( zoomChanged ) {
		            if (this.vectorMode) {
		                this.renderer.clear();
		            }
		        }*/
	
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
		
			            var url:String = this.getFullRequestString();
			        
			            var params:Object = { BBOX:tileBounds.toBBOX() };
			            url += "&" + Util.getParameterString(params);
			
			            if (!this.tile) {
			                this.tile = new org.openscales.core.tile.WFS(this, pos, tileBounds, 
			                                                     url, tileSize);
			                this.tile.draw();
			               	this.featuresBbox = tileBounds;
			            } 
			            
			            
			            else {

			            	if ( !this.featuresBbox.containsBounds(tileBounds)) {
				     			
				     			if (this.capabilities != null && 
				     				!this.featuresBbox.containsBounds(this.capabilities.getValue("LatLon"))) {
									
									this.featuresBbox.extendFromBounds((tileBounds));
				                
					                url = this.getFullRequestString();
				            		params = { BBOX:this.featuresBbox.toBBOX() };
				            		url += "&" + Util.getParameterString(params);
				            		
				            		 
				            		this.tile.url = url;			            		
				            		this.tile.loadFeaturesForRegion(this.tile.requestSuccess);
								}		                	
				                				                
			            	}		            	
			            } 
			        }
			 	}
	        }
	    }
	    
	    override public function onMapResize():void {	
	        if(this.vectorMode) {
	            super.onMapResize();
	        }
	    }
	    
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
	    
		public function getFullRequestString(newParams:Object = null, altUrl:String = null):String {
	        var projection:IProjection = this.map.projection;
	        this.params.SRS = (projection == null) ? null : projection.code;
	
	        return new Grid(this.name, this.url, this.params).getFullRequestString(newParams, altUrl);
		}
		
		public function commit():void {
			if (!this.writer) {
	            this.writer = new org.openscales.core.format.WFS({},this);
	        }
	
	        var data:Object = this.writer.write(this.features);
	        
	        var url:String = this.url;
	        var proxy:String;
	        
	        if (Map.proxy && this.url.indexOf("http") == 0) {
	            proxy = Map.proxy;
	        }
	
	        var successfailure:Function = commitSuccessFailure;
	        
	        new Request(url, 
	                         {   method:URLRequestMethod.POST, 
	                             postBody: data,
	                             onComplete: successfailure
	                          },
	                          proxy
	                         );
		}
		
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
		
		public function commitFailure(response:Event):void {
			
		}
		
		public function commitReport(string:String, response:String):void{
			trace(string);
		}
		
		public function refresh():void {
			if (this.tile) {
	            if (this.vectorMode) {
	                this.renderer.clear();
	                Util.clearArray(this.features);
	            }
	            this.tile.draw();
	        }
		}
		
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
		
		public function capabilitiesGetter(caller:GetCapabilities):void {
			if (this.params != null) {
				this._capabilities = caller.getLayerCapabilities(this.params.typename);
				
			}
        }
        
        public function get vectorMode():Boolean {
			return this._vectorMode;
		}
		
		public function set vectorMode(value:Boolean):void {
			this._vectorMode = value;
		}
		
		public function get params():Object {
			return this._params;
		}
		
		public function set params(value:Object):void {
			this._params = value;
		}
		
		public function get url():String {
			return this._url;
		}
		
		public function set url(value:String):void {
			this._url = value;
		}
		
		public function get tile():org.openscales.core.tile.WFS {
			return this._tile;
		}
		
		public function set tile(value:org.openscales.core.tile.WFS):void {
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
		
	}
}