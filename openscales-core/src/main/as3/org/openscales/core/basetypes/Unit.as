package org.openscales.core.basetypes
{
	/**
	 * The map unit
	 *  
	 * @author Bouiaw
	 */	
	public class Unit
	{
		public static var DEGREE:String = "degree";
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
		    }
			return 0;
		}
		
	}
}