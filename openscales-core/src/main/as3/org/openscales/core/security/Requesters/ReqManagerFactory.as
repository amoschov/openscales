package org.openscales.core.security.Requesters
{
	import org.openscales.core.security.RequestManager;
	
	public class ReqManagerFactory
	{
		/**
		 * @private
		 * @param requestManager
		 * */
		private static var _requestManager:RequestManager;
		public function ReqManagerFactory()
		{
		}
		public static function get requestManager():RequestManager
		{
			if(ReqManagerFactory._requestManager==null) ReqManagerFactory._requestManager=new RequestManager();
			return ReqManagerFactory._requestManager;
		}		
	}
}