package org.openscales.proj.projections {
	import org.opengis.geometry.IDirectPosition;
	import org.openscales.proj.IProjection;

	/**
	 * Identity projection for testing purpose
	 */
	public class Identity implements IProjection {

		private var PROJECTION_NAME:String="identity";

		public function Identity() {
		}

		public function get name():String {
			return this.PROJECTION_NAME;
		}

		public function get names():Array {
			return [this.PROJECTION_NAME];
		}

		public function get code():String {
			return "";
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