package org.openscales.core.control.ui
{
	import flash.display.Bitmap;

	import org.openscales.core.basetypes.Pixel;

	/**
	 * CheckBox class allows to create checkbox intsances in pure AS3.
	 * Extends Button class.
	 */
	public class CheckBox extends Button
	{

		[Embed(source="/images/check.png")]
		private var _layerSwitchercheckImg:Class;

		[Embed(source="/images/uncheck.png")]
		private var _layerSwitcherUncheckImg:Class;

		private var _status:Boolean=false;
		private var image:Bitmap;

		/**
		 *
		 */
		private var _layerName:String;

		public function CheckBox(xy:Pixel,layerName:String)
		{    
			super("check", new _layerSwitchercheckImg(), xy);
			this.layerName = layerName;
			this.status=true;
		}
		
		/**
		 * Manage the status of the checkBox, and display the appropriate image
		 * 
		 * @param value check=true uncheck=false
		 */
		public function set status(value:Boolean):void {
			this._status = value;

			for(var i:int=0; i<this.numChildren;i++) {
				this.removeChildAt(0);
			}

			if(this._status == false) {
				this.image = new _layerSwitcherUncheckImg();
			} else {
				this.image = new _layerSwitchercheckImg();
			}
			this.addChild(this.image);

		}
		
		// Getters & setters
		public function get status():Boolean
		{
			return this._status;
		}
		public function get layerName():String
		{
			return this._layerName;
		}
		public function set layerName(value:String):void
		{
			this._layerName=value;
		}




	}
}

