package styleexample {
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.filter.IFilter;
	
	public class CentroidYFilter implements IFilter
	{
		private var min:Number = 0;
		private var max:Number = 0;
		
		public function CentroidYFilter(min:Number, max:Number) {
			this.min = min;
			this.max = max;
		}
		
		public function matches(feature:VectorFeature):Boolean {
			var centroidY:Number = parseFloat(feature.attributes["y_centroid"]);
			return (centroidY > min && centroidY <= max);
		}
		
	}
}