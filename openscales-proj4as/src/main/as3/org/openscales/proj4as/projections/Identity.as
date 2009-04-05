package org.openscales.proj4as.projections
{
	import org.openscales.commons.geometry.Point;
	import org.openscales.proj4as.Projection;

	/**
	 * Identity projection for testing purpose
	 */
	public class Identity implements Projection
	{
		
		private var PROJECTION_NAME:String = "identity";
		
		public function Identity()
		{
		}

		public function get name():String
		{
			return this.PROJECTION_NAME;
		}
		
		public function get names():Array
		{
			return [this.PROJECTION_NAME];
		}
		
		public function get code():String
		{
			return "";
		}
		
		public function get units():String
		{
			return "";
		}
		
		public function forward(point:Point):Point
		{
			return point;
		}
		
		public function inverse(point:Point):Point
		{
			return point;
		}
		
	}
}