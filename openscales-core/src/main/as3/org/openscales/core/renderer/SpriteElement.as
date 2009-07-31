package org.openscales.core.renderer
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.events.SpriteCursorEvent;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.VectorFeature;

	/**
	 * Sprite element used by the Sprite Renderer.
	 */
	public class SpriteElement extends Sprite
	{
		
		private var _style:Style = null;
		//Sprite now knows his feature instead of his feature_id
		//it's important for event's on feature
		private var _feature:VectorFeature = null;

		private var _geometryClass:String = null;
		
		private var _isSelect:Boolean=true;
	
		public function SpriteElement(name:String = null)
		{	
			this.name = name;
			this.alpha = 1.0;
		}
		
		private function hideHand(event:SpriteCursorEvent):void{
			this.useHandCursor=false;
		}
		private function showHand(event:SpriteCursorEvent):void{
			this.useHandCursor = true;
		}
		
		public function get style():Style {
			return this._style;
		}
		
		public function set style(value:Style):void {
			this._style = value;
		}
		
		public function get feature():VectorFeature {
			return this._feature;
		}
		
		public function set feature(value:VectorFeature):void {
			this._feature = value;
			this.addEventListener(MouseEvent.MOUSE_OVER, this.OnMouseHover);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.OnMouseOut);
			this.addEventListener(MouseEvent.CLICK, this.onMouseClick);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, this.onMouseDoubleClick);	
			this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);	
			this.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
			
			this.feature.layer.map.addEventListener(SpriteCursorEvent.SPRITECURSOR_HIDE_HAND, hideHand);
			this.feature.layer.map.addEventListener(SpriteCursorEvent.SPRITECURSOR_SHOW_HAND, showHand);
			
		}
		
		public function get geometryClass():String {
			return this._geometryClass;
		}
		
		public function set geometryClass(value:String):void {
			this._geometryClass = value;
		}		
		
		/**
		 * Events Management
		 * 
		 */
		 public function OnMouseHover(pevt:MouseEvent):void
		 {
		 	this.buttonMode=true;
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_OVER,this.feature));
		 }
		  public function OnMouseOut(pevt:MouseEvent):void
		 {
		 	this.buttonMode=false;
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_OUT,this.feature));
		 }
		 public function onMouseClick(pevt:MouseEvent):void
		 {
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_CLICK,this.feature,pevt.ctrlKey));
		 }
		  public function onMouseDoubleClick(pevt:MouseEvent):void
		 {
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DOUBLECLICK,this.feature));
		 }
		 
		 public function onMouseDown(pevt:MouseEvent):void
		 {
		 	/* this.buttonMode=true; */
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEDOWN,this.feature));
		 }
		 
		  public function onMouseUp(pevt:MouseEvent):void
		 {
		 	/* this.buttonMode=false; */
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEUP,this.feature,pevt.ctrlKey));
		 }
		 
		 public function OnMouseMove(pevt:MouseEvent):void
		 {
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEMOVE,this.feature));
		 }
	}
}