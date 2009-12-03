package org.openscales.fx.handler.mouse
{
	import mx.events.FlexEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.handler.mouse.DragFeature;
	import org.openscales.fx.handler.FxHandler;

	public class FxDragFeature extends FxHandler
	{
		
		private var _onstart:Function;
		public function FxDragFeature()
		{
			this.handler=new DragFeature();
			super();
		}

		public function set map(map:Map):void
		{
			if(map!=null) (this.handler as DragFeature).map=map;
		}
		public function get map():Map{
			return (this.handler as DragFeature).map;
		}
		
		/* public function get target():Array{
			return (this.handler as DragFeature).layer;
		}
		public function set target(target:Array):void
		{
			if(target!=null)  (this.handler as DragFeature).layer=target;	
		} */
		
		public function set oncomplete(oncomplete:Function):void
		{
			if(oncomplete!=null) (this.handler as DragFeature).oncomplete=oncomplete;

		}
		public function get oncomplete():Function
		{
			return (this.handler as DragFeature).oncomplete;
		}
		
		public function set onstart(onstart:Function):void
		{
			if(onstart!=null) (this.handler as DragFeature).onstart=onstart;
		}
		
		public function get onstart():Function
		{
			return (this.handler as DragFeature).onstart;
		}
		
	}
}