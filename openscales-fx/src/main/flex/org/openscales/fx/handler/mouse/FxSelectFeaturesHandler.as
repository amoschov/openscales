package org.openscales.fx.handler.mouse
{
	import org.openscales.core.handler.feature.select.SelectFeaturesHandler;

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