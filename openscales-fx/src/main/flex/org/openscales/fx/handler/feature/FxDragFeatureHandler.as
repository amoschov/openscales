package org.openscales.fx.handler.feature
{
	import mx.events.FlexEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.handler.feature.DragFeatureHandler;
	import org.openscales.fx.handler.FxHandler;

	public class FxDragFeatureHandler extends FxHandler
	{
		
		private var _onstart:Function;
		
		public function FxDragFeatureHandler()
		{
			this.handler=new DragFeatureHandler();
			super();
		}

		public function set map(map:Map):void
		{
			if(map!=null) (this.handler as DragFeatureHandler).map=map;
		}
		public function get map():Map{
			return (this.handler as DragFeatureHandler).map;
		}
		
		public function set oncomplete(oncomplete:Function):void
		{
			if(oncomplete!=null) (this.handler as DragFeatureHandler).oncomplete=oncomplete;

		}
		public function get oncomplete():Function
		{
			return (this.handler as DragFeatureHandler).oncomplete;
		}
		
		public function set onstart(onstart:Function):void
		{
			if(onstart!=null) (this.handler as DragFeatureHandler).onstart=onstart;
		}
		
		public function get onstart():Function
		{
			return (this.handler as DragFeatureHandler).onstart;
		}
		
	}
}