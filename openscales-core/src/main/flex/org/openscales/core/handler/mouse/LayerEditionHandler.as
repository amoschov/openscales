package org.openscales.core.handler.mouse
{
	import flash.display.Sprite;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.MultiPolygonFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.handler.sketch.AbstractEditHandler;
	import org.openscales.core.handler.sketch.EditCollectionHandler;
	import org.openscales.core.handler.sketch.EditPathHandler;
	import org.openscales.core.handler.sketch.EditPointHandler;
	import org.openscales.core.handler.sketch.EditPolygonHandler;
	import org.openscales.core.handler.sketch.IEditVectorFeature;
	import org.openscales.core.layer.VectorLayer;
	
	public class LayerEditionHandler extends Handler
	{
		/**
		 *Layer to edit
		 * @private 
		 **/
		protected var _layerToEdit:VectorLayer=null;
		
		private var iEditPoint:IEditVectorFeature=null; 
		private var iEditPath:IEditVectorFeature=null;
		private var iEditPolygon:IEditVectorFeature=null;
		
		private var _featureclickhandler:FeatureClickHandler=null;
		
		private var _drawContainer:Sprite=new Sprite();
		
		/**
		 * Handler of edition mode 
		 * @param editPoint to know if the edition of point is allowed
		 * @param editPath to know if the edition of path is allowed
		 * @param editPolygon to know if the edition of polygon is allowed
		 * */
		public function LayerEditionHandler(map:Map = null,layer:VectorLayer=null,active:Boolean = false,editPoint:Boolean=true,editPath:Boolean=true,editPolygon:Boolean=true)
		{
			//Handler click Management
			
			this._featureclickhandler=new FeatureClickHandler(map,active);
			this._featureclickhandler.click=featureClick;
			this._featureclickhandler.doubleclick=featureDoubleClick;
			this._featureclickhandler.startDrag=dragVerticeStart;
			this._featureclickhandler.stopDrag=dragVerticeStop;
			
			
			
			this._layerToEdit=layer;
			if(editPoint)iEditPoint=new EditPointHandler(map,active,layer,null,_drawContainer);
			if(editPath){
				iEditPath=new EditPathHandler(map,active,layer,null,_drawContainer);
			}
			if(editPolygon)iEditPolygon=new EditPolygonHandler(map,active,layer,null,_drawContainer);
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
				 if	((vectorfeature.editionFeatureParent is PolygonFeature || vectorfeature.editionFeatureParent is MultiPolygonFeature )&& iEditPolygon!=null) iEditPolygon.dragVerticeStart(event);
				//The vertice belongs to a line
				else if((vectorfeature.editionFeatureParent is LineStringFeature ||  vectorfeature.editionFeatureParent is MultiLineStringFeature)&& iEditPath!=null) iEditPath.dragVerticeStart(event);
		
				else if(iEditPoint!=null) iEditPoint.dragVerticeStart(event);
				this.map.removeEventListener(FeatureEvent.FEATURE_OVER,createPointUndertheMouse);
				
				
			}
		 }
		 /**
		 * 
		 * drag vertice stop function
		 * */
		 private function dragVerticeStop(event:FeatureEvent):void{
		 	var vectorfeature:PointFeature=(event.feature) as PointFeature;
			if(vectorfeature!=null){
					var featureParent:VectorFeature=vectorfeature.editionFeatureParent;
					///real point feature
					if(vectorfeature.editionFeatureParentGeometry==null && iEditPoint!=null){
						var newfeature:VectorFeature=iEditPoint.dragVerticeStop(event);
					    this._featureclickhandler.addControledFeature(newfeature);
					} 
					//The Vertice belongs to a polygon
					else if	((vectorfeature.editionFeatureParent is PolygonFeature || vectorfeature.editionFeatureParent is MultiPolygonFeature ) && iEditPolygon!=null) iEditPolygon.dragVerticeStop(event);
					
					//The vertice belongs to a line
					else if((vectorfeature.editionFeatureParent is LineStringFeature ||  vectorfeature.editionFeatureParent is MultiLineStringFeature) && iEditPath!=null) iEditPath.dragVerticeStop(event);
					
					
					if(featureParent!=null){			
		 			//Vertices update
		 			this._layerToEdit.removeFeatures(featureParent.editionFeaturesArray);
		 			this._featureclickhandler.removeControledFeatures(featureParent.editionFeaturesArray);
		 			featureParent.RefreshEditionVertices();
		 			this._layerToEdit.addFeatures(featureParent.editionFeaturesArray);
		 			this._featureclickhandler.addControledFeatures(featureParent.editionFeaturesArray);
		 			
					}
				this.map.addEventListener(FeatureEvent.FEATURE_OVER,createPointUndertheMouse);
				this._layerToEdit.removeFeature(EditCollectionHandler._pointUnderTheMouse);
				EditCollectionHandler._pointUnderTheMouse=null;
				this._layerToEdit.redraw();
				
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
					this._layerToEdit.removeFeature(EditCollectionHandler._pointUnderTheMouse);
					
					
						//This is a bug we redraw the layer
						this._featureclickhandler.removeControledFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 				this._layerToEdit.removeFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);	
		 				vectorfeature.editionFeatureParent.RefreshEditionVertices();
		 				this._layerToEdit.addFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 				this._featureclickhandler.addControledFeatures(vectorfeature.editionFeatureParent.editionFeaturesArray);
		 				this.map.removeEventListener(FeatureEvent.FEATURE_OVER,createPointUndertheMouse);

					EditCollectionHandler._pointUnderTheMouse=null;
				}	 
		 }
		 /**
		 * feature double click
		 * */
		 private function featureDoubleClick(event:FeatureEvent):void{
		 var vectorfeature:PointFeature=(event.feature) as PointFeature;
			if(vectorfeature!=null){
				var featureParent:VectorFeature=vectorfeature.editionFeatureParent;
				///real point feature
				if(vectorfeature.editionFeatureParentGeometry==null && iEditPoint!=null) iEditPoint.featureDoubleClick(event);
				//The Vertice belongs to a polygon
					else if	((vectorfeature.editionFeatureParent is PolygonFeature || vectorfeature.editionFeatureParent is MultiPolygonFeature ) && iEditPolygon!=null) iEditPolygon.featureDoubleClick(event);
				//The vertice belongs to a line
					else if((vectorfeature.editionFeatureParent is LineStringFeature ||  vectorfeature.editionFeatureParent is MultiLineStringFeature) && iEditPath!=null) iEditPath.featureDoubleClick(event);
					
					
					if(featureParent!=null){			
		 			//Vertices update
		 			this._layerToEdit.removeFeatures(featureParent.editionFeaturesArray);
		 			this._featureclickhandler.removeControledFeatures(featureParent.editionFeaturesArray);
		 			featureParent.RefreshEditionVertices();
		 			this._layerToEdit.addFeatures(featureParent.editionFeaturesArray);
		 			this._featureclickhandler.addControledFeatures(featureParent.editionFeaturesArray);
					}
					this.map.addEventListener(FeatureEvent.FEATURE_OVER,createPointUndertheMouse);
					this._layerToEdit.removeFeature(EditCollectionHandler._pointUnderTheMouse);
					EditCollectionHandler._pointUnderTheMouse=null;
					this._layerToEdit.redraw();		
			}
		 
		 }
		
		
		//Edition Mode Start
		protected function EditionModeStart():Boolean{
			if(_layerToEdit !=null)
			{
					if(iEditPoint!=null) {
						(this.iEditPoint as AbstractEditHandler).map=this.map;
						iEditPoint.editionModeStart();
					}
					if(iEditPath!=null){
						(this.iEditPath as AbstractEditHandler).map=this.map;
						iEditPath.editionModeStart();
					}
					if(iEditPolygon!=null){
						(this.iEditPolygon as AbstractEditHandler).map=this.map;
						iEditPolygon.editionModeStart();
					}
					//We had point and virtual vertice
				for each(var vectorfeature:VectorFeature in _layerToEdit.features){
					if(vectorfeature is PointFeature /*&& vectorfeature.isEditionFeature*/){
						this._featureclickhandler.addControledFeature(vectorfeature);
					}
				}
			}
			if(map!=null){
			this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_START,_layerToEdit));
			this.map.addEventListener(FeatureEvent.FEATURE_OVER,createPointUndertheMouse);
			}
			return true;
		}
		//Edition Mode Stop
		protected function EditionModeStop():Boolean{
			if(_layerToEdit !=null)
			{
				for each(var vectorfeature:VectorFeature in _layerToEdit.features){
					if(vectorfeature.isEditionFeature){
						this._featureclickhandler.removeControledFeature(vectorfeature);
						this._layerToEdit.removeFeature(vectorfeature);
					}
				}
				if(iEditPoint!=null) (this.iEditPoint as AbstractEditHandler).editionModeStop();
					
				if(iEditPath!=null)(this.iEditPath as AbstractEditHandler).editionModeStop();
					
				if(iEditPolygon!=null)(this.iEditPolygon as AbstractEditHandler).editionModeStop();

			}
			if(map!=null)
			{
				this.map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_EDITION_MODE_END,_layerToEdit));
				this.map.removeEventListener(FeatureEvent.FEATURE_OVER,createPointUndertheMouse);
			}
			this._layerToEdit.removeFeature(EditCollectionHandler._pointUnderTheMouse);
			EditCollectionHandler._pointUnderTheMouse=null; 
			return true;
		}
		
		/**
		 * This function create the point under the mouse
		 * */	
		 private function createPointUndertheMouse(evt:FeatureEvent):void{
		  	 var vectorfeature:VectorFeature=(evt.feature) as VectorFeature;
		  //The Vertice belongs to a polygon
					 if	((vectorfeature is PolygonFeature ||  vectorfeature is MultiPolygonFeature) && iEditPolygon!=null) (iEditPolygon as EditCollectionHandler).createPointUndertheMouse(evt);
				//The vertice belongs to a line
					else if((vectorfeature is LineStringFeature ||  vectorfeature is MultiLineStringFeature) && iEditPath!=null) (iEditPath as EditCollectionHandler).createPointUndertheMouse(evt);
					if(EditCollectionHandler._pointUnderTheMouse!=null)this._featureclickhandler.addControledFeature(EditCollectionHandler._pointUnderTheMouse);
		 }
		
		//getters && setters
		/**
		 * The layer concerned by the Modification
		 * */
		 public function get layerToEdit():VectorLayer{
		 	return this._layerToEdit;
		 }
		 /**
		 * @private
		 * */
		 public function set layerToEdit(value:VectorLayer):void{
		 	 if(value!=null){
		 	 	this._layerToEdit=value;
		 	 }
		 }
		 
		 override public function set map(value:Map):void{
		 	if(value!=null){
		 		super.map=value;
		 		if(iEditPoint!=null)(this.iEditPoint as AbstractEditHandler).map=this.map;
		 		this._featureclickhandler.map=value;
		 		this.map.addChild(_drawContainer);
		 	}
		 }

		 
		override public function set active(value:Boolean):void{
			super.active=value;
			if(iEditPoint!=null)  (this.iEditPoint as AbstractEditHandler).active=value;
			this._featureclickhandler.active=active;
			if(value) EditionModeStart();
			else EditionModeStop();
		}
	}
}