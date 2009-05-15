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

	public class DragFeature extends DragHandler
	{
		//Start position
		private var _Feature:VectorFeature = null;	
					
		//We can drag on many layers
		private var _layer:Array=null;
		
	
		private var _layer_number:Number=0;
		
		//dragged sprite 	
		private var _elementDragging:SpriteElement=new SpriteElement();

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
		private function FeatureMove():void
		{
			var index:int=0;
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

		override  protected function onMouseUp(event:Event):void
		{
			this.map.removeEventListener(MouseEvent.MOUSE_MOVE,movefeatures);
			this._elementDragging.stopDrag();			
			this.dragging=false;
			if(this.oncomplete!=null) this.oncomplete((event as FeatureEvent),this.Feature);
			this.layer_number=0;
			this._elementDragging=new SpriteElement();
		}
		//Listener MouseMove
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
		//Properties
		
		
		public function set Feature(Feature:VectorFeature):void
		{
			this._Feature=Feature;
		}
		public function get Feature():VectorFeature
		{
			return this._Feature;
		}

		public function get layer():Array
		{
			return this._layer;
		}
		public function set layer(layer:Array):void
		{
			this._layer=layer;
		}
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