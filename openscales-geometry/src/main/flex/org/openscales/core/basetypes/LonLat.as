package org.openscales.core.basetypes
{
	import org.openscales.proj4as.Proj4as;
	import org.openscales.proj4as.ProjPoint;
	import org.openscales.proj4as.ProjProjection;

	/**
	 * This class represents a longitude and latitude pair.
	 */
	public class LonLat
	{

		private var _lon:Number = 0.0;
		private var _lat:Number = 0.0;

		public function LonLat(lon:Number = NaN, lat:Number = NaN) {
			this.lon = lon;
			this.lat = lat;
		}

		public function toString():String {
			return "lon=" + this.lon + ",lat=" + this.lat;
		}

		public function toShortString():String {
			return this.lon + ", " + this.lat;
		}
		
		/**
		 * Reprojection method => this method will convert the lonlat from source projection to dest projection.
		 *
		 * @param source Source projection
		 * @param dest Destination projection
		 */
		public function transform(source:ProjProjection, dest:ProjProjection):void {
			var p:ProjPoint = new ProjPoint(this.lon, this.lat);
			Proj4as.transform(source, dest, p);
			this.lon = p.x;
			this.lat = p.y;
		}

		public function clone():LonLat {
			return new LonLat(this.lon, this.lat);
		}

		public function add(lon:Number, lat:Number):LonLat {
			return new LonLat(this.lon + lon, this.lat + lat);
		}

		public function equals(ll:LonLat):Boolean {
			var equals:Boolean = false;
			if (ll != null) {
				equals = this.lon == ll.lon && this.lat == ll.lat;
			}
			return equals;
		}

		public function fromString(str:String):LonLat {
			var pair:Array = str.split(",");
			return new LonLat(Number(pair[0]), Number(pair[1]));
		}

		// Getters & setters

		public function get lon():Number
		{
			return _lon;
		}
		public function set lon(newLon:Number):void
		{
			_lon = newLon;
		}

		public function get lat():Number
		{
			return _lat;
		}
		public function set lat(newLat:Number):void
		{
			_lat = newLat;
		}

	}
}

