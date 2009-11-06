package org.openscales.core.handler.sketch
{
	import flash.display.Sprite;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.handler.mouse.FeatureClickHandler;
	import org.openscales.core.layer.VectorLayer;
	
	public class AbstractEditHandler extends Handler implements IEditVectorFeature
	{
		protected var _layerToEdit:VectorLayer=null;
		protected var _featureClickHandler:FeatureClickHandler=null;
		protected var _featureCurrentlyDrag:VectorFeature=null;
		
		/**
		 * This sprite is used to draw temporary feature during dragging
		 * 
		 * */
		protected var _drawContainer:Sprite=null;
		
		/**
		 * Abstract edit handler don't instanciate this class
		 * 
		 * */
		public function AbstractEditHandler(map:Map = null, active:Boolean = false,layerToEdit:VectorLayer=null,featureClickHandler:FeatureClickHandler=null,drawContainer:Sprite=null)
		{
			if(_featureClickHandler!=null){
				this._featureClickHandler=featureClickHandler;
				this._featureClickHandler.map=map;
			}
			this._layerToEdit=layerToEdit;
			super(map,active);
			this._drawContainer=drawContainer; 
		}
		
		override public function set active(value:Boolean):void{
		 	super.active=value;
		 	if(value && map!=null) this.editionModeStart();
		 	if(!value && map!=null ) this.editionModeStop();
		 	if(this._featureClickHandler!=null)this._featureClickHandler.active=value;
		 }
		 public function editionModeStart():Boolean{
		 	return true;
		 }
		  public function editionModeStop():Boolean{
		 	if(_layerToEdit !=null)
			{
				if(this._featureClickHandler!=null){
					this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_END,this._layerToEdit));
					this._featureClickHandler.removeControledFeatures();
					
				for each(var vectorfeature:VectorFeature in _layerToEdit.features){
					if(vectorfeature.isEditionFeature){
						this._layerToEdit.removeFeature(vectorfeature);
					}
					}
				}
			}
		 	return true;
		 }
		 public function dragVerticeStart(event:FeatureEvent):void{
		
		 }
		 public function dragVerticeStop(event:FeatureEvent):VectorFeature{
		 	return null;
		 }
		 public function featureClick(event:FeatureEvent):void{
		 	event.feature.stopDrag();
		 	this._layerToEdit.redraw();
		 }
		 public function featureDoubleClick(event:FeatureEvent):void{
		 
		 }
		 
		 //getters & setters
		 public function set layerToEdit(value:VectorLayer):void{
		 	this._layerToEdit=value;
		 }
		 public function get layerToEdit():VectorLayer{
		 	return this._layerToEdit;
		 }
		 
		 /**
		 * Use only this when you want to use the handler alone
		 * 
		 * */
		 public function set featureClickHandler(handler:FeatureClickHandler):void{
		 	if(handler!=null){
		 		this._featureClickHandler=handler;
		 		this._featureClickHandler.click=featureClick;
				this._featureClickHandler.doubleclick=featureDoubleClick;
				this._featureClickHandler.startDrag=dragVerticeStart;
				this._featureClickHandler.stopDrag=dragVerticeStop;
		 	}
		 }
		 
		 override public function set map(value:Map):void{
		 	if(value!=null){
		 		super.map=value;
		 		if(this._featureClickHandler!=null) this._featureClickHandler.map=value;
		 		if( this._drawContainer==null){
					this._drawContainer=new Sprite();
					this.map.addChild(_drawContainer);
				}
			}		 	
		 	}
	}
}