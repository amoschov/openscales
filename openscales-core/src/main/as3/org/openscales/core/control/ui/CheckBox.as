package org.openscales.core.control.ui
{
	import flash.display.Bitmap;
	
	import org.openscales.core.basetypes.Pixel;

	public class CheckBox extends Button
	{
 
        [Embed(source="/org/openscales/core/img/check.png")]
        private var _layerSwitchercheckImg:Class;
        
        [Embed(source="/org/openscales/core/img/uncheck.png")]
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