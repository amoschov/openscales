package org.openscales.core.control.ui
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size;

	public class Button extends Sprite
	{
		private var _image:Bitmap = null;
		
		public function Button(name:String, image:Bitmap, xy:Pixel, sz:Size = null)
		{
			super();
			
			this._image = image;
			
			this.addChild(this._image);
			
	        this.x = xy.x;
	        this.y = xy.y;
	        this.name = name;
	        
	        if(sz != null) {
	        	this.width = sz.w;
	        	this.height = sz.h;
	        } else {
	        	this.width = image.width;
	        	this.height = image.height;
	        }
	        	
		}
		
	}
}