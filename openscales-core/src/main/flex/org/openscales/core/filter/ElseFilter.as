package org.openscales.core.filter {
	import org.openscales.core.feature.Feature;

	public class ElseFilter implements IFilter
	{
		public function ElseFilter() {
		}

		public function matches(feature:Feature):Boolean {
			return true;
		}
	}
}