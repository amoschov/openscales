package org.openscales.core.handler.feature.select
{
	import org.openscales.core.Map;

	public class SelectFeatureByBBoxHandler extends AbtractSelectFeatureByGeometryHandler
	{
		public function SelectFeatureByBBoxHandler(map:Map=null, active:Boolean=false)
		{
			super(map, active);
		}
		
	}
}