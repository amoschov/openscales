package org.openscales.fx.handler.mouse
{
	import org.openscales.core.handler.mouse.WMSGetFeatureInfo;
	import org.openscales.fx.handler.FxHandler;
	

	public class FxWMSGetFeatureInfo extends FxHandler
	{
	
		public function FxWMSGetFeatureInfo()
		{
			this.handler = new WMSGetFeatureInfo();
			super();
		}
		
		public function set url(url:String):void {
			(this.handler as WMSGetFeatureInfo).url = url;
		}
		
		public function set layers(layers:String):void {
			(this.handler as WMSGetFeatureInfo).layers = layers;
		}
		
		public function set srs(srs:String):void {
			(this.handler as WMSGetFeatureInfo).srs = srs;
		}
		
		public function set format(format:String):void {
			(this.handler as WMSGetFeatureInfo).format = format;
		}
		
		public function set maxFeatures(maxFeatures:Number):void {
			(this.handler as WMSGetFeatureInfo).maxFeatures = maxFeatures;
		}
		
	}
}