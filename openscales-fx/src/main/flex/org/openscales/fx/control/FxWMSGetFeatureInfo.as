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
		
		public function set srs(srs:String):void {
			(this.control as WMSGetFeatureInfo).srs = srs;
		}
		
		public function set format(format:String):void {
			(this.control as WMSGetFeatureInfo).format = format;
		}
		
		public function set maxFeatures(maxFeatures:Number):void {
			(this.control as WMSGetFeatureInfo).maxFeatures = maxFeatures;
		}
		
	}
}