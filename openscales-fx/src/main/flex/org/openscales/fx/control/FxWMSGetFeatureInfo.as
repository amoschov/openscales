package org.openscales.fx.control
{
	import org.openscales.core.control.WMSGetFeatureInfo;

	public class FxWMSGetFeatureInfo extends FxControl
	{
	
		public function FxWMSGetFeatureInfo()
		{
			this.control = new WMSGetFeatureInfo();
			super();
		}
		
		public function set url(url:String):void {
			(this.control as WMSGetFeatureInfo).url = url;
		}
		
		public function set layers(layers:String):void {
			(this.control as WMSGetFeatureInfo).layers = layers;
		}
		
	}
}