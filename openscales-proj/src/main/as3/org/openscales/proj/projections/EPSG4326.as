package org.openscales.proj.projections {
	import org.opengis.geometry.IDirectPosition;
	import org.openscales.proj.IProjection;

	/**
	 * Identity projection for testing purpose
	 */
	public class EPSG4326 implements IProjection {

		private var PROJECTION_NAME:String="EPSG:4326";

		public function EPSG4326() {
		}

		public function get name():String {
			return this.PROJECTION_NAME;
		}

		public function get names():Array {
			return [this.PROJECTION_NAME];
		}

		public function get code():String {
			return this.PROJECTION_NAME;
		}

		public function get units():String {
			return "";
		}

		public function forward(pos:IDirectPosition):IDirectPosition {
			return pos;
		}

		public function inverse(pos:IDirectPosition):IDirectPosition {
			return pos;
		}

	}
}