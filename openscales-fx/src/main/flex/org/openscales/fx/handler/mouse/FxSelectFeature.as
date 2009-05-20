package org.openscales.fx.handler.mouse
{
	import org.openscales.core.Map;
	import org.openscales.core.handler.mouse.SelectFeature;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.fx.handler.FxHandler;
	
	public class FxSelectFeature extends FxHandler
	{
		public function FxSelectFeature() 
		{
			this.handler=new SelectFeature();
			super();
		}
		
		public function set map(map:Map):void
		{
			if(map!=null) (this.handler as SelectFeature).map=map;
		}
		public function get map():Map{
			return (this.handler as SelectFeature).map;
		}
		
		public function get target():VectorLayer{
			return (this.handler as SelectFeature).layer;
		}
		public function set target(target:VectorLayer):void
		{
			if(target!=null)  (this.handler as SelectFeature).layer=target;	
		}
		
		
		public function set select(select:Function):void
		{
			if(select!=null) (this.handler as SelectFeature).select=select;

		}
		public function get select():Function
		{
			return (this.handler as SelectFeature).select;
		}
		
		public function set unselect(unselect:Function):void
		{
			if(unselect!=null) (this.handler as SelectFeature).unselect=unselect;

		}
		public function get unselect():Function
		{
			return (this.handler as SelectFeature).unselect;
		}
		
	}
}