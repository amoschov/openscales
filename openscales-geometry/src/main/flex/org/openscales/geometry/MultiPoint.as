package org.openscales.geometry
{
	import org.openscales.proj4as.ProjProjection;

	/**
	 * MultiPoint is a collection of Points.
	 */
	public class MultiPoint extends CollectionPoint
	{
		public function MultiPoint(components:Vector.<Number> = null) {
			
			super(components);
			
		}
		
        public function removePoint(point:Point):void {
			this.removeComponent(point);
		}
		/**
		 * Component of the specified index, casted to the Point type
		 */
        override public function toShortString():String {
			var s:String = "(";
			s+=this.componentsString
			return s + ")";
		}
				/**
		 * To get this geometry clone
		 * */
		override public function clone():Geometry{
			var MultiPointClone:MultiPoint=new MultiPoint();
			var component:Vector.<Number>=this.getcomponentsClone();
			MultiPointClone.addPoints(component);
			return MultiPointClone;
		}
	}
}

