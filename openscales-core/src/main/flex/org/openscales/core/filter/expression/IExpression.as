package org.openscales.core.filter.expression {
	import org.openscales.core.feature.Feature;

	public interface IExpression {

		function evaluate(feature:Feature):Object;
	}
}