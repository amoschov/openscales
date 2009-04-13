package org.openscales.fx.feature
{
	import mx.core.UIComponent;
	
	import org.openscales.core.feature.Style;

	public class FxStyle extends UIComponent
	{
		private var _style:Style;	
		
		public function FxStyle()
		{
			this._style = new Style();
			super();
		}
		
		public function get style():Style {
			return this._style;
		}

		public function set fillColor(fillColor:uint):void {
			if(this.style != null)
				this.style.fillColor = fillColor;
		}

		public function set fillOpacity(fillOpacity:Number):void {
			if(this.style != null)
				this.style.fillOpacity = fillOpacity;
		}

		public function set strokeColor(strokeColor:uint):void {
			if(this.style != null)
				this.style.strokeColor = strokeColor;
		}

		public function set strokeOpacity(strokeOpacity:Number):void {
			if(this.style != null)
				this.style.strokeOpacity = strokeOpacity;
		}

		public function set strokeWidth(strokeWidth:Number):void {
			if(this.style != null)
				this.style.strokeWidth = strokeWidth;
		}

		public function set strokeLinecap(strokeLinecap:String):void {
			if(this.style != null)
				this.style.strokeLinecap = strokeLinecap;
		}

		public function set pointRadius(pointRadius:Number):void {
			if(this.style != null)
				this.style.pointRadius = pointRadius;
		}
		
		
	}
}