package org.openscales.core.layer
{
	import org.openscales.core.Layer;
	import org.openscales.core.Marker;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.Pixel;

	public class Markers extends Layer
	{
	
	    public var drawn:Boolean = false;
	    
	    public function Markers(name:String, options:Object = null):void {
	    	super(name, options);
	    	this.markers = [];
	    }
	    
	    override public function destroy(setNewBaseLayer:Boolean = true):void {
	    	this.clearMarkers();
	    	this.markers = null;
	    	super.destroy(setNewBaseLayer);
	    }
	    
	    public function setOpacity(opacity:Number):void {
	    	if (opacity != this.opacity) {
            	this.opacity = opacity;
            	for (var i:int = 0; i < this.markers.length; i++) {
                	this.markers[i].setOpacity(this.opacity);
            	}
        	}
	    }
	    
	    override public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean=false):void {
	    	super.moveTo(bounds, zoomChanged, dragging);

	        if (zoomChanged || !this.drawn) {
	            for(var i:int=0; i < this.markers.length; i++) {
	                this.drawMarker(this.markers[i]);
	            }
	            this.drawn = true;
	        }
	    }
	    
	    public function addMarker(marker:Marker):void {
	    	this.markers.push(marker);
	        if (this.map && this.map.getExtent()) {
	            marker.map = this.map;
	            this.drawMarker(marker);
	        }
	    }
	    
	    public function removeMarker(marker:Marker):void {
	        Util.removeItem(this.markers, marker);
	        if ((marker != null) && (marker.parent == this) ) {
	            this.removeChild(marker);    
	            marker.drawn = false;
	        }
	    }
	    
	    public function clearMarkers():void {
	    	if (this.markers != null) {
	            while(this.markers.length > 0) {
	                this.removeMarker(this.markers[0]);
	            }
	        }
	    }
	    
	    public function drawMarker(marker:Marker):void {
	    	var px:Pixel = this.map.getLayerPxFromLonLat(marker.lonlat);
	        if (px == null) {
	            marker.visible = false;
	        } else {
	            marker.draw(px);
	            if (!marker.drawn) {
	                this.addChild(marker);
	                marker.drawn = true;
	            }
	        }
	    }
	    
	    public function bringToFront(marker:Marker):void {
	    	this.setChildIndex(marker, this.numChildren-1);
	    }
	    
	    public function getDataExtent():Bounds {
	    	var maxExtent:Bounds = null;
        
        	if ( this.markers && (this.markers.length > 0)) {
            	maxExtent = new Bounds();
            	for(var i:int=0; i < this.markers.length; i++) {
                	var marker:Marker = this.markers[i];
                	maxExtent.extend(marker.lonlat);
            	}
        	}

        	return maxExtent;
	    }
		
	}
}