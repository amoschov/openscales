package org.openscales.core.layer
{
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.renderer.Renderer;
	import org.openscales.core.renderer.SpriteRenderer;
	import org.openscales.proj4as.Proj4as;
	import org.openscales.proj4as.ProjPoint;
	import org.openscales.proj4as.ProjProjection;
	
	/**
	 * Instances of Vector are used to render vector data from a variety of sources.
	 */
	public class VectorLayer extends Layer
	{
	
	    private var _features:Array = null;
	    
	    private var _featuresBbox:Bounds = null;

	    private var _selectedFeatures:Array = null;
	
	    private var _style:Style = null;
		
	    private var _renderer:Renderer = null;

	    private var _geometryType:String = null;

	    private var _drawn:Boolean = false;
	    
	    public var onFeatureInsert:Function = null;
	    
	    public var preFeatureInsert:Function = null;
	    
	    private var _temporaryProjection:ProjProjection = null;
	    
	    public function VectorLayer(name:String, isBaseLayer:Boolean = false, visible:Boolean = true, 
									projection:String = null, proxy:String = null) {
										
	        this.style = new Style();
	        
	        this.onFeatureInsert = new Function();
	        this.preFeatureInsert = new Function();
	
	        super(name, isBaseLayer, visible, projection, proxy);
	        
	        if (!this.renderer) {  
	            this.assignRenderer();
	        }
	
	        this.features = new Array();
	        this.selectedFeatures = new Array();
	        this.featuresBbox = new Bounds();
	        // For better performances
	        this.cacheAsBitmap = true;
	        this._temporaryProjection = this.projection;
	        
	    }
	    
	    override public function destroy(setNewBaseLayer:Boolean = true):void {
	        super.destroy();  
	
	        this.destroyFeatures();
	        this.features = null;
	        this.selectedFeatures = null;
	        if (this.renderer) {
	            this.renderer.destroy();
	        }
	        this.renderer = null;
	        this.geometryType = null;
	        this.drawn = false;
	    }
	    
	    private function assignRenderer():void {
	       	var rendererClass:Class = org.openscales.core.renderer.SpriteRenderer;
	     	this.renderer = new rendererClass(this);
	    }
	    
	    override public function set map(map:Map):void {
	    	super.map = map;
	
	        if (!this.renderer) {
	            this.map.removeLayer(this);
	        } else {
	            this.renderer.map = this.map;
	            this.renderer.size = this.map.size;
	        }
	        
	      	this.map.addEventListener(LayerEvent.BASE_LAYER_CHANGED, this.checkProjection);
	        
	        checkProjection();
	       
	    }
	    
	    private function checkProjection(evt:LayerEvent = null):void {
	    	if (this.features.length > 0 && this.map != null && this._temporaryProjection.srsCode != this.map.projection.srsCode) {
				for each (var f:VectorFeature in this.features) {
					f.geometry.transform(this._temporaryProjection, this.map.projection);
				}
				var resProj:ProjPoint = new ProjPoint(this.minResolution, this.maxResolution);
				resProj = Proj4as.transform(this._temporaryProjection, map.projection, resProj);
				this.minResolution = resProj.x;
				this.maxResolution = resProj.y;
				this._temporaryProjection = map.projection;
				this.redraw();
			}
	    }
	    
	      override public function onMapResize():void {
	   		for each (var feature:VectorFeature in this.features){
		        this.renderer.eraseGeometry(feature.geometry);
		        this.renderer.drawFeature(feature,feature.style);
	    	}

	    }  
	    
	    /**
	     *  Reset the vector so that it once again is lined up with 
	     *   the map. Notify the renderer of the change of extent, and in the
	     *   case of a change of zoom level (resolution), have the 
	     *   renderer redraw features.
	     * 
	     * @param bounds
	     * @param zoomChanged
	     * @param dragging
	     */
	    override public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean = false,resizing:Boolean=false):void {
	    	super.moveTo(bounds, zoomChanged, dragging,resizing);
	    	
	    	/*if (zoomChanged) {
	    		this.eraseFeatures(this.features);
	    	}*/
        
	        if (!dragging) {
	            //this.x = - int(this.map.layerContainer.x);
	            //this.y = - int(this.map.layerContainer.y);
	            var extent:Bounds = this.map.extent;
	            this.renderer.extent = extent;
	            if(resizing)
	            {
	            	(this.renderer as SpriteRenderer).onMapresize();
	            }
	            
	        }
	
	        if (!this.drawn || zoomChanged) {
	            this.drawn = true;
	            for(var i:int = 0; i < this.features.length; i++) {
	                var feature:org.openscales.core.feature.VectorFeature = this.features[i];
	                this.drawFeature(feature);
	                
	            }
	        }
	    }
	    
	    /**
	     * Add Features to the layer.
	     *
	     * @param features
	     */
	    public function addFeatures(features:Object):void {
	    	if (!(features is Array)) {
	            features = [features];
	        }

	        for (var i:int = 0; i < features.length; i++) {
	            var feature:org.openscales.core.feature.VectorFeature = features[i];
	            
	            if (this.geometryType &&
	                !(getQualifiedClassName(feature.geometry) == this.geometryType)) {
	                    var throwStr:String = "addFeatures : component should be an " + 
	                                    getQualifiedClassName(this.geometryType);
	                    throw throwStr;
	                }
				
				if (this.map != null && this.map.projection != null && this.projection != null && 
					getQualifiedClassName(this).split("::")[1] != "WFS" && this.projection.srsCode != this.map.projection.srsCode) {
						
					feature.geometry.transform(this.projection, this.map.projection);
				}
				
	            this.features.push(feature);
	            
	            feature.layer = this;
	
	            if (!feature.style) {
	                feature.style = this.style;
	            }
	
	            this.preFeatureInsert(feature);
	
	            if (this.drawn) {
	                this.drawFeature(feature);
	            }
	            
	            this.onFeatureInsert(feature);
	        }
	    }
	    
	    public function removeFeatures(features:Object):void {
	    	if (!(features is Array)) {
	            features = [features];
	        }
	
	        for (var i:int = features.length - 1; i >= 0; i--) {
	            var feature:org.openscales.core.feature.VectorFeature = features[i];
	            this.features = Util.removeItem(this.features, feature);
	
	            if (feature.geometry) {
	                this.renderer.eraseGeometry(feature.geometry);
	            }

	            if (Util.indexOf(this.selectedFeatures, feature) != -1){
	                Util.removeItem(this.selectedFeatures, feature);
	            }
	        }
	    }
	    
	    /**
     * Erase and destroy features on the layer.
     *
     */
	    public function destroyFeatures():void {
	    	this.selectedFeatures = new Array();
	    	var destroyed:org.openscales.core.feature.VectorFeature = null;
	        while(this.features.length > 0) {
	            destroyed = this.features.shift();
	            this.renderer.eraseGeometry(destroyed.geometry);
	            destroyed.destroy();
	            destroyed = null;
	        }
	    }
	    
	    /**
	     * Draw (or redraw) a feature on the layer
	     * 
	     * @param feature
	     * @param style
	     */
	    public function drawFeature(feature:org.openscales.core.feature.VectorFeature, style:Style = null):void {
	    	if(style == null) {
	            if(feature.style) {
	                style = feature.style;
	            } else {
	                style = this.style;
	            }
	        }
	        
	        this.renderer.drawFeature(feature, style);
	    }
	    
	   /* public function eraseFeatures(feature:Array):void {
	    	this.renderer.eraseFeatures(features);
	    }*/
	    
	    public function getFeatureFromEvent(evt:MouseEvent):org.openscales.core.feature.VectorFeature {
	    	return  this.renderer.getFeatureFromEvent(evt);
	    }
	    
	    public function getFeatureById(featureId:String):org.openscales.core.feature.VectorFeature {
	    	var feature:org.openscales.core.feature.VectorFeature = null;
	        for(var i:int=0; i<this.features.length; ++i) {
	            if(this.features[i].id == featureId) {
	                feature = this.features[i];
	                break;
	            }
	        }
	        return feature;
	    }
	    
	    //Getters and setters
	    public function get features():Array {
			return this._features;
		}
		
		public function set features(value:Array):void {
			this._features = value;
		}
		
		public function get featuresBbox():Bounds {
			return this._featuresBbox;
		}
		
		public function set featuresBbox(value:Bounds):void {
			this._featuresBbox = value;
		}
		
		public function get selectedFeatures():Array {
			return this._selectedFeatures;
		}
		
		public function set selectedFeatures(value:Array):void {
			this._selectedFeatures = value;
		}
		
		public function get style():Style {
			return this._style;
		}
		
		public function set style(value:Style):void {
			this._style = value;
		}
		
		public function get renderer():Renderer {
			return this._renderer;
		}
		
		public function set renderer(value:Renderer):void {
			this._renderer = value;
		}
		
		public function get geometryType():String {
			return this._geometryType;
		}
		
		public function set geometryType(value:String):void {
			this._geometryType = value;
		}
		
		public function get drawn():Boolean {
			return this._drawn;
		}
		
		public function set drawn(value:Boolean):void {
			this._drawn = value;
		}
		
		override public function set projection(value:ProjProjection):void {
			super.projection = value;
			var f:VectorFeature;

			if (this.features.length > 0 && this.map != null && this.map.projection != null &&
				this.projection.srsCode != this.map.projection.srsCode) {
				for each (f in this.features) {
					f.geometry.transform(this.projection, this.map.projection);
				}
			}
		}
	    
	}
}