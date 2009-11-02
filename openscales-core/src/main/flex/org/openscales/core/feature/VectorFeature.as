package org.openscales.core.feature
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	
	import org.openscales.core.Trace;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Fill;
	import org.openscales.core.style.symbolizer.FillSymbolizer;
	import org.openscales.core.style.symbolizer.Stroke;
	import org.openscales.core.style.symbolizer.StrokeSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;

	/**
	 * Vector features use the Geometry classes as geometry description.
	 * They have an ‘attributes’ property, which is the data object, and a ‘style’ property.
	 */
	public class VectorFeature extends Feature
	{

		private var _geometry:Geometry = null;
		private var _state:String = null;    
		private var _style:Style = null;	    
		private var _originalStyle:Style = null;
		
		//Edition Mode 
		//a feature could also be a temporary feature used for Edition Mode
		
		
		//Edition Attribute
		/**
		 * To know if the vector feature is editable when its
		 * vector layer is in edit mode
		 **/
		private var _isEditable:Boolean=false;
		/**
		 * To know if the vector feature  is a temporary used 
		 * for edition mode
		 **/
		private var _isEditionFeature:Boolean=false;
		
		
		
		/**
		 *Link to all temporary features used to edit the feature 
		 * */
		private var _editionFeaturesArray:Array=new Array();
		
		/**
		 * Edition feature parent
		 * when the feature is an edition feature
		 * */
		private var _editionFeatureParent:VectorFeature=null;
		/**
		 * Point under the mouse
		 * */
		protected var _pointFeatureUnderTheMouse:PointFeature=null;
		
		/**
		 * To know if the vector feature is selected
		 * */
		
		private var _isselected:Boolean=true;
		
		/**
		 * VectorFeature constructor
		 *
		 * @param geometry The feature's geometry
		 * @param data
		 * @param style The feature's style
		 */
		public function VectorFeature(geom:Geometry = null, data:Object = null, style:Style = null,isEditable:Boolean=false,isEditionFeature:Boolean=false) {
			super(null, null, data);
			this.lonlat = null;
			this.geometry = geom;
			if (this.geometry && this.geometry.id)
				this.name = this.geometry.id;
			this.state = null;
			this.attributes = new Object();
			if (data) {
				this.attributes = Util.extend(this.attributes, data);
			}
			this.style = style ? style : null;
			
			this._isEditable=isEditable;
			//A feature can't be editable and editionfeature(temporary feature )
			if(isEditable)
			{
				if(isEditionFeature){
					Trace.error("A feature can't be editable and edition feature(temporary feature ) at the same time");
					this._isEditionFeature=false;
				}
			} 
			else
			{
				this._isEditionFeature=isEditionFeature;
			}
		}
		
		/**
		 * Destroys the VectorFeature
		 */
		override public function destroy():void {
			if (this.layer) {
				this.layer = null;
			}

			this.geometry = null;
			super.destroy();
		}
		
		/**
		 *we overrided this function for edition mode
		 **/
		override public function set layer(value:Layer):void{
			super.layer=value;
	
		}
			
		/**
		 * Determines if the feature is placed at the given point with a certain tolerance (or not).
		 *
		 * @param lonlat The given point
		 * @param toleranceLon The longitude tolerance
		 * @param toleranceLat The latitude tolerance
		 */
		public function atPoint(lonlat:LonLat, toleranceLon:Number, toleranceLat:Number):Boolean {
			var atPoint:Boolean = false;
			if(this.geometry) {
				atPoint = this.geometry.atPoint(lonlat, toleranceLon, 
					toleranceLat);
			}
			return atPoint;
		}

		public function get geometry():Geometry {
			return this._geometry;
		}

		public function set geometry(value:Geometry):void {
			this._geometry = value;
		}

		public function get state():String {
			return this._state;
		}

		public function set state(value:String):void {

			if (value == State.UPDATE) {
				switch (this.state) {
					case State.UNKNOWN:
					case State.DELETE:
						this._state = value;
						break;
					case State.UPDATE:
					case State.INSERT:
						break;
				}
			} else if (value == State.INSERT) {
				switch (this.state) {
					case State.UNKNOWN:
						break;
					default:
						this._state = value;
						break;
				}
			} else if (value == State.DELETE) {
				switch (this.state) {
					case State.INSERT:
						break;
					case State.DELETE:
						break;
					case State.UNKNOWN:
					case State.UPDATE:
						this._state = value;
						break;
				}
			} else if (value == State.UNKNOWN) {
				this._state = value;
			}
		}

		public function get style():Style {
			return this._style;
		}

		public function set style(value:Style):void {
			this._style = value;
		}

		public function get originalStyle():Style {
			return this._originalStyle;
		}

		public function set originalStyle(value:Style):void {
			this._originalStyle = value;
		}

		override public function draw():void {
			super.draw();
			
			var style:Style;
			if(this.style == null){
				// FIXME : Ugly thing done here
				style = (this.layer as VectorLayer).style;
			}
			else{
				
				style = this.style;
			}			

			trace("Drawing feature "+this.data["nom_region"]);
			trace("Drawing feature with style : "+style.name);
			var rulesCount:uint = style.rules.length;
			var rule:Rule;
			var symbolizer:Symbolizer;
			var symbolizers:Array;
			var symbolizersCount:uint;
			var j:uint;
			
			for(var i:uint = 0;i<rulesCount;i++){
				
				// TODO : Test if rule applies to the feature
				rule = style.rules[i];
				
				symbolizersCount = rule.symbolizers.length;
				for(j = 0; j<symbolizersCount; j++){
					
					symbolizer = rule.symbolizers[j];
					if(this.acceptSymbolizer(symbolizer)){
						this.setStyle(symbolizer);
						this.executeDrawing(symbolizer);
					}
				}
			}
		}
		
		protected function setStyle(symbolizer:Symbolizer):void{
			
			var symbolizerType:String = typeof(symbolizer);
			if (symbolizer is FillSymbolizer) {
				
				this.configureGraphicsFill((symbolizer as FillSymbolizer).fill);
			}

			if (symbolizer is StrokeSymbolizer) {
				
				this.configureGraphicsStroke((symbolizer as StrokeSymbolizer).stroke);
			}
		}
		
		protected function configureGraphicsFill(fill:Fill):void{
			
			if(fill){
				this.graphics.beginFill(fill.color, fill.opacity);
			} else {
				this.graphics.endFill();
			}
		}
		
		protected function configureGraphicsStroke(stroke:Stroke):void{
			if(stroke){
			var linecap:String;
				var linejoin:String;
				switch(stroke.linecap){
					case Stroke.LINECAP_ROUND:
						linecap = CapsStyle.ROUND;
						break;
					case Stroke.LINECAP_SQUARE:
						linecap = CapsStyle.SQUARE;
						break;
					default:
						linecap = CapsStyle.NONE;
				}
				
				switch(stroke.linejoin){
					case Stroke.LINEJOIN_ROUND:
						linejoin = JointStyle.ROUND;
						break;
					case Stroke.LINEJOIN_BEVEL:
						linejoin = JointStyle.BEVEL;
						break;
					default:
						linejoin = JointStyle.MITER;
				}
				
				this.graphics.lineStyle(stroke.width, stroke.color, stroke.opacity, false, "normal", linecap, linejoin);
			}
			else{
				this.graphics.lineStyle();
			}
		}
		
		protected function acceptSymbolizer(symbolizer:Symbolizer):Boolean{
			
			return true;
		}
		
		protected function executeDrawing(symbolizer:Symbolizer):void{
			trace("Drawing");
		}
		/**
		 * To obtain feature clone 
		 * */
		override public function clone():Feature{
			return null;
		}
		/**
		 *To get an editable clone 
		 **/
		public function getEditableClone():VectorFeature{
			var editableClone:VectorFeature=this.clone() as VectorFeature;
			editableClone._isEditionFeature=true;
			editableClone.isEditable=false;
			editableClone.editionFeatureParent=this;
			return editableClone;
		}	
	
		
		/**
		 * create edition vertice(Virtual) only for edition feature
		 * @param geometry
		 * */
		public function createEditionVertices(collection:Collection=null):void{
			    if(collection==null) collection=this.geometry as Collection;
				for(var i:int=0;i<collection.componentsLength;i++){
					var geometry:Geometry=collection.componentByIndex(i);
					if(geometry is Collection){
						createEditionVertices(geometry as Collection);
					}
					else 
					{
						if(geometry is Point){
							var EditionVertice:PointFeature=new PointFeature(geometry.clone() as Point,null,Style.getDefaultCircleStyle(),true,collection);
							this._editionFeaturesArray.push(EditionVertice);
							EditionVertice.editionFeatureParent=this;
						}
					}
				}						
		}
		/**
		 * delete edition vertice(Virtual) only for edition feature
		 * */
		public function deleteEditionVertices():void{
			
			(this.layer as VectorLayer).removeFeatures(this._editionFeaturesArray);
			this._editionFeaturesArray=null;
			this._editionFeaturesArray=new Array();
			
		}
		/**
		 * Refresh edition vertice(Virtual) only for edition feature
		 * @param geometry
		 * */
		 public function RefreshEditionVertices():void{
			  deleteEditionVertices();
			  createEditionVertices();	
		}		
		//FIN EDITION MODE
		
		
		
		/**
		 * To know if the vector feature is editable when its
		 * vector layer is in edit mode
		 **/
		public function get isEditable():Boolean{
			return this._isEditable;
		}
		/**
		 * @private
		 * */
		 public function set isEditable(value:Boolean):void{
		 	this._isEditable=value;
		 	if(_isEditable) {
		 		this._isEditionFeature=false;
		 	}
		 }
		 /**
		 * To know if the vector feature  is a temporary vector only used 
		 * for edition mode
		 **/
		 public function get isEditionFeature():Boolean{
		 	return this._isEditionFeature;
		 }
		 
		  /**
		 * To know if the vector feature  is a temporary vector only used 
		 * for edition mode
		 **/
		 public function set isEditionFeature(value:Boolean):void{
		 	this._isEditionFeature = value;
		 }
		
		/**
		 *Link to all temporary features used to edit the feature 
		 * */
		public function get editionFeaturesArray():Array{
			return this._editionFeaturesArray;
		}
		
		public function get  editionFeatureParent():VectorFeature{
			if(!this.isEditionFeature) return null;
			return this._editionFeatureParent;
		}
		public function set  editionFeatureParent(value:VectorFeature):void{
			if(this.isEditionFeature)this._editionFeatureParent=value;
		}
		public function set isSelected(value:Boolean):void{
			this._isselected=value;
		}
		public function get isSelected():Boolean{
			return this._isselected;
		}
	}
}

