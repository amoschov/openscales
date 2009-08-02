package org.openscales.core.layer
{
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.Feature;
	import org.openscales.proj4as.Proj4as;
	import org.openscales.proj4as.ProjPoint;
	import org.openscales.proj4as.ProjProjection;
	import org.openscales.core.feature.VectorFeature;
	
	/**
	 * Instances of Vector are used to render vector data from a variety of sources.
	 */
	public class VectorLayer extends Layer
	{
		    
	    private var _featuresBbox:Bounds = null;

	    private var _selectedFeatures:Array = null;
	
	    private var _style:Style = null;

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
	
	        this.selectedFeatures = new Array();
	        this.featuresBbox = new Bounds();
	        // For better performances
	        this.cacheAsBitmap = true;
	        this._temporaryProjection = this.projection;
	        
	    }
	    
	    override public function destroy(setNewBaseLayer:Boolean = true):void {
	        super.destroy();  
	
	        this.clear();
	        this.selectedFeatures = null;
	        this.geometryType = null;
	        this.drawn = false;
	    }
	    	    
	    override public function set map(map:Map):void {
	    	super.map = map;
	        
	      	this.map.addEventListener(LayerEvent.BASE_LAYER_CHANGED, this.checkProjection);
	            
            // Ugly trick due to the fact we can't set the size of and empty Sprite
            this.graphics.drawRect(0,0,this.map.width,this.map.height);
  			this.width = this.map.width;
  			this.height = this.map.height;
	        
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
		        this.removeChild(feature);
		        feature.draw();
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
        
	        if (!this.drawn || zoomChanged) {
	            this.drawn = true;
	            for(var i:int = 0; i < this.features.length; i++) {
	                var feature:VectorFeature = this.features[i];
	                feature.draw();
	            }
	        }
	    }
	    
	    /**
	     * Add Features to the layer.
	     *
	     * @param features array
	     */
	    public function addFeatures(features:Array):void {
	    	 for (var i:int = 0; i < features.length; i++) {
	    	 	this.addFeature(features[i]);
	    	 }
	    }
	    
	    /**
	     * Add Feature to the layer.
	     *
	     * @param feature The feature to add
	     */
	    public function addFeature(feature:VectorFeature):void {
            
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
			
            feature.layer = this;

            if (!feature.style) {
                feature.style = this.style;
            }

            this.preFeatureInsert(feature);
            this.addChild(feature);
            feature.draw();
            
            this.onFeatureInsert(feature);
	    }
	    
	    public function removeFeatures(features:Array):void {
	    	for (var i:int = 0; i < features.length; i++) {
	    	 	this.removeFeature(features[i]);
	    	 }
	    }
	    
	    public function removeFeature(feature:VectorFeature):void {
	            
            for(var j:int = 0;j<this.numChildren;j++)
	    	{
	    		if(this.getChildAt(j) == feature)
	    			this.removeChildAt(j);
			}
            if (Util.indexOf(this.selectedFeatures, feature) != -1){
                Util.removeItem(this.selectedFeatures, feature);
            }
		     	

	    }    
	    
	    public function getFeatureById(featureId:String):VectorFeature {
	    	var feature:VectorFeature = null;
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
			var featureArray:Array = new Array();

	    	for(var i:int = 0;i<this.numChildren;i++)
	    	{
	    		if(this.getChildAt(i) is Feature)
	    		{
	    				featureArray.push(this.getChildAt(i));
	    		}
	    	}
	    	return featureArray;
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
		
		public function clear():void {
            while (this.numChildren > 0) {
            	this.removeChildAt(this.numChildren-1);
            }
	    }
	    
	}
}