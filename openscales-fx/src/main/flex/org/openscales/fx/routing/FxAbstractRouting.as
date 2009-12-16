package org.openscales.fx.routing
{
	import mx.core.UIComponent;
	
	import org.openscales.core.Map;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.routing.AbstractRouting;
	
	public class FxAbstractRouting extends UIComponent
	{
		protected var _routingHandler:AbstractRouting;
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
			if(_routingHandler) return _routingHandler.map;
			return null;
		}
		/**
		 * @private
		 * */
		public function set map(value:Map):void{
			if(_routingHandler) _routingHandler.map=value;
		}

		 /**
		 * Control activation
		 * */
		public function get active():Boolean{
			if(_routingHandler) return _routingHandler.active;
			return false;
		}
		 
		 public function set active(value:Boolean):void{
			if(_routingHandler)  _routingHandler.active=value;
			
		}
		
		
		
		/**
		 * The layer which contains the results of the request
		 **/
		public function get resultsLayer():FeatureLayer{
		if(_routingHandler) return _routingHandler.resultsLayer;
		return null;
		}
		/**
		 * @private
		 **/
		public function set resultsLayer(value:FeatureLayer):void{
			if(_routingHandler) _routingHandler.resultsLayer=value;
			
		}
	}
}