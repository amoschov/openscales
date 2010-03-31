package org.openscales.core
{
	/**
	 * allow creation of unique ID string.
	 * This could be usefull with HashMaps for instance.
	 */
	public class UID
	{
		private static var counter:Number = 0;
		private static var prefix:String;

		public function UID() {
			var date:Date = new Date();
			prefix = "uid"+date.getTime()+"_";
		}
		
		public function gen_uid():String {
			/*
			 * As Number.MAX_VALUE is 1.79769313486232e+308 this should never
			 * happend, but you may know Murphy's law... But something is sure,
			 * if we reach this point, number of miliseconds since epoch should
			 * have been increased by at least one!
			 */
			if(counter==Number.MAX_VALUE){
				counter=0;
				var date:Date = new Date();
				prefix = "uid"+date.getTime()+"_";
			}
			counter++;
			return prefix+counter;
		}

	}
}