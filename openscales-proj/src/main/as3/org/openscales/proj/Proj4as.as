package org.openscales.proj
{
	import org.opengis.geometry.IDirectPosition;
	
	public class Proj4as
	{
		public function Proj4as()
		{
			
		}
		
		public function transform(source:IProjection, dest:IProjection, pos:IDirectPosition):IDirectPosition {
			// TODO : use Projections to tranform points
			
			return pos;
		}

	}
}