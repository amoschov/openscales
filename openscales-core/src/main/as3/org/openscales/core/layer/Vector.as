package org.openscales.core.layer
{
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.renderer.SpriteRenderer;
	import org.openscales.core.renderer.Renderer;
	
	/**
	 * Instances of Vector are used to render vector data from a variety of sources.
	 */
	public class Vector extends Layer
	{

	    private var isVector:Boolean = true;
	
	    public var features:Array = null;

	    public var selectedFeatures:Array = null;
	
	    public var style:Object = null;
		
		private var renderers:Array = ['AS'];

	    public var renderer:Renderer = null;

	    private var geometryType:String = null;

	    private var drawn:Boolean = false;
	    
	    public var onFeatureInsert:Function = null;
	    
	    public var preFeatureInsert:Function = null;
	    
	    public function Vector(name:String, options:Object = null):void {
	    	var defaultStyle:Object = org.openscales.core.feature.Vector.style['default'];
	        this.style = Util.extend({}, defaultStyle);
	        
	        this.onFeatureInsert = new Function();
	        this.preFeatureInsert = new Function();
	
	        super(name, options);
	        
	        if (!this.renderer || !this.renderer.supported()) {  
	            this.assignRenderer();
	        }

	        if (!this.renderer || !this.renderer.supported()) {
	            this.renderer = null;
	            this.displayError();
	        } 
	
	        this.features = new Array();
	        this.selectedFeatures = new Array();
	        
	        // For better performances
	        this.cacheAsBitmap = true;
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
	    
	    private function displayError():void {
	    	if (this.reportError) {
	            var message:String = "Your browser does not support vector rendering. " + 
	                            "Currently supported renderers are:\n";
	            message += this.renderers.join("\n");
	            trace(message);
	        } 
	    }
	    
	    override public function set map(map:Map):void {
	    	super.map = map;
	
	        if (!this.renderer) {
	            this.map.removeLayer(this);
	        } else {
	            this.renderer.map = this.map;
	            this.renderer.setSize(this.map.size);
	        }
	    }
	    
	    override public function onMapResize():void {
	    	super.onMapResize();
        	this.renderer.setSize(this.map.size);
	    }
	    
	    override public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean = false):void {
	    	super.moveTo(bounds, zoomChanged, dragging);
	    	
	    	if (zoomChanged) {
	    		this.eraseFeatures(this.features);
	    	}
        
	        if (!dragging) {
	            //this.x = - int(this.map.layerContainer.x);
	            //this.y = - int(this.map.layerContainer.y);
	            var extent:Bounds = this.map.extent;
	            this.renderer.setExtent(extent);
	        }
	
	        if (!this.drawn || zoomChanged) {
	            this.drawn = true;
	            for(var i:int = 0; i < this.features.length; i++) {
	                var feature:org.openscales.core.feature.Vector = this.features[i];
	                this.drawFeature(feature);
	            }
	        }
	    }
	    
	    public function addFeatures(features:Object):void {
	    	if (!(features is Array)) {
	            features = [features];
	        }

	        for (var i:int = 0; i < features.length; i++) {
	            var feature:org.openscales.core.feature.Vector = features[i];
	            
	            if (this.geometryType &&
	                !(getQualifiedClassName(feature.geometry) == this.geometryType)) {
	                    var throwStr:String = "addFeatures : component should be an " + 
	                                    getQualifiedClassName(this.geometryType);
	                    throw throwStr;
	                }
	
	            this.features.push(feature);
	            
	            feature.layer = this;
	
	            if (!feature.style) {
	                feature.style = Util.extend({}, this.style);
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
	            var feature:org.openscales.core.feature.Vector = features[i];
	            this.features = Util.removeItem(this.features, feature);
	
	            if (feature.geometry) {
	                this.renderer.eraseGeometry(feature.geometry as Collection);
	            }

	            if (Util.indexOf(this.selectedFeatures, feature) != -1){
	                Util.removeItem(this.selectedFeatures, feature);
	            }
	        }
	    }
	    
	    public function destroyFeatures():void {
	    	this.selectedFeatures = new Array();
	        for (var i:int = this.features.length - 1; i >= 0; i--) {
	            this.features[i].destroy();
	        }
	    }
	    
	    public function drawFeature(feature:org.openscales.core.feature.Vector, style:Object = null):void {
	    	if(style == null) {
	            if(feature.style) {
	                style = feature.style;
	            } else {
	                style = this.style;
	            }
	        }
	        this.renderer.drawFeature(feature, style);
	    }
	    
	    public function eraseFeatures(feature:Array):void {
	    	this.renderer.eraseFeatures(features);
	    }
	    
	    public function getFeatureFromEvent(evt:MouseEvent):org.openscales.core.feature.Vector {
	    	var featureId:String = this.renderer.getFeatureIdFromEvent(evt);
        	return this.getFeatureById(featureId);
	    }
	    
	    public function getFeatureById(featureId:String):org.openscales.core.feature.Vector {
	    	var feature:org.openscales.core.feature.Vector = null;
	        for(var i:int=0; i<this.features.length; ++i) {
	            if(this.features[i].id == featureId) {
	                feature = this.features[i];
	                break;
	            }
	        }
	        return feature;
	    }
	    
	    public function clearSelection():void {
	    	var vectorLayer:Vector = this.map.vectorLayer as Vector;
	        for (var i:int = 0; i < this.map.featureSelection.length; i++) {
	            var featureSelection:org.openscales.core.feature.Vector = this.map.featureSelection[i];
	            vectorLayer.drawFeature(featureSelection, vectorLayer.style);
	        }
	        this.map.featureSelection = [];
	    }
	    
	}
}