package org.openscales.core.tile
{
	import flash.display.Loader;
	
	public class LoaderWrapper
	{
		public var loader:Loader;
		private var refCount:int;
		
		public function LoaderWrapper(loader:Loader)
		{
			this.loader = loader;
			refCount = 0;
		}
		
		public function addRef() : void
		{
			refCount++;
		}
		
		public function removeRef() : void
		{
			refCount--;
			
			if(refCount <= 0)
			{
				try
				{
					loader.close();
				}
				catch(error:Error)
				{
					trace("LoaderWrapper.removeRef(): " + error.message);
				}
				
				loader.unload();
				loader = null;
				
				if(refCount < 0)
					throw new Error("refCount < 0");
			}
		}

	}
}