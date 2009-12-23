package org.openscales.core.routing
{
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.Marker;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.geometry.LineString;
	import org.openscales.core.geometry.MultiLineString;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.handler.feature.draw.FeatureLayerEditionHandler;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.style.Style;
	
	public class AbstractRouting extends Handler implements IRouting 
	{
		/**
		 * @private
		 **/
		 private var _resultsLayer:FeatureLayer;
		 /**
		 * @private
		 **/
		 private var _startPoint:Marker=null;
		 /**
		 * @private 
		 * */
		 private var _endPoint:Marker=null;
		 /**
		 * @private
		 * */
		 private var _intermedPoints:Array=null;
		 /**
		 * @private
		 * */
		 private var _click:ClickHandler;
		 /**
		 * @private
		 * */
		 private var _featureLayerEdition:FeatureLayerEditionHandler;
		 /**
		 * @private 
		 **/
		 protected var _itinerary:MultiLineStringFeature=new MultiLineStringFeature(new MultiLineString(),null,Style.getDefaultLineStyle());
		 /**
		 * @private
		 * */
		 [Embed(source="/assets/images/marker-green.png")]
		 private var _startPointclass:Class;
		  /**
		 * @private
		 * */
		 [Embed(source="/assets/images/marker-gold.png")]
		 private var _intermedPointClass:Class;
		 /**
		 * @private
		 * */
		 [Embed(source="/assets/images/marker.png")]
		 private var _endPointClass:Class;
		 
		 /**
		 *@private 
		 **/
		 private var _forceStartPointDrawing:Boolean=false; 
		 
		 /**
		 *Constructor
		 * @param map:Map Map Object
		 * @param resultsLayer:FeatureLayer The layer which contains the results of the request
		 * @param host:String The url of the server used for the routing
		 * @param key:String  The application key it could be null or not it depends on the application
		 **/
		public function AbstractRouting(map:Map=null,active:Boolean=false,resultsLayer:FeatureLayer=null)
		{
			super(map,active);
			this.resultsLayer=resultsLayer;
			_intermedPoints=new Array();
			
		}
		
		/**
		 * This function displays the request's results on the concerned layer
		 * @param:results itinerary points array
		 **/
		protected function displayResult(results:Array):void{
			if(results!=null){	
				var itineraryGeometry:MultiLineString=new MultiLineString();
				//This variable is used to know how much intermedPoints have been treat
				//in order to don't scan intermediary point table again and again
				var intermedPointTreat:Number=0;
				var linestring:LineString;
				for(var i:int=0;i<results.length;i++){				

					if(i==0)
					{
						if(_startPoint){
							//We work on the starting point 
							if(Util.indexOf(resultsLayer.features,_startPoint)==-1)resultsLayer.addFeature(_startPoint);
							if(!linestring)linestring=new LineString([_startPoint.geometry]);
							//if the first point is not the starting point
							if(!((_startPoint.geometry as Point).equals(results[0] as Point))){	
								linestring.addComponent(results[i] as Point);				
							}
						}
					}
					else{
						if(i!=results.length-1){
							linestring.addComponent(results[i] as Point);
						}
						else{
							if(_endPoint){
								//like in the starting point treatment
								if(Util.indexOf(resultsLayer.features,_endPoint)==-1)resultsLayer.addFeature(_endPoint);								
								if(!((_endPoint.geometry as Point).equals(results[i] as Point))){
								linestring.addComponent(results[i] as Point);
							}
							linestring.addComponent(_endPoint.geometry as Point);
						}
						else linestring.addComponent(results[i] as Point);		
					}
					}
					//intermediary marker treatment
					if(intermedPointTreat!=_intermedPoints.length){
								for(var j:int=0;j<_intermedPoints.length;j++){
									var intermedPoint:PointFeature=_intermedPoints[j] as PointFeature;
									if(intermedPoint!=null && (intermedPoint.geometry as Point).equals(results[i] as Point)){
										intermedPointTreat++;
										if(Util.indexOf(this._resultsLayer.features,intermedPoint))this._resultsLayer.addFeature(intermedPoint);
									}
								}
							}	
				}
				itineraryGeometry.addComponent(linestring);
				resultsLayer.removeFeature(_itinerary); 
				_itinerary=new MultiLineStringFeature(itineraryGeometry,null,Style.getDefaultLineStyle()); 
				_itinerary.isEditable=true;
				resultsLayer.addFeature(_itinerary);
				resultsLayer.redraw();
				_featureLayerEdition.refreshEditedfeatures();
			}	
			
		}
		/**
		 * for refreshing the itinerary
		 * */
		public function refreshRouting():void{
			sendRequest();
		}
		public function sendRequest():void{
		}
		/**
		 * Add the itinerary points
		 * */
		private function addPoint(px:Pixel):void{
			//we determine the point where the user clicked
			if(_resultsLayer!=null){
				var lonlat:LonLat = this.map.getLonLatFromLayerPx(px);
				var featureAdded:Marker=new Marker(new Point(lonlat.lon,lonlat.lat));
				featureAdded.isEditable=true;
				if(!_startPoint || _forceStartPointDrawing)
				{	
					if(_startPoint) resultsLayer.removeFeature(_startPoint);	
					_startPoint=featureAdded;
					_startPoint.image=_startPointclass;
				}
				else {
					_intermedPoints.push(featureAdded);
					featureAdded.image=_intermedPointClass;
				}
			}
			refreshRouting();
		}
		/**
		 * Add the final point at pixel position or  delete a point 
		 * which is at this position(not treated yet)
		 * @param px: The points coordinates
		 * */
		private function addfinalPoint(px:Pixel):void{
			var lonlat:LonLat = this.map.getLonLatFromLayerPx(px);
			if(!_endPoint)
			{
				_endPoint=new Marker(new Point(lonlat.lon,lonlat.lat));
				_endPoint.image=_endPointClass;
				_endPoint.isEditable=true;
			}
			else _endPoint.geometry=new Point(lonlat.lon,lonlat.lat);
			refreshRouting();
		}
		/**
		 * To add an intermediary point to the itinerary
		 * @param intermedPoint:PointFeature the point to add
		 * */
		public function addIntermediaryPoint(intermedPoint:PointFeature):void{
			if(Util.indexOf(_intermedPoints,intermedPoint)==-1) _intermedPoints.push(intermedPoint);
		}
		/**
		 * To add an array of intermediaries point to the itinerary
		 * @param intermedPointArray:Array the array to add
		 * */
		 public function addIntermediaryPoints(intermedPointsArray:Array):void{
		 	for each(var intermedPoint:PointFeature in intermedPointsArray){
		 		if(Util.indexOf(_intermedPoints,intermedPoint)==-1) _intermedPoints.push(intermedPoint);
		 	}
		 	refreshRouting();
		 }
		 /**
		 * To remove an intermediary point from the itinerary
	     * @param intermedPoint:PointFeature the point to remove
		 * */
		 public function removeIntermediaryPoint(intermedPoint:PointFeature):void{
		 	Util.removeItem(_intermedPoints,intermedPoint);
		 	refreshRouting();
		 }
		 /**
		 * To remove an array of intermediary point from the itinerary
	     * @param intermedPoint:PointFeature the array to remove
		 * */
		  public function removeIntermediaryPoints(intermedPointsArray:Array):void{
		 	for each(var intermedPoint:PointFeature in intermedPointsArray){
		 		Util.removeItem(_intermedPoints,intermedPoint);
		 	}
		 	refreshRouting();
		 }
		 
		 public function  getIntermediaryPointByIndex(index:int):Marker{
		 	if(index>=0 && index<_intermedPoints.length) return  _intermedPoints[index] as Marker;
		 	return null;
		 }
		 /**
		 * Number of intermediary points
		 * @return intermediary points array length
		 **/
		 public function intermediaryPointsNumber():Number{
		 	return _intermedPoints.length;
		 }
		 
		 public function editItinerary(event:FeatureEvent):void{
			if(event.feature is PointFeature){
		 		if(!(event.feature==_startPoint || Util.indexOf(_intermedPoints,event.feature)!=-1 || event.feature==_endPoint)){	 
		 			var intermedPoint:Marker=new Marker(event.feature.geometry as Point);
		 			intermedPoint.isEditable=true;		
		 			intermedPoint.image=_intermedPointClass;
		 			_intermedPoints.push(intermedPoint);
		 		}
		 		refreshRouting();
		 		}
		 }
		
		//getters && setters
		/**
		 * @inherited
		 * */
		override public function set map(value:Map):void{
			super.map=value;
			if(value!=null && map){
				if(!_click) _click=new ClickHandler(map,true);
				//Click callback functions
				_click.click=addPoint;
				_click.doubleClick=addfinalPoint;
				//featureLayerEdition
				if(!_featureLayerEdition) _featureLayerEdition=new FeatureLayerEditionHandler(map,resultsLayer,true,true,true,false); 
				if(!_featureLayerEdition.map)_featureLayerEdition.map=map;
				map.addHandler(_featureLayerEdition);
				map.addHandler(_click);
				_click.active=this.active;
				map.addEventListener(FeatureEvent.EDITION_POINT_FEATURE_DRAG_STOP,editItinerary);
			}
			
		}
		/**
		 * @inherited
		 * */
		override public function set active(value:Boolean):void{
			super.active=value;
			if(_click!=null)_click.active=value;
			if(_featureLayerEdition!=null)_featureLayerEdition.active=value;
			
		}
		
		
		/**
		 * The layer which contains the results of the request
		 **/
		public function get resultsLayer():FeatureLayer{
			return this._resultsLayer;
		}
		/**
		 * @private
		 **/
		public function set resultsLayer(value:FeatureLayer):void{
			if(value!=_resultsLayer && value!=null){
				this._resultsLayer=value;
				resultsLayer.addFeature(_itinerary);
				if(!_featureLayerEdition) _featureLayerEdition=new FeatureLayerEditionHandler(map,resultsLayer,true,true,true,false); 
				_featureLayerEdition.active=this.active;
				_featureLayerEdition.displayedvirtualvertice=false;
			}
		}
		/**
		 * the routing start point 
		 * */
		 public function get startPoint():Marker{
		 	return this._startPoint;
		 }
		 /**
		 * @private
		 * */
		 public function set startPoint(value:Marker):void{
		 	if(value!=_startPoint){
		 		this._startPoint=value;
		 		this._startPoint.style=Style.getDefaultPointStyle();
		 		refreshRouting();
		 	}
		 }
		 /**
		 *The routing end point
		 **/
		 public function get endPoint():Marker{
		 	return this._endPoint;
		 }
		 /**
		 * @private
		 **/
		 public function set endPoint(value:Marker):void{
		 	if(value!=_endPoint){
		 		this._endPoint=value;
		 		refreshRouting();
		 	}	
		 }
		 /**
		 * This attribute forces the itinerary to add/change the location of start point by a click event
		 * or when you call the addPoint Function  
		 * */
		 public function get forceStartPoint():Boolean{
		 	return this._forceStartPointDrawing;
		 }
		 /**
		 * @private
		 * */
		 public function set forceStartPoint(value:Boolean):void{
		 	this._forceStartPointDrawing=value;
		 }	
		 /**
		 * Set the picture behind the start point
		 * */
		 public function set startPointclass(value:Class):void{
		 	if(value)_startPointclass=value;
		 }
		 
		 /**
		 * set the picture behind the stop point 
		 **/
		 public function set endPointClass(value:Class):void{
		 	if(value)_endPointClass=value;
		 }
		 /**
		 * set the  picture behind intermediary point 
		 * */
		 public function set intermedPointClass(value:Class):void{
		 	if(value)_intermedPointClass=value;
		 }
	}
}