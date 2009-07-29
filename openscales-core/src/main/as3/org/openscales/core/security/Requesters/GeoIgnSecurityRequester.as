package org.openscales.core.security.Requesters
{
	import org.openscales.core.RequestLayer;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.security.SecurityType;
	
	public class GeoIgnSecurityRequester extends DefaultRequester implements ISecurityRequester 
	{
		public function GeoIgnSecurityRequester()
		{
			super();
			//Type Instanciation 
			this._type=SecurityType.IgnGeoDrm;
		}
		override public function IsSecuredByRequester(layerRefId:Layer):Boolean
		{
			return false;
		}
		override public function AuthentificateLayer(Request:RequestLayer):void
		{
			
		}
	}
}