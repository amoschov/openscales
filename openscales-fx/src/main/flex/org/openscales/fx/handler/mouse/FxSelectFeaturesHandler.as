package org.openscales.fx.handler.mouse
{
	import org.openscales.core.handler.feature.SelectFeaturesHandler;
	import org.openscales.fx.handler.mouse.FxClickHandler;

	public class FxSelectFeaturesHandler extends FxClickHandler
	{
		/**
		 * Constructor of the handler component
		 */
		public function FxSelectFeaturesHandler() {
			super();
			this.handler = new SelectFeaturesHandler();
		}
		
	}
}