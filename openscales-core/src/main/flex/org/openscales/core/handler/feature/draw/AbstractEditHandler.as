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
		protected var _editionFeatureArray:Vector.<Vector.<Feature>>=new Vector.<Vector.<Feature>>();
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
		
		
		 /**
		 * create edition vertice(Virtual) only for edition feature
		 * @param geometry
		 * */
		public function createEditionVertices(vectorfeature:Feature,collection:Collection=null,arrayToFill:Vector.<Vector.<Feature>>=null):void {
			if (collection == null)
			collection=vectorfeature.geometry as Collection;
			var j:uint = collection.componentsLength;
			var v:Vector.<Feature>;
			var i:int;
			for (i=0; i < j; ++i) {
				var geometry:Geometry = collection.componentByIndex(i);
				if (geometry is Collection) {
					createEditionVertices(vectorfeature,geometry as Collection,arrayToFill);
				} else {
					if (geometry is Point) {
						var EditionVertice:Feature = new PointFeature(geometry.clone() as Point, null, Style.getDefaultCircleStyle());
						//We fill the array with the virtual vertice
						v = new Vector.<Feature>(2);
						v[0]=EditionVertice;
						v[1]=null
						arrayToFill.push(v);
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
				for(var i:int=0;i<_editionFeatureArray.length;i++){
				var feature:Feature=_editionFeatureArray[i][0] as Feature;
					//The edition feature are destroyed  in order to be elective for the Garbage Collector
					if(feature!=null){	
						feature.destroy();
						this._layerToEdit.removeFeature(feature);
						this._featureClickHandler.removeControledFeature(feature);
						feature=null;
					}	
					}
				}
				_editionFeatureArray=new Vector.<Vector.<Feature>>();
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
		 			var tmpfeature:Vector.<Vector.<Feature>>=new Vector.<Vector.<Feature>>();	
		 			var feature:Feature;
					var i:int = _editionFeatureArray.length - 1;
					for(i;i>-1;--i){
						 feature=_editionFeatureArray[i][0];
						 var featureParent:Feature=findVirtualVerticeParent(feature  as PointFeature);
						 //we also clean the virtual vertices array if the parent doesnt belongs anymore to the _layerToEdit.features array
						if(featureParent==featureEdited || this._layerToEdit.features.indexOf(featureParent)==-1){
							this._layerToEdit.removeFeature(feature);
		 					this._featureClickHandler.removeControledFeature(feature);
		 					tmpfeature.push(_editionFeatureArray[i]);
						}
					}
					//feature to delete
					if(tmpfeature.length!=0){
						//for each(feature in tmpfeature){
						i = tmpfeature.length - 1;
						var j:int;
						for(i;i>-1;--i){
							j = _editionFeatureArray.indexOf(tmpfeature[i]);
							if(j!=-1)
								_editionFeatureArray.slice(j,1);
						}
						 tmpfeature=null;
					}
					createEditionVertices(featureEdited,featureEdited.geometry as Collection,tmpfeature);
					var v:Vector.<Feature>;
					for each(v in tmpfeature){
						if(this.map.extent.containsBounds(v[0].geometry.bounds)){
							this._layerToEdit.addFeature(v[0]);
		 					this._featureClickHandler.addControledFeature(v[0]);
							v = new Vector.<Feature>(2);
							v[0]=feature;
							v[1]=featureEdited;
		 					this._editionFeatureArray.push(v);
							v=null;
						}
					}
					//for garbage collector
					tmpfeature=null;	
		 		}
		}
		/**
		 * This function is abble to find a virtual vertice parent
		 * @param virtualVertice the virtual vertice 
		 * @param arrayTosearch The array where to find the parent 
		 * */
		public function findVirtualVerticeParent(virtualVertice:PointFeature,arrayTosearch:Vector.<Vector.<Feature>>=null):Feature{
			if(virtualVertice){
				if(!arrayTosearch)
					arrayTosearch=this._editionFeatureArray;
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