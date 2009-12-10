package org.openscales.core.routing
{
	import org.openscales.core.Map;
	import org.openscales.core.Util;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.layer.FeatureLayer;
	
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
		 private var _startPoint:PointFeature=null;
		 /**
		 * @private 
		 * */
		 private var _endPoint:PointFeature=null;
		 /**
		 * @private
		 * */
		 private var _intermedPoints:Array=null;
		 /**
		 *Constructor
		 * @param map:Map Map Object
		 * @param resultsLayer:FeatureLayer The layer which contains the results of the request
		 * @param host:String The url of the server used for the routing
		 * @param key:String  The application key it could be null or not it depends on the application
		 **/
		public function AbstractRouting(map:Map=null,resultsLayer:FeatureLayer=null,host:String=null,key:String=null)
		{
			this._map=map;
			this._resultsLayer=resultsLayer;
			this._host=host;
			this._key=key;
			_intermedPoints=new Array();
		}
		
		/**
		 * This function displays the request's results on the concerned layer
		 * @param:
		 **/
		protected function displayResult():void{
			
		}
		/**
		 * for refreshing the itinerary
		 * */
		public function refreshRouting():void{
			
		}
		public function sendRequest():void{

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
		 		addIntermediaryPoint(intermedPoint);
		 	}
		 }
		 /**
		 * To remove an intermediary point from the itinerary
	     * @param intermedPoint:PointFeature the point to remove
		 * */
		 public function removeIntermediaryPoint(intermedPoint:PointFeature):void{
		 	Util.removeItem(_intermedPoints,intermedPoint);
		 }
		 /**
		 * To remove an array of intermediary point from the itinerary
	     * @param intermedPoint:PointFeature the array to remove
		 * */
		  public function removeIntermediaryPoints(intermedPointsArray:Array):void{
		 	for each(var intermedPoint:PointFeature in intermedPointsArray){
		 		removeIntermediaryPoint(intermedPoint);
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
		 **/
		public function set map(value:Map):void{
			this._map=value;
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
			this._resultsLayer=value;
		}
		/**
		 * the routing start point 
		 * */
		 public function get startPoint():PointFeature{
		 	return this._startPoint;
		 }
		 /**
		 * @private
		 * */
		 public function set startPoint(value:PointFeature):void{
		 	this._startPoint=value;
		 }
		 /**
		 *The routing end point
		 **/
		 public function get endPoint():PointFeature{
		 	return this._endPoint;
		 }
		 /**
		 * @private
		 **/
		 public function set endPoint(value:PointFeature):void{
		 	this._endPoint=value;
		 }
	}
}