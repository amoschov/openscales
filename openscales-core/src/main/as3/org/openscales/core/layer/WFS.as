package org.openscales.core.layer
{	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Map;
	import org.openscales.core.OpenScales;
	import org.openscales.core.Request;
	import org.openscales.commons.Util;
	import org.openscales.commons.basetypes.Bounds;
	import org.openscales.commons.basetypes.LonLat;
	import org.openscales.commons.basetypes.Pixel;
	import org.openscales.commons.basetypes.Size;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.format.WFS;
	import org.openscales.core.tile.WFS;
	
	public class WFS extends org.openscales.core.layer.Vector
	{
		
		public var ratio:Number = 2;
	
	    public var DEFAULT_PARAMS:Object = { service: "WFS",
	                      version: "1.1.0",
	                      request: "GetFeature" };
	                      
		public var vectorMode:Boolean = true;
		
		public var params:Object = null;
		
		public var url:String = null;
		
		public var tile:org.openscales.core.tile.WFS = null;
		
		public var writer:Object = null;
		
		public var featureClass:Class = null;
		
		public var featureNS:String = null;
		
		public var typename:String = null;
		
		public var geometry_column:String = null;
		
		public var extractAttributes:Boolean = true;
			                    
	    public function WFS(name:String, url:String, params:Object, options:Object = null):void {
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
	        
	        if (this.params && this.params.typename && !this.typename) {
	            this.typename = this.params.typename;
	        }
	        
	        if (!(this.geometry_column)) {
	            this.geometry_column = "the_geom";
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
			            var center:LonLat = bounds.getCenterLonLat();
			            var tileWidth:Number = bounds.getWidth() * this.ratio;
			            var tileHeight:Number = bounds.getHeight() * this.ratio;
			            var tileBounds:Bounds = this.extent;
			            			
			            var tileSize:Size = this.map.size;
			            tileSize.w = tileSize.w * this.ratio;
			            tileSize.h = tileSize.h * this.ratio;
		
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
	        var projection:String = this.map.projection;
	        this.params.SRS = (projection == "none") ? null : projection;
	
	        return new Grid(this.name, this.url, this.params).getFullRequestString(newParams, altUrl);
		}
		
		public function commit():void {
			if (!this.writer) {
	            this.writer = new org.openscales.core.format.WFS({},this);
	        }
	
	        var data:Object = this.writer.write(this.features);
	        
	        var url:String = this.url;
	        var proxy:String;
	        
	        if (OpenScales.ProxyHost && this.url.indexOf("http") == 0) {
	            proxy = OpenScales.ProxyHost;
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
		
	}
}