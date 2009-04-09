package org.opengis.referencing.crs
{
	import org.opengis.referencing.IReferenceSystem;
	import org.opengis.referencing.cs.ICoordinateSystem;
	
	public interface ICoordinateReferenceSystem extends IReferenceSystem
	{
		function get coordinateSystem():ICoordinateSystem;
	}
}