package org.openscales.core.request
{
	public class AbstractRequest implements IRequest
	{

		protected var _onComplete:Function = null;
		protected var _onFailure:Function = null;

		public function AbstractRequest()
		{

		}

		public function destroy():void {

		}

	}
}

