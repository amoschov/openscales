package org.openscales.fx.handler.feature
{
	import org.openscales.core.handler.feature.SelectFeaturesHandler;
	import org.openscales.fx.handler.FxHandler;

	public class FxSelectFeaturesHandler extends FxHandler
	{
		/**
		 * Constructor of the handler component
		 */
		public function FxSelectFeaturesHandler() {
			super();
			this.handler = new SelectFeaturesHandler();
		}
		
		public function set enableClickSelection(value:Boolean):void {
			(this.handler as SelectFeaturesHandler).enableClickSelection = value;
		}
		
		public function set enableBoxSelection(value:Boolean):void {
			(this.handler as SelectFeaturesHandler).enableBoxSelection = value;
		}
		
		public function set enableOverSelection(value:Boolean):void {
			(this.handler as SelectFeaturesHandler).enableOverSelection = value;
		}
		
	}
}