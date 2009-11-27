package org.openscales.core.handler.feature
{
	import flash.display.Sprite;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.MultiPolygonFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.handler.feature.AbstractEditHandler;
	import org.openscales.core.handler.feature.EditCollectionHandler;
	import org.openscales.core.handler.feature.EditPathHandler;
	import org.openscales.core.handler.feature.EditPointHandler;
	import org.openscales.core.handler.feature.EditPolygonHandler;
	import org.openscales.core.handler.feature.IEditFeature;
	import org.openscales.core.layer.FeatureLayer;
	
	
	/**
	 * This handler is used to have an edition Mode 
	 * Which allow to modify all geometries
	 * */
	public class FeatureLayerEditionHandler extends Handler
	{
		/**
		 *Layer to edit
		 * @private 
		 **/
		protected var _layerToEdit:FeatureLayer=null;
		
		private var iEditPoint:IEditFeature=null; 
		private var iEditPath:IEditFeature=null;
		private var iEditPolygon:IEditFeature=null;
		
		private var _featureClickHandler:FeatureClickHandler=null;
		
		private var _drawContainer:Sprite=new Sprite();
		
		/**
		 * Handler of edition mode 
		 * @param editPoint to know if the edition of point is allowed
		 * @param editPath to know if the edition of path is allowed
		 * @param editPolygon to know if the edition of polygon is allowed
		 * */
		public function FeatureLayerEditionHandler(map:Map = null,layer:FeatureLayer=null,active:Boolean = false,editPoint:Boolean=true,editPath:Boolean=true,editPolygon:Boolean=true)
		{
			//Handler click Management
			
			this._featureClickHandler=new FeatureClickHandler(map,active);
			this._featureClickHandler.click=featureClick;
			this._featureClickHandler.doubleclick=featureDoubleClick;
			this._featureClickHandler.startDrag=dragVerticeStart;
			this._featureClickHandler.stopDrag=dragVerticeStop;
			
			
			
			this._layerToEdit=layer;
			if(editPoint)iEditPoint=new EditPointHandler(map,active,layer,_featureClickHandler,_drawContainer,false);
			if(editPath){
				iEditPath=new EditPathHandler(map,active,layer,_featureClickHandler,_drawContainer,false);
			}
			if(editPolygon)iEditPolygon=new EditPolygonHandler(map,active,layer,_featureClickHandler,_drawContainer,false);
			super(map,active);
		}
		/**
		 * drag vertice start function
		 * 
		 * */
		private function dragVerticeStart(event:FeatureEvent):void{
			
			var vectorfeature:PointFeature=(event.feature) as PointFeature;
			if(vectorfeature!=null){
				//The Vertice belongs to a polygon
				 if	((vectorfeature.editionFeatureParent is PolygonFeature || vectorfeature.editionFeatureParent is MultiPolygonFeature )&& iEditPolygon!=null) iEditPolygon.dragVerticeStart(vectorfeature);
				//The vertice belongs to a line
				else if((vectorfeature.editionFeatureParent is LineStringFeature ||  vectorfeature.editionFeatureParent is MultiLineStringFeature)&& iEditPath!=null) iEditPath.dragVerticeStart(vectorfeature);
		
				else if(iEditPoint!=null) iEditPoint.dragVerticeStart(vectorfeature);	
				this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
			}
		 }
		 /**
		 * 
		 * drag vertice stop function
		 * */
		 private function dragVerticeStop(event:FeatureEvent):void{
		 	
		 	var vectorfeature:PointFeature=event.feature as PointFeature;
			if(vectorfeature!=null){
					
					if(vectorfeature.editionFeatureParent==null && iEditPoint!=null) iEditPoint.dragVerticeStop(vectorfeature);
					//The Vertice belongs to a polygon
					else if	((vectorfeature.editionFeatureParent is PolygonFeature || vectorfeature.editionFeatureParent is MultiPolygonFeature ) && iEditPolygon!=null) iEditPolygon.dragVerticeStop(vectorfeature);
					
					//The vertice belongs to a line
					else if((vectorfeature.editionFeatureParent is LineStringFeature ||  vectorfeature.editionFeatureParent is MultiLineStringFeature) && iEditPath!=null) iEditPath.dragVerticeStop(vectorfeature);
					this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
				}
			}
			/**
			 * feature click function
			 * */
		 private function featureClick(event:FeatureEvent):void{
		 	var vectorfeature:PointFeature=(event.feature) as PointFeature;
			if(vectorfeature!=null){
					///real point feature
					if(vectorfeature.editionFeatureParent==null && iEditPoint!=null) iEditPoint.featureClick(event);
					//The Vertice belongs to a polygon
					else if	((vectorfeature.editionFeatureParent is PolygonFeature || vectorfeature.editionFeatureParent is MultiPolygonFeature ) && iEditPolygon!=null) iEditPolygon.featureClick(event);
					//The vertice belongs to a line
					else if((vectorfeature.editionFeatureParent is LineStringFeature ||  vectorfeature.editionFeatureParent is MultiLineStringFeature) && iEditPath!=null) iEditPath.featureClick(event);
					this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
				}	 
		 }
		 /**
		 * feature double click
		 * */
		 private function featureDoubleClick(event:FeatureEvent):void{
		 var vectorfeature:PointFeature=(event.feature) as PointFeature;
			if(vectorfeature!=null){
				var featureParent:Feature=vectorfeature.editionFeatureParent;
				///real point feature
				if(vectorfeature.editionFeatureParentGeometry==null && iEditPoint!=null) iEditPoint.featureDoubleClick(event);
				//The Vertice belongs to a polygon
					else if	((vectorfeature.editionFeatureParent is PolygonFeature || vectorfeature.editionFeatureParent is MultiPolygonFeature ) && iEditPolygon!=null) iEditPolygon.featureDoubleClick(event);
				//The vertice belongs to a line
					else if((vectorfeature.editionFeatureParent is LineStringFeature ||  vectorfeature.editionFeatureParent is MultiLineStringFeature) && iEditPath!=null) iEditPath.featureDoubleClick(event);
		 			this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
		 }
		 
		 }
		
		
		/**
		 * Start the edition Mode
		 * */
		protected function editionModeStart():Boolean{
			if(_layerToEdit !=null)
			{
				var alreadystarted:Boolean=false;
					if(iEditPoint!=null) {
						(this.iEditPoint as AbstractEditHandler).map=this.map;
						iEditPoint.refreshEditedfeatures();
						alreadystarted=true;
					}
					if(iEditPath!=null){
						(this.iEditPath as AbstractEditHandler).map=this.map;
						if(!alreadystarted){
							iEditPath.refreshEditedfeatures();				
							alreadystarted=true;
						}
					}
					if(iEditPolygon!=null){
						(this.iEditPolygon as AbstractEditHandler).map=this.map;
						if(!alreadystarted){
							iEditPolygon.refreshEditedfeatures();
							alreadystarted=true;
						}
					}
			} 
			if(map!=null){
			this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_START,_layerToEdit));
			}
			return true;
		}
		/**
		 * Stop the edition Mode
		 * */
		protected function editionModeStop():Boolean{
			if(_layerToEdit !=null)
			{
				
					
				if(iEditPath!=null)(this.iEditPath as AbstractEditHandler).editionModeStop();
					
				else if(iEditPolygon!=null)(this.iEditPolygon as AbstractEditHandler).editionModeStop();
				
				else if(iEditPoint!=null) (this.iEditPoint as AbstractEditHandler).editionModeStop();

			}
			if(map!=null)
			{
				this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_END,_layerToEdit));
				
			}
			this._layerToEdit.removeFeature(EditCollectionHandler._pointUnderTheMouse);
			if(EditCollectionHandler._pointUnderTheMouse!=null){
				EditCollectionHandler._pointUnderTheMouse.destroy();
				EditCollectionHandler._pointUnderTheMouse=null;
			}
			return true;
		}
		
		/**
		 * This function create the point under the mouse
		 * */	
		 private function createPointUndertheMouse(evt:FeatureEvent):void{
		  	 var vectorfeature:Feature=(evt.feature) as Feature;
		  //The Vertice belongs to a polygon
					 if	((vectorfeature is PolygonFeature ||  vectorfeature is MultiPolygonFeature) && iEditPolygon!=null) (iEditPolygon as EditCollectionHandler).createPointUndertheMouse(evt);
				//The vertice belongs to a line
					else if((vectorfeature is LineStringFeature ||  vectorfeature is MultiLineStringFeature) && iEditPath!=null) (iEditPath as EditCollectionHandler).createPointUndertheMouse(evt);
		 }
		 
		private  function refreshEditedfeatures(event:MapEvent=null):void{
			if(_layerToEdit !=null)
			{		
				if(iEditPath!=null)iEditPath.refreshEditedfeatures(event);
					
				else if(iEditPolygon!=null)iEditPolygon.refreshEditedfeatures(event);
				
				else if(iEditPoint!=null) iEditPoint.refreshEditedfeatures(event);

			}
		}
		
		 /**
		 * @inherited
		 **/
		override protected function registerListeners():void {
			this.map.addEventListener(MapEvent.MOVE_END,refreshEditedfeatures);
			this.map.addEventListener(MapEvent.ZOOM_END,refreshEditedfeatures);
			this.map.addEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
		}
		 /**
		 * @inherited
		 * */
		override protected function unregisterListeners():void {
			this.map.removeEventListener(MapEvent.MOVE_END,refreshEditedfeatures);
			this.map.removeEventListener(MapEvent.ZOOM_END,refreshEditedfeatures);
			this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEMOVE,createPointUndertheMouse);
		}
		//getters && setters
		/**
		 * The layer concerned by the Modification
		 * */
		 public function get layerToEdit():FeatureLayer{
		 	return this._layerToEdit;
		 }
		 /**
		 * @private
		 * */
		 public function set layerToEdit(value:FeatureLayer):void{
		 	 if(value!=null){
		 	 	this._layerToEdit=value;
		 	 }
		 }
		 /**
		 *@inheritDoc 
		 * */
		 override public function set map(value:Map):void{
		 	if(value!=null){
		 		super.map=value;
		 		if(iEditPoint!=null)(this.iEditPoint as AbstractEditHandler).map=this.map;
		 		this._featureClickHandler.map=value;
		 		this.map.addChild(_drawContainer);
		 	}
		 }

		 /**
		 *@inheritDoc 
		 * */
		override public function set active(value:Boolean):void{
			
			if(!this.active && value && map!=null)
			{
				if(iEditPoint!=null)  (this.iEditPoint as AbstractEditHandler).active=value;
				if(iEditPath!=null)(this.iEditPath as AbstractEditHandler).active=value;	
				if(iEditPolygon!=null)(this.iEditPolygon as AbstractEditHandler).active=value;
				this._featureClickHandler.active=value;
				editionModeStart();
				
			}
			else if(this.active && !value && map!=null){
				if(iEditPoint!=null)  (this.iEditPoint as AbstractEditHandler).active=value;
				if(iEditPath!=null)(this.iEditPath as AbstractEditHandler).active=value;	
				if(iEditPolygon!=null)(this.iEditPolygon as AbstractEditHandler).active=value;
				this._featureClickHandler.active=value;
				editionModeStop();
			}
			super.active=value;
		}
	}
}