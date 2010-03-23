package org.openscales.core.layer
{
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.events.MapEvent;
	import org.openscales.proj4as.ProjProjection;
    /**
     *this class allow to have a layer with two layer inside , one layer is displayed according to scale 
     */
	public class PolyLayers extends Layer
	{
		private var _firstLayer:Layer;
		
		private var _lastLayer:Layer;
		
		private var _isFirstLayer:Boolean;
		
		override public function set maxExtent(value:Bounds):void {
			super.maxExtent = value;
			this._firstLayer.maxExtent = value;
			this._lastLayer.maxExtent = value;
		}
		
		override public function set map(map:Map):void {
			if(map != null){
			  this._firstLayer.map = map;
			  this._firstLayer.removeEventListenerFromMap();
			  this._lastLayer.map  = map;
			  this._lastLayer.removeEventListenerFromMap();
			  super.map = map;
			  if(this.map.zoom > this._zoomToSwitch )
			  {
			  	_isFirstLayer = true;
			    this.addChild(this._firstLayer);
			  }
			  else{
			  	_isFirstLayer = false;
			    this.addChild(this._lastLayer);
			  }
			}
			
		}
		
		public function changeLayer():void{
		
			 if(_isFirstLayer== false && this.map.zoom > this._zoomToSwitch )
			  {
			  	this.removeChild(this._lastLayer);
			  	_isFirstLayer = true;
			    this.addChild(this._firstLayer);
			  }
			  if(_isFirstLayer== true && this.map.zoom <= this._zoomToSwitch ){
			  	this.removeChild(this._firstLayer);
			  	_isFirstLayer = false;
			    this.addChild(this._lastLayer);
			  }
			
		}
		
		override public function destroy(setNewBaseLayer:Boolean=true):void {
			if(_isFirstLayer== false)
			{
			  this.removeChild(this._lastLayer);
            }else{
			  this.removeChild(this._firstLayer);
			}
			super.destroy(setNewBaseLayer);
		}
		
		override public function onMapZoom(e:MapEvent):void {
			changeLayer();
			this.redraw();
		}
		
		
		override public function get projection():ProjProjection {
			
			if(this.map == null){
				  return this._firstLayer.projection;
			}
			
			if(this.map.zoom > this._zoomToSwitch )
			{
			  return this._firstLayer.projection;
			}
			else{
			  return this._lastLayer.projection;
			}
		}
		
		override public function get minResolution():Number {
			
			if(this.map.zoom > this._zoomToSwitch )
			{
			  return this._firstLayer.minResolution;
			}
			else{
			  return this._lastLayer.minResolution;
			}
			
		}
		
		override public function get maxResolution():Number {
			if(this.map.zoom > this._zoomToSwitch )
			{
			  return this._firstLayer.maxResolution;
			}
			else{
			  return this._lastLayer.maxResolution;
			}
		}
		/*before this zoom the firtlayer will be visible
		  after this zoom the lastlayer will be visible
		  */
		  
		private var _zoomToSwitch:Number;
		
		public function PolyLayers(name:String, firstLayer:Layer,lastLayer:Layer,zoomToSwitch:Number,isBaseLayer:Boolean=false, visible:Boolean=true)
		{
			
            this._firstLayer = firstLayer;
            this._lastLayer = lastLayer;	
            this._zoomToSwitch = zoomToSwitch;		
			super(name, isBaseLayer, visible, null, null);
		}
		override public function onMapResize(e:MapEvent):void {
			
			if(this.visible)
			{
			  if(this.map.zoom > this._zoomToSwitch ) {
				this._firstLayer.redraw();
			  }
			  else{
			  	this._lastLayer.redraw();
			  }
		    }
		}
	
		
		/**
		 * Clear the layer graphics
		 */
		override public function clear():void {
			
			if(this.map.zoom > this._zoomToSwitch ) {
				this._firstLayer.clear();
			  }
			  else{
			  	this._lastLayer.clear();
			  }
			
		}
		
		/**
		 * Reset layer data
		 */
		override public function reset():void {
			if(this.map.zoom > this._zoomToSwitch ) {
				this._firstLayer.reset();
			  }
			  else{
			  	this._lastLayer.reset();
			  }
		}
		/**
		 * Clear and draw, if needed, layer based on current data eventually retreived previously by moveTo function.
		 * 
		 * @return true if the layer was redrawn, false if not
		 */
		override public function redraw(fullRedraw:Boolean = true):void {
			if(this.map.zoom > this._zoomToSwitch ) {
				this._firstLayer.redraw();
			  }
			  else{
			  	this._lastLayer.redraw();
			  }
		}
		/**
		 * return the layer that is displayed on the map
		 */ 
		public function getDisplayLayer():Layer{
			
			if(this.map.zoom > this._zoomToSwitch ) {
				return this._firstLayer;
			  }
			  else{
			  	return this._lastLayer;
			  }
		}
		/**
		 * return the vector layer, if there one
		 * return the vector layer that is displayed if there are two
		 * return null if there are no vector layer
		 * this function is usefull , for legend(for example).
		 */
		public function getFeatureLayer():FeatureLayer{
			if(this._firstLayer is FeatureLayer && this._lastLayer is FeatureLayer){
			  if(this.map.zoom > this._zoomToSwitch ) {
				 return this._firstLayer as FeatureLayer;
			  }
			  else{
			  	return this._lastLayer as FeatureLayer;
			  }
			}
			else{
				if(this._firstLayer is FeatureLayer){
					return this._firstLayer as FeatureLayer;
				}
				if(this._lastLayer is FeatureLayer){
					return this._firstLayer as FeatureLayer;
				}
				
				return null;
			}
		}
		
		
           /**
             * Get a polyLayers zoomToSwitch
             */
            public function get zoomToSwitch():Number{
                  return this._zoomToSwitch;
            }
            
            /**
             * Set a polyLayers zoomToSwitch
             */
            public function set zoomToSwitch(value:Number):void {
                  this._zoomToSwitch = value;
            }
   }
}