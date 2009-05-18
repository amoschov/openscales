package org.openscales.core.handler.mouse
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.renderer.SpriteElement;
	
	/**
	 * 
	 * DragFeature is use to drag a feature
	 * Create a new instance of  DragFeature with the constructor 
	 * 
	 * To use this handler, it's  necessary to add it to the map
	 * DragFeature is a pure ActionScript class. Flex wrapper and components can be found in the
	 * openscales-fx module FxDragFeature.
	 */
	 
	public class DragFeature extends DragHandler
	{
		/**
		 * The Featue which is drag
		 */
		private var _Feature:VectorFeature = null;	
					
		/**
		 * 
		 * The Group  of layers with draggable features
		 */
		private var _layer:Array=null;
		
		/**
		 * 
		 * The layer's number with dragging features
		 */
		private var _layer_number:Number=0;
		
		/**
		 * 
		 * dragged sprite
		 */	
		private var _elementDragging:SpriteElement=new SpriteElement();
		
		/**
		 * DragFeature constructor
		 *
		 * @param map the ClickHandler map
		 * @param active to determinates if the handler is active
		 * @param target  use to specify the layers we can drag to it
		 */
		public function DragFeature(map:Map=null,target:Array=null,active:Boolean=false)
		{
			super(map,active);
			this.layer=target;
		}
		
		override protected function registerListeners():void{
				this.map.addEventListener(FeatureEvent.FEATURE_MOUSEDOWN, this.onMouseDown);
				this.map.addEventListener(FeatureEvent.FEATURE_MOUSEUP, this.onMouseUp);	
			}
			
		override protected function unregisterListeners():void{
				this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEDOWN, this.onMouseDown);
				this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEUP, this.onMouseUp);
				
			}
		/**
		 * The MouseDown Listener
		 */
		override  protected function onMouseDown(event:Event):void
		{
			var cpt:Number=0;
			while(cpt!=this.layer.length)
			{
			if((event as FeatureEvent).vectorfeature.layer==this.layer[this.layer_number])
			{			
			this.Feature=(event as FeatureEvent).vectorfeature;
			if(this.onstart!=null) this.onstart((event as FeatureEvent),this.Feature);
	     	var index:int=0;
	        this.FeatureMove();
	       
			this.dragging=true;	
			cpt=this.layer.length;	
			}
			else
			{
			cpt++;
			this.layer_number++;
			}
			}
		}
		/**
		 * This function is use to move the feature
		 * 
		 */
		private function FeatureMove():void
		{
			var index:int=0;
			//We start to differentiates MultiGeometries and simple geometry
			if ((getQualifiedClassName(this.Feature.geometry) == "org.openscales.core.geometry::MultiPoint") ||
	            (getQualifiedClassName(this.Feature.geometry) == "org.openscales.core.geometry::MultiLineString") ||
	            (getQualifiedClassName(this.Feature.geometry) == "org.openscales.core.geometry::MultiPolygon")) {
				    
				    //The first element move and the others will follow it
				    var FirstGeomId:Geometry=((this.Feature.geometry as Collection).components[0] as Geometry);
				    this._elementDragging=this.layer[layer_number].renderer.container.getChildByName(FirstGeomId.id);
				    this._elementDragging.startDrag();
				    this.map.addEventListener(MouseEvent.MOUSE_MOVE,movefeatures);
				    this.dragging=false;  				     	            	
	           }
		     else
	          {
	           this._elementDragging=this.layer[layer_number].renderer.container.getChildByName(Feature.geometry.id);
	           this._elementDragging.startDrag();   
	           this.dragging=true;     
	          }
		}
		/**
		 * The MouseUp Listener
		 */
		override  protected function onMouseUp(event:Event):void
		{
			this.map.removeEventListener(MouseEvent.MOUSE_MOVE,movefeatures);
			this._elementDragging.stopDrag();			
			this.dragging=false;
			if(this.oncomplete!=null) this.oncomplete((event as FeatureEvent),this.Feature);
			this.layer_number=0;
			this._elementDragging=new SpriteElement();
		}
		/**
		 * This function is use to move the features during Multigeometries dragging
		 * 
		 */
		private  function movefeatures(event:MouseEvent):void
		{
			var dx:Number=_elementDragging.x-event.stageX;
			var dy:Number=_elementDragging.y-event.stageY;
			for(var i:int=1;i<(Feature.geometry as Collection).components.length;i++)
			{
				var Geom:Geometry=((Feature.geometry as Collection).components[i]as Geometry);
				var Sprite:SpriteElement=layer[layer_number].renderer.container.getChildByName(Geom.id);
				Sprite.x=event.stageX+dx;
				Sprite.y= event.stageY+dy;    	
			}
		}
		// Getters & setters as3
		/**
		 * The Featue which is drag
		 */
		
		public function set Feature(Feature:VectorFeature):void
		{
			this._Feature=Feature;
		}
		public function get Feature():VectorFeature
		{
			return this._Feature;
		}
		/**
		 * 
		 * The Group  of layers with draggable features
		 */
		public function get layer():Array
		{
			return this._layer;
		}
		public function set layer(layer:Array):void
		{
			this._layer=layer;
		}
		/**
		 * 
		 * The layer's number with dragging features
		 */
		public function get layer_number():Number
		{
			return this._layer_number;
		}
		public function set layer_number(layer_number:Number):void
		{
			this._layer_number=layer_number;
		}
	}
}