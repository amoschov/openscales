package org.openscales.basetypes
{
	import org.openscales.UtilGeometry;
	
	/**
	 * The map unit
	 *
	 * @author Bouiaw
	 */
	public class Unit
	{
		public static var DEGREE:String = "degrees";
		public static var METER:String = "m";
		public static var KILOMETER:String = "km";
		public static var FOOT:String = "ft";
		public static var MILE:String = "mi";
		public static var INCH:String = "inch";

		public static var DOTS_PER_INCH:int = 72;

		public static function getInchesPerUnit(unit:String):Number {
			switch(unit) {
				case Unit.INCH:
					return 1.0;
					break;
				case Unit.FOOT:
					return 12.0;
					break;
				case Unit.MILE:
					return 63360.0;
					break;
				case Unit.METER:
					return 39.3701;
					break;
				case Unit.KILOMETER:
					return 39370.1;
					break;
				case Unit.DEGREE:
					return 4374754;
					break;
				default:
					return 0;
			}
		}

		public static function getResolutionFromScale(scale:Number, units:String = null):Number {

			if (units == null) {
				units = Unit.DEGREE;
			}

			var normScale:Number = UtilGeometry.normalizeScale(scale);

			var resolution:Number = 1 / (normScale * Unit.getInchesPerUnit(units)
				* Unit.DOTS_PER_INCH);
			return resolution;
		}

		public static function getScaleFromResolution(resolution:Number, units:String):Number {
			if (units == null) {
				units = Unit.DEGREE;
			}

			var scale:Number = resolution * Unit.getInchesPerUnit(units) *
				Unit.DOTS_PER_INCH;
			return scale;
		}

	}
}

