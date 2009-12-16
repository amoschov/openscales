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
	import org.openscales.core.handler.feature.draw.FeatureLayerEditionHandler;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.style.Style;
	
	public class AbstractRouting implements IRouting
	{
		/**
		 *@private 
		 **/
		private var _map:Map;
		/**
		 * @private
		 **/
		 private var _resultsLayer:FeatureLayer;
		 /**
		 * @private
		 **/
		 private var _key:String;
		 /**
		 * @private
		 **/
		 private var _host:String;
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
		 private var _endPointClass:Class;
		 /**
		 * This attribute is used to manage point under trhe mouse when you move on a itinerary
		 * @private
		 **/
		/*  private var _pointUnderTheMouse:PointFeature=null; */
		 /**
		 *Constructor
		 * @param map:Map Map Object
		 * @param resultsLayer:FeatureLayer The layer which contains the results of the request
		 * @param host:String The url of the server used for the routing
		 * @param key:String  The application key it could be null or not it depends on the application
		 **/
		public function AbstractRouting(map:Map=null,resultsLayer:FeatureLayer=null,host:String=null,key:String=null)
		{
			this.map=map;
			this.resultsLayer=resultsLayer;
			this._host=host;
			this._key=key;
			_intermedPoints=new Array();
			/* _pointUnderTheMouse=new PointFeature(null,null,Style.getDefaultCircleStyle()); */
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
					/* if(_startPoint) {
						resultsLayer.addFeature(_startPoint);
						linestring.addComponent(_startPoint);
					} */
					/* if(_endPoint){
						resultsLayer.addFeature(_endPoint);
						linestring.addComponent(_endPoint.geometry as Point);
					}  */
					if(i==0)
					{
						if(_startPoint){
							if(Util.indexOf(resultsLayer.features,_startPoint)==-1)resultsLayer.addFeature(_startPoint);
							if(!linestring)linestring=new LineString([_startPoint.geometry]);
							if(!((_startPoint.geometry as Point).equals(results[0] as Point))){	
								linestring.addComponent(results[i] as Point);				
								/*  linestring=new LineString([_startPoint.geometry as Point,results[i] as Point]);
								itineraryGeometry.addComponent(linestring); */
							}
						}
					}
					else{
						if(i!=results.length-1){
							linestring.addComponent(results[i] as Point);
							if(intermedPointTreat!=_intermedPoints.length){
								for(i=0;i<_intermedPoints.length;i++){
									var intermedPoint:PointFeature=_intermedPoints[i] as PointFeature;
									if(intermedPoint!=null && (intermedPoint.geometry as Point).equals(results[i] as Point)){
										intermedPointTreat++;
										if(Util.indexOf(this._resultsLayer.features,intermedPoint))this._resultsLayer.addFeature(intermedPoint);
									}
								}
							}
						}
						else{
							if(_endPoint){
								if(Util.indexOf(resultsLayer.features,_endPoint)==-1)resultsLayer.addFeature(_endPoint);								
								if(!((_endPoint.geometry as Point).equals(results[i] as Point))){
								/* linestring=new LineString([_endPoint.geometry as Point,results[i] as Point]);
								itineraryGeometry.addComponent(linestring); */
								linestring.addComponent(results[i] as Point);
							}
							linestring.addComponent(_endPoint.geometry as Point);
						}
						else linestring.addComponent(results[i] as Point);		
					}
						/*  linestring=new LineString([results[i-1] as Point,results[i] as Point]);
						itineraryGeometry.addComponent(linestring); */
					}	
				}
				itineraryGeometry.addComponent(linestring);
				/* _itinerary.geometry=itineraryGeometry; */
				  resultsLayer.removeFeature(_itinerary); 
				// _itinerary.removeEventListener(MouseEvent.MOUSE_MOVE,createPoint);
				_itinerary=new MultiLineStringFeature(itineraryGeometry,null,Style.getDefaultLineStyle()); 
				_itinerary.isEditable=true;
			//	_itinerary.addEventListener(MouseEvent.MOUSE_MOVE,createPoint);
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
		public function addPoint(px:Pixel):void{
			//we determine the point where the user clicked
			if(_resultsLayer!=null){
				var lonlat:LonLat = this.map.getLonLatFromLayerPx(px);
			/* 	var featureAdded:PointFeature=new PointFeature(new Point(lonlat.lon,lonlat.lat),Style.getDefaultPointStyle()); */
					var featureAdded:Marker=new Marker(new Point(lonlat.lon,lonlat.lat));
					featureAdded.isEditable=true;
				if(!_startPoint)
				{		
					_startPoint=featureAdded;
					_startPoint.image=_startPointclass;
				}
				else _intermedPoints.push(featureAdded);
			}
			refreshRouting();
		}
		/**
		 * Add or change the itinerary points
		 * */
		public function addfinalPoint(px:Pixel):void{
		/*	if(_resultsLayer!=null){
				if(event.target is Feature){
					if(Util.indexOf(_intermedPoints,event.target)!=-1) Util.removeItem(_intermedPoints,event.target);
					else if(_startPoint==event.target) _startPoint=null;
					else if (_endPoint==event.target)  _endPoint=null;
				}
				else{*/
					var lonlat:LonLat = this.map.getLonLatFromLayerPx(px);
					if(!_endPoint)
					{
						_endPoint=new Marker(new Point(lonlat.lon,lonlat.lat));
						_endPoint.image=_endPointClass;
						_endPoint.isEditable=true;
					}
					else _endPoint.geometry=new Point(lonlat.lon,lonlat.lat);
				//}
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
		 
		 public function  getIntermediaryPointByIndex(index:int):PointFeature{
		 	if(index>=0 && index<_intermedPoints.length) return  _intermedPoints[index] as PointFeature;
		 	return null;
		 }
		 /**
		 * Number of intermediary points
		 * @return iintermediary points array length
		 **/
		 public function intermediaryPointsNumber():Number{
		 	return _intermedPoints.length;
		 }
		 
		 public function editItinerary(event:FeatureEvent):void{
			if(event.feature is PointFeature){
		 		if(!(event.feature==_startPoint || Util.indexOf(_intermedPoints,event.feature)!=-1 || event.feature==_endPoint)){	 			
		 			_intermedPoints.push(event.feature);
		 	}
		 	refreshRouting();
		 	}
		 }
	
		//getters && setters
		/**
		 *The url of the routing server 
		 **/
		public function get host():String{
			return this._host;
		}
		/**
		 * @private
		 **/
		public function set host(value:String):void{
			this._host=value;
		}
		/**
		 *Map object 
		 **/
		public function get map():Map{
			return this._map;
		}
		/**
		 * @private
		 * */
		public function set map(value:Map):void{
			if(value!=null && value!=_map){
				this._map = value;
				if(!_click) _click=new ClickHandler(null,true);
				_click.map=_map;
				_click.click=addPoint;
				_click.doubleClick=addfinalPoint;
				_map.addHandler(_click);
				_map.addEventListener(FeatureEvent.EDITION_POINT_FEATURE_DRAG_STOP,editItinerary);
			}
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
//				_itinerary.addEventListener(MouseEvent.MOUSE_MOVE,createPoint);
				resultsLayer.addFeature(_itinerary);
				if(!_featureLayerEdition) _featureLayerEdition=new FeatureLayerEditionHandler(map,resultsLayer,true,true,true,false); 
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
	}
}