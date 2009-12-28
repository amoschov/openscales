package statisticsexample {
	import org.openscales.core.feature.Feature;
	import org.openscales.core.filter.expression.IExpression;

	public class CircleSizeExpression implements IExpression {

		private var _minSize:Number;
		private var _sizeDelta:Number;
		private var _minValue:Number;
		private var _delta:Number;

		public function CircleSizeExpression(minSize:Number, maxSize:Number, minValue:Number, maxValue:Number) {

			this._minSize = minSize;
			this._sizeDelta = maxSize - minSize;
			this._minValue = minValue;
			this._delta = maxValue - minValue;
		}

		public function evaluate(feature:Feature):Object {

			var pop = parseFloat(feature.attributes['pop_f']) + parseFloat(feature.attributes['pop_m']);
			var epsilon = pop - this._minValue;
			return this._minSize + this._sizeDelta * epsilon / this._delta;
		}
	}
}