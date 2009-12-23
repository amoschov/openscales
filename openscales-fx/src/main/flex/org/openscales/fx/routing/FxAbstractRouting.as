package org.openscales.fx.routing
{
	import mx.core.UIComponent;
	
	import org.openscales.core.Map;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.routing.AbstractRouting;
	import org.openscales.core.routing.IRouting;
	
	public class FxAbstractRouting extends UIComponent
	{
		protected var _routingHandler:IRouting;
		public function FxAbstractRouting(map:Map=null,active:Boolean=true,resultsLayer:FeatureLayer=null) 
		{
			if(_routingHandler!=null){
				this.map=map;
				this.active=active;
				this.resultsLayer=resultsLayer;
			}
		}
		/**
		 * The Map object
		 * */
		public function get map():Map{
			if(_routingHandler ) return (_routingHandler as AbstractRouting).map;
			return null;
		}
		/**
		 * @private
		 * */
		public function set map(value:Map):void{
			if(_routingHandler) (_routingHandler as AbstractRouting).map=value;
		}

		 /**
		 * Control activation
		 * */
		public function get active():Boolean{
			if(_routingHandler as AbstractRouting) return (_routingHandler as AbstractRouting).active;
			return false;
		}
		 
		 public function set active(value:Boolean):void{
			if(_routingHandler ) (_routingHandler as AbstractRouting).active=value;
			
		}
		
		
		
		/**
		 * The layer which contains the results of the request
		 **/
		public function get resultsLayer():FeatureLayer{
		if(_routingHandler) return (_routingHandler as AbstractRouting).resultsLayer;
		return null;
		}
		/**
		 * @private
		 **/
		public function set resultsLayer(value:FeatureLayer):void{
			if(_routingHandler) (_routingHandler as AbstractRouting).resultsLayer=value;
			
		}
		 /**
		 * This attribute forces the itinerary to add/change the location of start point 
		 * */
		 public function  get forceStartPoint():Boolean{
		 	if(_routingHandler) return (_routingHandler as AbstractRouting).forceStartPoint;
		 	return false;
		 }
		  /**
		 * @private
		 * */
		public function set forceStartPoint(value:Boolean):void{
			if(_routingHandler)(_routingHandler as AbstractRouting).forceStartPoint=value;
		}
		
		/**
		 * Set the picture behind the start point
		 * */
		 public function set startPointClass(value:Class):void{
		 	if(_routingHandler) (_routingHandler as AbstractRouting).startPointclass=value;
		 }
		 
		 /**
		 * set the picture behind the stop point 
		 **/
		 public function set endPointClass(value:Class):void{
		 	if(_routingHandler) (_routingHandler as AbstractRouting).endPointClass=value;
		 }
		 /**
		 * set the  picture behind intermediary point 
		 * */
		 public function set intermedPointClass(value:Class):void{
		 	if(_routingHandler) (_routingHandler as AbstractRouting).intermedPointClass=value;
		 }
		 
	}
}