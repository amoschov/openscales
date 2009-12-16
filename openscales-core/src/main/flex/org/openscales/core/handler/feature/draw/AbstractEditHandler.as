package org.openscales.core.handler.feature.draw
{
	import flash.display.Sprite;
	
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.handler.feature.FeatureClickHandler;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.style.Style;

	/**
	* Abstract edit handler never instanciate this class
	 * This class is the based class for the edition handlers
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
		 * The edition features array
		 * It contains all virtual vertice used for edition and their parents
		 * egg: A line contains at its first column the virtual vertice and at its' second column the parent of the virtual vertice
		 **/
		protected var _editionFeatureArray:Array=null;
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
			this._layerToEdit=layerToEdit;
			super(map,active);
			this._drawContainer=drawContainer; 
			this._editionFeatureArray=new Array();
		}
		/**
		 *@inheritDoc 
		 * */
		override public function set active(value:Boolean):void{
		 	//If the handler is used alone it activate or deactivate itself
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
		 	
		 }
		
		/*  public function refreshEditedfeatures(event:MapEvent=null):void{

		 	if(_layerToEdit!=null && !_isUsedAlone){
		 		for each(var vectorFeature:Feature in this._layerToEdit.features){	
					if(vectorFeature.isEditable && vectorFeature.geometry is Collection){			
						//We display on the layer concerned by the operation the virtual vertices used for edition
						displayVisibleVirtualVertice(vectorFeature);
					}
					//Virtual vertices treatment
					else if(vectorFeature is Point && Util.indexOf(this._editionFeatureArray,vectorFeature)!=-1)
					{
						//We remove the edition feature to create another 						
						//TODO Damien nda only delete the feature concerned by the operation
						_layerToEdit.removeFeature(vectorFeature);
						this._featureClickHandler.removeControledFeature(vectorFeature);
						vectorFeature.destroy();
						vectorFeature=null;
					} 
					else this._featureClickHandler.addControledFeature(vectorFeature);
				}
		 	}
		 	
		 } */
  		/**
		 * This function is used to start the edition of all vector features 
		 * in a layer
		 * @protected
		 * @param feature:Feature the feature to treat
		 * */
 		/* protected function refreshEditedfeature(feature:Feature):void{
 			if(_layerToEdit!=null && !_isUsedAlone){
 				if(feature.isEditable && feature.geometry is Collection){			
						//We display on the layer concerned by the operation the virtual vertices used for edition
						displayVisibleVirtualVertice(feature);
					}
					//Virtual vertices treatment
					else if(feature is Point && Util.indexOf(this._editionFeatureArray,feature)!=-1)
					{
						//We remove the edition feature to create another 						
						//TODO Damien nda only delete the feature concerned by the operation
						_layerToEdit.removeFeature(feature);
						this._featureClickHandler.removeControledFeature(feature);
						Util.removeItem(this._editionFeatureArray,feature);
						feature.destroy();
						feature=null;
					} 
					else this._featureClickHandler.addControledFeature(feature);
 			}
 		} */
 		
		 /**
		 * create edition vertice(Virtual) only for edition feature
		 * @param geometry
		 * */
		public function createEditionVertices(vectorfeature:Feature,collection:Collection=null,arrayToFill:Array=null):void {
			if (collection == null)
			collection=vectorfeature.geometry as Collection;
			for (var i:int = 0; i < collection.componentsLength; i++) {
				var geometry:Geometry = collection.componentByIndex(i);
				if (geometry is Collection) {
					createEditionVertices(vectorfeature,geometry as Collection,arrayToFill);
				} else {
					if (geometry is Point) {
						var EditionVertice:PointFeature = new PointFeature(geometry.clone() as Point, null, Style.getDefaultCircleStyle(), true, collection);
						//We fill the array with the virtual vertice
						arrayToFill.push(EditionVertice);
						/* EditionVertice.editionFeatureParent = vectorfeature; */
					}
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
				//for each(var vectorfeature:Feature in _editionFeatureArray){
				for(var i:int=0;i<_editionFeatureArray.length;i++){
				var feature:Feature=_editionFeatureArray[i][0] as Feature;
					//The edition feature are destroyed  in order to be elective for the Garbage Collector
					/* if(vectorfeature is PointFeature && Util.indexOf(this._editionFeatureArray,vectorfeature)!=-1){	 */			
					if(feature!=null){	
						feature.destroy();
						this._layerToEdit.removeFeature(feature);
						/* vectorfeature.editionFeaturesArray=null; */
						this._featureClickHandler.removeControledFeature(feature);
						feature=null;
					}	
					/* } */
				/* 	else vectorfeature.editionFeaturesArray=null; */
					}
				}
				_editionFeatureArray=new Array();
			}
		 	return true;
		 }
		  /**
		 * Use this function only this when you want to use the handler alone
		 * if you want to modify at the same time different type of geometries use the LayerEditionHandler
		 * */
		 public function set featureClickHandler(handler:FeatureClickHandler):void{
		 	//if the handler is used alone we associate it with a featureClickHandler
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
					//We only draw the points included in the map extent
		 			var tmpfeature:Array=new Array();	
		 			var feature:Feature;
					
					
					
					
					/*for each(feature in _editionFeatureArray){*/
					
					for(var i:int=0;i<_editionFeatureArray.length;i++){
						 feature:feature=_editionFeatureArray[i][0];
						 var featureParent:Feature=findVirtualVerticeParent(feature  as PointFeature);
						 //we alseo clean the virtual vertices array if the parent doesnt belongs anymore to the _layerToEdit.features array
						if(featureParent==featureEdited || Util.indexOf(this._layerToEdit.features,featureParent)==-1){
							this._layerToEdit.removeFeature(feature);
		 					this._featureClickHandler.removeControledFeature(feature);
		 					tmpfeature.push(_editionFeatureArray[i]);
						}
					}
					//feature to delete
					if(tmpfeature.length!=0){
						//for each(feature in tmpfeature){
						for(i=0;i<tmpfeature.length;i++){
							Util.removeItem(_editionFeatureArray,tmpfeature[i]);
						}
						 tmpfeature=new Array();
					}
					createEditionVertices(featureEdited,featureEdited.geometry as Collection,tmpfeature);
					for each(feature in tmpfeature){
						if(this.map.extent.containsBounds(feature.geometry.bounds)){
							this._layerToEdit.addFeature(feature);
		 					this._featureClickHandler.addControledFeature(feature);
		 					this._editionFeatureArray.push(new Array(feature,featureEdited));
						}
					}
					//for garbage collector
					tmpfeature=null;	
					 
				/*	//Vertices update
		 			  if(featureEdited.editionFeaturesArray!=null)
		 					{
		 						this._layerToEdit.removeFeatures(featureEdited.editionFeaturesArray);
		 						this._featureClickHandler.removeControledFeatures(featureEdited.editionFeaturesArray);
		 					} 
		 				featureEdited.refreshEditionVertices();	 
		 				
		 				for each(var feature:Feature in _editionFeatureArray){
		 					if(this.map.extent.containsBounds(feature.geometry.bounds)){
		 						this._layerToEdit.addFeature(feature);
		 						this._featureClickHandler.addControledFeature(feature);
		 						tmpfeature.push(feature);
		 					}
		 				}
		 			//We update the editionFeaturesArray 
		 			featureEdited.editionFeaturesArray=tmpfeature; 
		 			tmpfeature=null; */
		 		}
		}
		/**
		 * This function is abble to find a virtual vertice parent
		 * @param virtualVertice the virtual vertice 
		 * @param arrayTosearch The array where to find the parent 
		 * */
		public function findVirtualVerticeParent(virtualVertice:PointFeature,arrayTosearch:Array=null):Feature{
			if(virtualVertice){
				if(!arrayTosearch)arrayTosearch=this._editionFeatureArray;
				for(var i:int=0;i<arrayTosearch.length;i++){
					//we return the parent if we find the virtual 
					if(arrayTosearch[i][0]==virtualVertice) return arrayTosearch[i][1];
				}	
			}
			return null;
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