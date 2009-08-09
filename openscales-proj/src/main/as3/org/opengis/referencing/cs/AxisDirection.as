/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/referecing/cs/AxisDirection.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.referencing.cs {
	import flash.utils.getQualifiedClassName;
	import org.opengis.util.CodeList;

	/**
	 * The direction of positive increments in the coordinate value for a coordinate system axis. This
	 * direction is exact in some cases, and is approximate in other cases.
	 * Some coordinate systems use non-standard orientations. For example, the first axis in South
	 * African grids usually points West, instead of East. This information is obviously relevant for
	 * algorithms converting South African grid coordinates into Lat/Long.
	 *
	 * UML : CS_AxisDirection.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public final class AxisDirection extends CodeList {

		/**
		 * Values for this code list.
		 * @private
		 */
		private static var VALUES:Array=[];

		/**
		 * Axis positive direction is towards higher pixel column.
		 */
		public static const COLUMN_POSITIVE:AxisDirection=new AxisDirection("COLUMN_POSITIVE", "columnPositive");

		/**
		 * Axis positive direction is towards lower pixel column.
		 */
		public static const COLUMN_NEGATIVE:AxisDirection=new AxisDirection("COLUMN_NEGATIVE", "columnNegative", COLUMN_POSITIVE);

		/**
		 * Axis positive direction is towards top of approximately vertical display surface.
		 */
		public static const DISPLAY_UP:AxisDirection=new AxisDirection("DISPLAY_UP", "displayUp");

		/**
		 * Axis positive direction is towards bottom of approximately vertical display surface.
		 */
		public static const DISPLAY_DOWN:AxisDirection=new AxisDirection("DISPLAY_DOWN", "displayDown", DISPLAY_UP);

		/**
		 * Axis positive direction is right in display.
		 */
		public static const DISPLAY_RIGHT:AxisDirection=new AxisDirection("DISPLAY_RIGHT", "displayRight");

		/**
		 * Axis positive direction is left in display.
		 */
		public static const DISPLAY_LEFT:AxisDirection=new AxisDirection("DISPLAY_LEFT", "displayLeft", DISPLAY_RIGHT);

		/**
		 * Axis positive direction is up relative to gravity.
		 */
		public static const UP:AxisDirection=new AxisDirection("UP", "up");

		/**
		 * Axis positive direction is down relative to gravity.
		 */
		public static const DOWN:AxisDirection=new AxisDirection("DOWN", "down", UP);

		/**
		 * Axis positive direction is π/2 radians clockwise from north.
		 */
		public static const EAST:AxisDirection=new AxisDirection("EAST", "east");

		/**
		 * Axis positive direction is approximately east-north-east.
		 */
		public static const EAST_NORTH_EAST:AxisDirection=new AxisDirection("EAST_NORTH_EAST", "eastNorthEast");

		/**
		 * Axis positive direction is approximately east-south-east.
		 */
		public static const EAST_SOUTH_EAST:AxisDirection=new AxisDirection("EAST_SOUTH_EAST", "eastSouthEast");

		/**
		 * Axis positive direction is towards the future.
		 */
		public static const FUTURE:AxisDirection=new AxisDirection("FUTURE", "future");

		/**
		 * Axis positive direction is towards the past.
		 */
		public static const PAST:AxisDirection=new AxisDirection("PAST", "past", FUTURE);

		/**
		 * Axis positive direction is in the equatorial plane from the centre of the modelled earth
		 * towards the intersection of the equator with the prime meridian.
		 */
		public static const GEOCENTRIC_X:AxisDirection=new AxisDirection("GEOCENTRIC_X", "geocentricX");

		/**
		 * Axis positive direction is in the equatorial plane from the centre of the modelled earth
		 * towards the intersection of the equator and the meridian π/2 radians eastwards from the
		 * prime meridian.
		 */
		public static const GEOCENTRIC_Y:AxisDirection=new AxisDirection("GEOCENTRIC_Y", "geocentricY");

		/**
		 * Axis positive direction is from the centre of the modelled earth parallel to its rotation
		 * axis and towards its north pole.
		 */
		public static const GEOCENTRIC_Z:AxisDirection=new AxisDirection("GEOCENTRIC_Z", "geocentricZ");

		/**
		 * Axis positive direction is north.
		 */
		public static const NORTH:AxisDirection=new AxisDirection("NORTH", "north");

		/**
		 * Axis positive direction is approximately north-east.
		 */
		public static const NORTH_EAST:AxisDirection=new AxisDirection("NORTH_EAST", "northEast");

		/**
		 * Axis positive direction is approximately north-north-east.
		 */
		public static const NORTH_NORTH_EAST:AxisDirection=new AxisDirection("NORTH_NORTH_EAST", "northNorthEast");

		/**
		 * Axis positive direction is approximately north-north-west.
		 */
		public static const NORTH_NORTH_WEST:AxisDirection=new AxisDirection("NORTH_NORTH_WEST", "northNortWest");

		/**
		 * Axis positive direction is approximately north-west.
		 */
		public static const NORTH_WEST:AxisDirection=new AxisDirection("NORTH_WEST", "northWest");

		/**
		 * Unknown or unspecified axis orientation.
		 */
		public static const OTHER:AxisDirection=new AxisDirection("OTHER", "other");

		/**
		 * Axis positive direction is towards higher pixel row.
		 */
		public static const ROW_POSITIVE:AxisDirection=new AxisDirection("ROW_POSITIVE", "rowPositive");

		/**
		 * Axis positive direction is towards lower pixel row.
		 */
		public static const ROW_NEGATIVE:AxisDirection=new AxisDirection("ROW_NEGATIVE", "rowNegative", ROW_POSITIVE);

		/**
		 * Axis positive direction is π radians clockwise from north.
		 */
		public static const SOUTH:AxisDirection=new AxisDirection("SOUTH", "south", NORTH);

		/**
		 * Axis positive direction is approximately south-east.
		 */
		public static const SOUTH_EAST:AxisDirection=new AxisDirection("SOUTH_EAST", "southEast", NORTH_WEST);

		/**
		 * Axis positive direction is approximately south-south-east.
		 */
		public static const SOUTH_SOUTH_EAST:AxisDirection=new AxisDirection("SOUTH_SOUTH_EAST", "southSouthEast", NORTH_NORTH_WEST);

		/**
		 * Axis positive direction is approximately south-south-west.
		 */
		public static const SOUTH_SOUTH_WEST:AxisDirection=new AxisDirection("SOUTH_SOUTH_WEST", "southSouthWest", NORTH_NORTH_EAST);

		/**
		 * Axis positive direction is approximately south-west.
		 */
		public static const SOUTH_WEST:AxisDirection=new AxisDirection("SOUTH_WEST", "southWest", NORTH_EAST);

		/**
		 * Axis positive direction is 3π/2 radians clockwise from north.
		 */
		public static const WEST:AxisDirection=new AxisDirection("WEST", "west", EAST);

		/**
		 * Axis positive direction is approximately west-north-west.
		 */
		public static const WEST_NORTH_WEST:AxisDirection=new AxisDirection("WEST_NORTH_WEST", "westNorthWest", EAST_SOUTH_EAST);

		/**
		 * Axis positive direction is approximately west-south-west.
		 */
		public static const WEST_SOUTH_WEST:AxisDirection=new AxisDirection("WEST_SOUTH_WEST", "westsouthWest", EAST_NORTH_EAST);

		/**
		 * The opposite direction (if any).
		 */
		private var _oppositeOrdinal:int=-1;

		/**
		 * Build a new axis direction.
		 *
		 * @param name the codelist value.
		 * @param identifier the codelist value identifier.
		 * @param opposite the opposite axis direction, if any.
		 *
		 * @throws DefinitionError duplicated name.
		 */
		public function AxisDirection(name:String, identifier:String="", opposite:AxisDirection=null) {
			// FIXME : AxisDirection.VALUES is null ... while VALUES is ok !
			super(VALUES, name, identifier);
			if (opposite != null) {
				this._oppositeOrdinal=opposite.ordinal();
				opposite._oppositeOrdinal=this.ordinal();
			}
		}

		/**
		 * Return the "absolute" direction of this axis. This "absolute" operation is similar to the
		 * abs(int)  method in that "negative" directions like (SOUTH, WEST, DOWN, PAST) are changed for
		 * their "positive" counterparts (NORTH, EAST, UP, FUTURE).
		 *
		 * @return The absolute direction.
		 */
		public function absolute():AxisDirection {
			if (this._oppositeOrdinal > this.ordinal()) {
				return AxisDirection.VALUES[this._oppositeOrdinal];
			}
			return this;
		}

		/**
		 * Return the list of enumerations of the same kind than this enum.
		 *
		 * @return The codes of the same kind than this code.
		 */
		public function family():Array {
			return AxisDirection.values();
		}

		/**
		 * Returns the opposite direction of this axis. The opposite direction of North is South, and
		 * the opposite direction of South is North. The same applies to East-West, Up-Down and
		 * Future-Past, etc.
		 *
		 * @return The opposite direction or null if this axis direction has no opposite.
		 */
		public function opposite():AxisDirection {
			return this._oppositeOrdinal == -1 ? null : AxisDirection.VALUES[this._oppositeOrdinal];
		}

		/**
		 * Return the list of AxisDirection.
		 *
		 * @return The list of codes.
		 */
		public static function values():Array {
			return AxisDirection.VALUES;
		}

		/**
		 * Return the axis direction that matches the given string.
		 *
		 * @param name the codelist value.
		 *
		 * @return the axis direction or null.
		 */
		public static function valueOf(name:String):AxisDirection {
			return CodeList.valueOf(name, getQualifiedClassName(AxisDirection)) as AxisDirection;
		}

	}

}
