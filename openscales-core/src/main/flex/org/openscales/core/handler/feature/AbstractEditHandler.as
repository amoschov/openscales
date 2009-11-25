package org.openscales.core.handler.feature
{
	import flash.display.Sprite;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;

	import org.openscales.core.events.MapEvent;

	import org.openscales.core.feature.Feature;

	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.handler.feature.FeatureClickHandler;
	import org.openscales.core.layer.FeatureLayer;

	/**
	* Abstract edit handler never instanciate this class
	**/
	public class AbstractEditHandler extends Handler implements IEditFeature
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
		protected var _featureCurrentlyDrag:Feature=null;
		
		/**
		 * This sprite is used to draw temporaries features during dragging
		 * @protected
		 * */
		protected var _drawContainer:Sprite=null;
		
		/**
		 * To specify that the edition Handler is used alone(PathHandler || PointHandler etc)
		 * or associated with other handlers in LayerEditionHandler
		 * */
		protected var _isUsedAlone:Boolean=true;
		
		/**
		 * Constructor
		 * @param map Map object
		 * @param active for handler activation
		 * @param layerToEdit  the layer concerned by the edition
		 * @param featureClickHandler This handler is used for differenciation of mouse actions
		 * @param drawContainer This sprite is used to draw temporaries features during dragging
		 * @protected
		 * */
		public function AbstractEditHandler(map:Map = null, active:Boolean = false,layerToEdit:FeatureLayer=null,featureClickHandler:FeatureClickHandler=null,drawContainer:Sprite=null,isUsedAlone:Boolean=true)
		{
			if(_featureClickHandler!=null){
				this._featureClickHandler=featureClickHandler;
				this._featureClickHandler.map=map;
			}
			this._isUsedAlone=isUsedAlone;
			if(isUsedAlone){
				 
			}
			this._layerToEdit=layerToEdit;
			super(map,active);
			this._drawContainer=drawContainer; 
		}
		/**
		 *@inheritDoc 
		 * */
		override public function set active(value:Boolean):void{
		 	
		 	if(_isUsedAlone){
		 		if(value  && map!=null && !active){
		 			this.map.addEventListener(MapEvent.MOVE_END,refreshEditedfeatures);
				 	this.map.addEventListener(MapEvent.ZOOM_END,refreshEditedfeatures);
		 			this.editionModeStart();
		 		} 
		 		if(!value && map!=null && active ){
		 			this.map.removeEventListener(MapEvent.MOVE_END,refreshEditedfeatures);
					this.map.removeEventListener(MapEvent.ZOOM_END,refreshEditedfeatures);
		 			this.editionModeStop();
		 		} 
		 		this._featureClickHandler.active=value; 		
		 	}
		 	super.active=value;
		 }

		 /**
		 * This function is used to start the edition of all vector features 
		 * in a layer
		 * only use by LayerEditionHandler
		 * */
		 public function refreshEditedfeatures(event:MapEvent=null):void{

		 	if(_layerToEdit!=null && !_isUsedAlone){
		 		for each(var vectorFeature:Feature in this._layerToEdit.features){	
					if(vectorFeature.isEditable && vectorFeature.geometry is Collection){			
						//Clone or not
						displayVisibleVirtualVertice(vectorFeature);
					}
					else if(vectorFeature.isEditionFeature)
					{
						_layerToEdit.removeFeature(vectorFeature);
						this._featureClickHandler.removeControledFeature(vectorFeature);
						vectorFeature.destroy();
						vectorFeature=null;
					} 
					else this._featureClickHandler.addControledFeature(vectorFeature);
				}
		 	}
		 	
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
				{
					this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_END,this._layerToEdit));
					/* this._featureClickHandler.removeControledFeatures(); */
					
				for each(var vectorfeature:Feature in _layerToEdit.features){
					if(vectorfeature.isEditionFeature){				
						vectorfeature.destroy();
						this._layerToEdit.removeFeature(vectorfeature);
						vectorfeature.editionFeaturesArray=null;
						this._featureClickHandler.removeControledFeature(vectorfeature);
						vectorfeature=null;
					}
					else vectorfeature.editionFeaturesArray=null;
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
		 	 if(handler!=null && _isUsedAlone){
		 		this._featureClickHandler=handler;
		 		this._featureClickHandler.click=featureClick;
				this._featureClickHandler.doubleclick=featureDoubleClick;
				this._featureClickHandler.startDrag=dragVerticeStart;
				this._featureClickHandler.stopDrag=dragVerticeStop;
		 	} 
		 	this._featureClickHandler=handler;
		 }
		 /**
		 * Map Settings
		 * */
		 override public function set map(value:Map):void{
		 	if(value!=null){
		 		super.map=value;
		 		 this._featureClickHandler.map=value;
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
		 public function dragVerticeStart(vectorfeature:PointFeature):void{
		
		 }
		 /**
		 * This function is launched when you stop  dragging a vertice(Virtual or not)
		 * 
		 * */
		 public function dragVerticeStop(vectorfeature:PointFeature):void{
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
		 /**
		 * This function is used for displaying only visible virtual vertices
		 * in the extent
		 * @private
		 * @param featureEdited: the feature edited
		 * */
		protected function displayVisibleVirtualVertice(featureEdited:Feature):void{
					if(featureEdited!=null) {
					//Vertices update
		 				if(featureEdited.editionFeaturesArray!=null)
		 					{
		 						this._layerToEdit.removeFeatures(featureEdited.editionFeaturesArray);
		 						this._featureClickHandler.removeControledFeatures(featureEdited.editionFeaturesArray);
		 					}
		 				featureEdited.RefreshEditionVertices();		
		 				//We only draw the points included in the map extent
		 				var tmpfeature:Array=new Array();
		 				for each(var feature:Feature in featureEdited.editionFeaturesArray){
		 					if(this.map.extent.containsBounds(feature.geometry.bounds)){
		 						this._layerToEdit.addFeature(feature);
		 						this._featureClickHandler.addControledFeature(feature);
		 						tmpfeature.push(feature);
		 					}
		 				}
		 			//We update the editionFeaturesArray 
		 			featureEdited.editionFeaturesArray=tmpfeature;
		 			tmpfeature=null;
		 		}
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