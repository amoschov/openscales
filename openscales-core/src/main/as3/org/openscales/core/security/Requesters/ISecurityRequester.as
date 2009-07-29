package org.openscales.core.security.Requesters
{
	import org.openscales.core.RequestLayer;
	import org.openscales.core.layer.Layer;
	/**
	 *This class is used as Interface  for all security requsters  
	 * @author DamienNda 
	 **/
	public interface ISecurityRequester
	{
		/** 
		 * Layer Authentification the layer is unsecured 
		 * we directly dispatch layer Authentification event
		 * @param layerRefId layer reference
		 * @param request request object which contains parameters, url, etc...
		 **/
		function AuthentificateLayer(request:RequestLayer):void;
		/**
		 * To know if the layer is secured by the this requester
		 * @param layerRefId layer reference
		 * */
		 function IsSecuredByRequester(layerRefId:Layer):Boolean;	
		 /**
		 *To add Layer as secured layer 
		 * @param layer reference
		 **/
		  function addsecuredLayer(layerRefId:Layer):Boolean
	}
}