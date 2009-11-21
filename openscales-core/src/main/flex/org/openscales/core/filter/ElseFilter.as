package org.openscales.core.filter {
	import org.openscales.core.feature.VectorFeature;

	public class ElseFilter implements IFilter
	{
		public function ElseFilter() {
		}

		public function matches(feature:VectorFeature):Boolean {
			return true;
		}
	}
}