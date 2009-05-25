/* Proj4as3 
*  German Osin (Gradoservice ltd.)
*  LGPL Licencse
*    
*/

package com.gradoservice.proj4as.proj
{
	import com.gradoservice.proj4as.ProjPoint;
	
	public interface IProjection
	{
	  	function init():void
	  	
	  	function forward(p:ProjPoint):ProjPoint
	  	
	  	function inverse(p:ProjPoint):ProjPoint
		
	}
}