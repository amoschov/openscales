package org.openscales.core.handler.mouse
{
	import org.openscales.core.Map;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.Polygon;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.handler.sketch.AbstractEditHandler;
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
		private var _layerToEdit:VectorLayer=null;
		
		private var iEditPoint:IEditVectorFeature=null; 
		private var iEditPath:IEditVectorFeature=null;
		private var iEditPolygon:IEditVectorFeature=null;
		private var _featureclickhandler:FeatureClickHandler=null;
		
		
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
			if(editPoint)iEditPoint=new EditPointHandler(map,active,layer);
			if(editPath)iEditPath=new EditPathHandler(map,active,layer);
			if(editPolygon)iEditPolygon=new EditPolygonHandler(map,active,layer);
			super(map,active);
		}
		
		private function dragVerticeStart(event:FeatureEvent):void{
			
			var vectorfeature:PointFeature=(event.feature) as PointFeature;
			if(vectorfeature!=null){
				
				//real point feature
				if(vectorfeature.editionFeatureParentGeometry==null && iEditPoint!=null) iEditPoint.dragVerticeStart(event);
				//The vertice belongs to a line
				else if(vectorfeature.editionFeatureParentGeometry is LineString && iEditPath!=null) iEditPath.dragVerticeStart(event);
				//The Vertice belongs to a polygon
				else if	(vectorfeature.editionFeatureParentGeometry is Polygon && iEditPolygon!=null) iEditPolygon.dragVerticeStart(event);
				
				
			}
		 
		 }
		 private function dragVerticeStop(event:FeatureEvent):void{
		 	var vectorfeature:PointFeature=(event.feature) as PointFeature;
			if(vectorfeature!=null){
					var featureParent:VectorFeature=vectorfeature.editionFeatureParent;
					///real point feature
					if(vectorfeature.editionFeatureParentGeometry==null && iEditPoint!=null) iEditPoint.dragVerticeStop(event);
					//The vertice belongs to a line
					else if(vectorfeature.editionFeatureParentGeometry is LineString && iEditPath!=null) iEditPath.dragVerticeStop(event);
					//The Vertice belongs to a polygon
					else if	(vectorfeature.editionFeatureParentGeometry is Polygon && iEditPolygon!=null) iEditPolygon.dragVerticeStop(event);
					
					if(featureParent!=null){			
		 			//Vertices update
		 			this._layerToEdit.removeFeatures(featureParent.editionFeaturesArray);
		 			featureParent.RefreshEditionVertices();
		 			this._layerToEdit.addFeatures(featureParent.editionFeaturesArray);
		 			this._featureclickhandler.addControledFeatures(featureParent.editionFeaturesArray);
		 			
					}
				this._layerToEdit.redraw();
				}
			}
		 private function featureClick(event:FeatureEvent):void{
		 	var vectorfeature:PointFeature=(event.feature) as PointFeature;
			if(vectorfeature!=null){
					///real point feature
					if(vectorfeature.editionFeatureParentGeometry==null && iEditPoint!=null) iEditPoint.featureClick(event);
					//The vertice belongs to a line
					else if(vectorfeature.editionFeatureParentGeometry is LineString && iEditPath!=null) iEditPath.featureClick(event);
					//The Vertice belongs to a polygon
					else if	(vectorfeature.editionFeatureParentGeometry is Polygon && iEditPolygon!=null) iEditPolygon.featureClick(event);
				}	 
		 }
		 private function featureDoubleClick(event:FeatureEvent):void{
		 var vectorfeature:PointFeature=(event.feature) as PointFeature;
			if(vectorfeature!=null){
				var featureParent:VectorFeature=vectorfeature.editionFeatureParent;
				///real point feature
				if(vectorfeature.editionFeatureParentGeometry==null && iEditPoint!=null) iEditPoint.featureDoubleClick(event);
				//The vertice belongs to a line
					else if(vectorfeature.editionFeatureParentGeometry is LineString && iEditPath!=null) iEditPath.featureDoubleClick(event);
					//The Vertice belongs to a polygon
					else if	(vectorfeature.editionFeatureParentGeometry is Polygon && iEditPolygon!=null) iEditPolygon.featureDoubleClick(event);
					if(featureParent!=null){			
		 			//Vertices update
		 			this._layerToEdit.removeFeatures(featureParent.editionFeaturesArray);
		 			featureParent.RefreshEditionVertices();
		 			this._layerToEdit.addFeatures(featureParent.editionFeaturesArray);
		 			this._featureclickhandler.addControledFeatures(featureParent.editionFeaturesArray);
					}
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
			return true;
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
		 	 this._layerToEdit=value;
		 }
		 
		 override public function set map(value:Map):void{
		 	if(value!=null){
		 		super.map=value;
		 		if(iEditPoint!=null)(this.iEditPoint as AbstractEditHandler).map=this.map;
		 		this._featureclickhandler.map=value;
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