package org.openscales.core.renderer
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.openscales.core.events.FeatureEvent;
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
		private var _options:Object = new Object();
		private var _geometryClass:String = null;
		private var _attributes:Object = new Object();
		
		private var _isSelect:Boolean=true;
		
		public function SpriteElement()
		{	
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
		}
		
		public function get options():Object {
			return this._options;
		}
		
		public function set options(value:Object):void {
			this._options = value;
		}
		
		public function get geometryClass():String {
			return this._geometryClass;
		}
		
		public function set geometryClass(value:String):void {
			this._geometryClass = value;
		}
		
		public function get attributes():Object {
			return this._attributes;
		}
		
		public function set attributes(value:Object):void {
			this._attributes = value;
		}
		
		
		/**
		 * Events Management
		 * 
		 */
		 public function OnMouseHover(pevt:MouseEvent):void
		 {
		 	this.buttonMode=true;
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_OVER,this.feature,pevt.stageX,pevt.stageY));
		 }
		  public function OnMouseOut(pevt:MouseEvent):void
		 {
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_OUT,this.feature,pevt.stageX,pevt.stageY));
		 }
		 public function onMouseClick(pevt:MouseEvent):void
		 {
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_CLICK,this.feature,pevt.stageX,pevt.stageY));
		 }
		  public function onMouseDoubleClick(pevt:MouseEvent):void
		 {
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_DOUBLECLICK,this.feature,pevt.stageX,pevt.stageY));
		 }
		 
		 public function onMouseDown(pevt:MouseEvent):void
		 {
		 	this.buttonMode=true;
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEDOWN,this.feature,pevt.stageX,pevt.stageY));
		 }
		 
		  public function onMouseUp(pevt:MouseEvent):void
		 {
		 	this.buttonMode=false;
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEUP,this.feature,pevt.stageX,pevt.stageY));
		 }
		 
		 public function OnMouseMove(pevt:MouseEvent):void
		 {
		 	this.feature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_MOUSEMOVE,this.feature,pevt.stageX,pevt.stageY));
		 }
	}
}