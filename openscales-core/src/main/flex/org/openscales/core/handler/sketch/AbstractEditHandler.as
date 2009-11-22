package org.openscales.core.handler.sketch
{
	import flash.display.Sprite;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.handler.mouse.FeatureClickHandler;
	import org.openscales.core.layer.FeatureLayer;
	/**
	* Abstract edit handler never instanciate this class
	**/
	public class AbstractEditHandler extends Handler implements IEditVectorFeature
	{
		/**
		 * the layer concerned by the edition
		 * @protected
		 * */
		protected var _layerToEdit:FeatureLayer=null;
		/**
		 *This handler is used for differenciation of mouse actions(drag drop clikc double click) 
		 * during the edition .
		 * @protected
		 **/
		protected var _featureClickHandler:FeatureClickHandler=null;
		
		/**
		 * The feature currently dragged
		 * @protected
		 * */
		protected var _featureCurrentlyDrag:VectorFeature=null;
		
		/**
		 * This sprite is used to draw temporaries features during dragging
		 * @protected
		 * */
		protected var _drawContainer:Sprite=null;
		
		/**
		 * Constructor
		 * @param map Map object
		 * @param active for handler activation
		 * @param layerToEdit  the layer concerned by the edition
		 * @param featureClickHandler This handler is used for differenciation of mouse actions
		 * @param drawContainer This sprite is used to draw temporaries features during dragging
		 * @protected
		 * */
		public function AbstractEditHandler(map:Map = null, active:Boolean = false,layerToEdit:FeatureLayer=null,featureClickHandler:FeatureClickHandler=null,drawContainer:Sprite=null)
		{
			if(_featureClickHandler!=null){
				this._featureClickHandler=featureClickHandler;
				this._featureClickHandler.map=map;
			}
			this._layerToEdit=layerToEdit;
			super(map,active);
			this._drawContainer=drawContainer; 
		}
		/**
		 *@inheritDoc 
		 * */
		override public function set active(value:Boolean):void{
		 	super.active=value;
		 	if(value && map!=null) this.editionModeStart();
		 	if(!value && map!=null ) this.editionModeStop();
		 	if(this._featureClickHandler!=null)this._featureClickHandler.active=value;
		 }
		 /**
		 * Start the edition Mode
		 * */
		 public function editionModeStart():Boolean{
		 	return true;
		 }
		 /**
		 * Stop the edition Mode
		 * */
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
		  /**
		 * Use this function only this when you want to use the handler alone
		 * if you want to modify at the same time different type of geometries use the LayerEditionHandler
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
		 /**
		 * Map Settings
		 * */
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
		 /**
		 * This function is launched when you are dragging a vertice(Virtual or not)
		 * 
		 * */	
		 public function dragVerticeStart(event:FeatureEvent):void{
		
		 }
		 /**
		 * This function is launched when you stop  dragging a vertice(Virtual or not)
		 * 
		 * */
		 public function dragVerticeStop(event:FeatureEvent):VectorFeature{
		 	return null;
		 }
		 /**
		 * This function is launched when you click  on a vertice(Virtual or not)
		 * for the moment nothing is done
		 * */
		 public function featureClick(event:FeatureEvent):void{
		 	event.feature.stopDrag();
		 	this._layerToEdit.redraw();
		 }
		  /**
		 * This function is launched when you double click  on a vertice(Virtual or not)
		 * For the moment the vertice is deleted
		 * */
		 public function featureDoubleClick(event:FeatureEvent):void{
		 
		 }
		 
		 //getters & setters
		 public function set layerToEdit(value:FeatureLayer):void{
		 	this._layerToEdit=value;
		 }
		 public function get layerToEdit():FeatureLayer{
		 	return this._layerToEdit;
		 }
		 
	}
}