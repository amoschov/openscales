package org.openscales.core.events
{
	/**
	 * event related to the Security
	 * @author DamienNda 
	 **/
	public class SecurityEvent extends OpenScalesEvent
	{
		public static const LOAD_CONF_END:String="openscales.loadconfend";
		public static const SECURITY_LOAD:String="security.load";
		
		public function SecurityEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}