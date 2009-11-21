package org.openscales.core.filter {
	import org.openscales.core.feature.VectorFeature;

	/**
	 * An interface for feature filters
	 */
	public interface IFilter {

		function matches(feature:VectorFeature):Boolean;
	}
}