package org.openscales.core.control
{
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.handler.Feature;
	import org.openscales.core.layer.Vector;

	public class SelectFeature extends Control
	{
	
		public var multiple:Boolean = false; 

    	public var hover:Boolean = false;
    
    	public var onSelect:Function = new Function();

    	public var onUnselect:Function = new Function();
    	
    	public var selectStyle:Object = org.openscales.core.feature.Vector.style['select'];

		public function SelectFeature(layer:org.openscales.core.layer.Vector, options:Object):void {
	        super([options]);
	        
	        var feature:Feature = new Feature(this, layer);
	        feature.down = this.downFeature;
	        feature.over = this.overFeature;
	        feature.out = this.outFeature;
	       	this.handler = feature;
	        this.layer = layer;
			
		}
		
		public function downFeature(feature:org.openscales.core.feature.Vector):void {
			if(this.hover) {
	            return;
	        }
	        if (this.multiple) {
	            if(Util.indexOf(this.layer.selectedFeatures, feature) > -1) {
	                this.unselect(feature);
	            } else {
	                this.select(feature);
	            }
	        } else {
	            if(Util.indexOf(this.layer.selectedFeatures, feature) > -1) {
	                this.unselect(feature);
	            } else {
	                if (this.layer.selectedFeatures) {
	                    for (var i:int = 0; i < this.layer.selectedFeatures.length; i++) {
	                        this.unselect(this.layer.selectedFeatures[i]);
	                    }
	                }
	                this.select(feature);
	            }
	        }
		}
		
		public function overFeature(feature:org.openscales.core.feature.Vector):void {
			if(!this.hover) {
	            return;
	        }
	        if(!(Util.indexOf(this.layer.selectedFeatures, feature) > -1)) {
	            this.select(feature);
	        }
		}
		
		public function outFeature(feature:org.openscales.core.feature.Vector):void {
			if(!this.hover) {
	            return;
	        }
	        this.unselect(feature);
		}
		
		public function select(feature:org.openscales.core.feature.Vector):void {
	        if(feature.originalStyle == null) {
	            feature.originalStyle = feature.style;
	        }
	        this.layer.selectedFeatures.push(feature);
	        this.layer.drawFeature(feature, this.selectStyle);
	        this.onSelect(feature);
		}
		
		public function unselect(feature:org.openscales.core.feature.Vector):void {
	        if(feature.originalStyle == null) {
	            feature.originalStyle = feature.style;
	        }
	        this.layer.drawFeature(feature, feature.originalStyle);
	        Util.removeItem(this.layer.selectedFeatures, feature);
	        this.onUnselect(feature);
		}
		
		override public function setMap(map:Map):void {
			this.handler.setMap(map);
			super.setMap(map);
		}
		
	}
}