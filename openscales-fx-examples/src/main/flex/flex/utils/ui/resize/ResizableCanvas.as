package flex.utils.ui.resize {
	import mx.containers.BoxDirection;
	import mx.containers.Canvas;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;


	/**
	 *  The alpha value for the resize handle.
	 *  @default 0x666666
	 */
	[Style(name="resizeHandleColor",type="Color",inherit="no")]

	/**
	 *  The alpha value for the resize handle.
	 *  @default 1
	 */
	[Style(name="resizeHandleAlpha",type="Number",inherit="no")]

	/**
	 * Extends the ResizableCanvas class to let the user resize the canvas by dragging on a small
	 * 16x16 resize handle in the bottom right corner of the canvas.
	 *
	 * See the ResizeManager class for more details.
	 *
	 * You can also specify the minWidth, minHeight, maxWidth, and maxHeight properties
	 * to restrict the size of the canvas.
	 *
	 *  <pre>
	 *  &lt;ResizableCanvas
	 *   <strong>Styles</strong>
	 *   resizeHandleColor="0x666666"
	 *   resizeHandleAlpha="1"
	 *
	 * @author Chris Callendar
	 * @date March 17th, 2009
	 */
	public class ResizableCanvas extends Canvas {
		// setup the styles
		private static var classConstructed:Boolean=classConstruct();

		private static function classConstruct():Boolean {
			if (!StyleManager.getStyleDeclaration("ResizableCanvas")) {
				// If there is no CSS definition then create one and set the default values.
				var style:CSSStyleDeclaration=new CSSStyleDeclaration();
				style.defaultFactory=function():void {
					this.resizeHandleColor=0x666666;
					this.resizeHandleAlpha=1;
				};
				StyleManager.setStyleDeclaration("ResizableCanvas", style, true);
			}
			return true;
		}
		;

		private var resizeManager:ResizeManager;

		public function ResizableCanvas() {
			super();
			this.resizeManager=new ResizeManager(this);

			// set a minimum size for this canvas
			minWidth=24;
			minHeight=24;
		}

		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);

			if ((styleProp == "resizeHandleColor") || (styleProp == "resizeHandleAlpha")) {
				invalidateDisplayList();
			}
		}

		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);

			// Draw resize handle
			var color:uint=uint(getStyle("resizeHandleColor"));
			var alpha:Number=Number(getStyle("resizeHandleAlpha"));
			resizeManager.drawResizeHandle(w, h, color, alpha);
		}

		override public function validateDisplayList():void {
			super.validateDisplayList();
			// prevent the scrollbars from covering up the resize handle
			if (horizontalScrollBar || verticalScrollBar) {
				resizeManager.adjustScrollBars(horizontalScrollBar, verticalScrollBar);
			}
		}

	}
}