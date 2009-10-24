package org.openscales.core.feature
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.openscales.core.Trace;
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Geometry;
	import org.openscales.core.geometry.Point;
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
		
		/**
		 * This Array  is used to record temporaries point for a feature modification
		 **/	 
		//TODO Damien Nda replace this with editionFeaturesArray 
		//WORK ON FEATURE STATE
		private var _tmpVertices:Array=new Array();
		
		/** 
		 * represents a  temporary vertice which represent the point of the feature  under the mouse
		 * */
		private var _tmpVerticeUnderTheMouse:TmpPointFeature=null;
	
		/**
		 * This tolerance is here for feature vertices and point under mouse differenciation
		 * */
		private var _tmpVerticeTolerance:Number=10;
		
		/**
		 * This Timer is used to delete the temporaries vertices
		 * when the mouse are not on the feature since a long time
		 * and to avoid temporary vertices flashing
		 * */
		private var _tmpVerticesTimer:Timer=null;
		
		/**
		 * value of Temporary Timer  
		 **/
		private var _tmpTimerValue:Number=5000;
		
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
		 * the geometry of the parent when the feature is an edition feature  
		 **/
		private var _editionFeatureParentGeometry:Collection=null;
		
		/**
		 *Link to all temporary features used to edit the feature 
		 * */
		protected var _editionFeaturesArray:Array;
		
		/**
		 * VectorFeature constructor
		 *
		 * @param geometry The feature's geometry
		 * @param data
		 * @param style The feature's style
		 */
		public function VectorFeature(geom:Geometry = null, data:Object = null, style:Style = null,isEditable:Boolean=false,isEditionFeature:Boolean=false,editionFeatureParentGeometry:Collection=null) {
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
				if(isEditionFeature || (editionFeatureParentGeometry!=null)){
					Trace.error("A feature can't be editable and edition feature(temporary feature ) at the same time");
					this._isEditionFeature=false;
					this._editionFeatureParentGeometry=null;
				}
			} 
			else
			{
				this._isEditionFeature=isEditionFeature;
				if(!isEditionFeature && editionFeatureParentGeometry!=null) this._editionFeatureParentGeometry=null;
				else this._editionFeatureParentGeometry=editionFeatureParentGeometry;
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
		 * To find the vertices of a simple collection
		 * @param geometry
		 * */
		private function createTmpVertices(collection:Collection):void{
			    
				for(var i:int=0;i<collection.componentsLength;i++){
					var geometry:Geometry=collection.componentByIndex(i);
					if(geometry is Collection){
						createTmpVertices(geometry as Collection);
					}
					else 
					{
						if(geometry is Point){
							var tmpVertice:TmpPointFeature=new TmpPointFeature(new Point((geometry as Point).x,(geometry as Point).y),{id:i},Style.getDefaultCircleStyle());
							tmpVertice.tmpPointParentGeometry=collection;
							this.tmpVertices.push(tmpVertice);
						}
					}
				}						
		}
		
		
		private function createVerticesUnderMouse(pevt:MouseEvent):void{
			//point under mouse adding
			if(this.layer!=null && this.layer.map!=null)
			{
				
				this.layer.map.buttonMode=true;
				var drawing:Boolean=true;
				var px:Pixel=new Pixel(this.layer.mouseX,this.layer.mouseY);
				var tmpPx:Pixel=null;
				var tmpLonLat:LonLat=new LonLat();
				
				for each(var tmpVertic:TmpPointFeature in this.tmpVertices)
				{
					//It's a real vertice
					if(tmpVertic.attributes.id!=null)
					{					
						//we don't show vertice under mouse so close from real vertice
						tmpLonLat.lon=(tmpVertic.geometry as Point).x;
						tmpLonLat.lat=(tmpVertic.geometry as Point).y;
						tmpPx=tmpVertic.layer.map.getLayerPxFromLonLat(tmpLonLat);
						if(Math.abs(px.x-tmpPx.x)<tmpVerticeTolerance && Math.abs(px.y-tmpPx.y)<tmpVerticeTolerance){
							drawing=false;
							break;
						}
					}
				}
				
				
				if(drawing)
				{
					//we delete the point under the mouse  from layer and from tmpVertices Array
					(this.layer as VectorLayer).removeFeature(this._tmpVerticeUnderTheMouse);
					var lonlat:LonLat=this.layer.map.getLonLatFromLayerPx(px);	
					var tmpPoint:Point=new Point(lonlat.lon,lonlat.lat);
					//There is always a component because the mouse is over the component
				//consequently we use the first
				//we find the collection which directly have a point as component
					var testCollection:Geometry=this.geometry;
					var parentTmpPoint:Geometry;
					while(testCollection is Collection)
					{
						parentTmpPoint=testCollection;
						testCollection=(testCollection as Collection).componentByIndex(0);
					}
				/*	var bob:LinearRing=parentTmpPoint as LinearRing;
					if(bob.getSegmentsIntersection(tmpPoint)!=-1){*/
			
						var style:Style = Style.getDefaultCircleStyle();		
					//isTmpFeatureUnderTheMouse attributes use to specify type of temporary feature
						var tmpVertice:TmpPointFeature=new TmpPointFeature(tmpPoint,{isTmpFeatureUnderTheMouse:true},style);
						this._tmpVerticeUnderTheMouse=tmpVertice;		
				
						tmpVertice.tmpPointParentGeometry=parentTmpPoint;
						(this.layer as VectorLayer).addFeature(tmpVertice);
					//}

				
				}
			}
		}
		
		/**
		 * When a feature is drag
		 * 
		 * */
		protected function onTmpFeaturedragStart(evt:FeatureEvent):void{
			
			//We test if the temporary point belongs to the vectorfeature 
			if((this._tmpVerticeUnderTheMouse==evt.feature)||Util.indexOf(this._tmpVertices,evt.feature)!=-1){
				this.unregisterListeners();
				this.removeEventListener(MouseEvent.MOUSE_MOVE,createVerticesUnderMouse);
				//We stop the Timer if it's not null
				if(this._tmpVerticesTimer!=null) 
				{
					this._tmpVerticesTimer.stop();
					this._tmpVerticesTimer.removeEventListener(TimerEvent.TIMER,deleteTmpVertices);
					this._tmpVerticesTimer=null;
				}
			}
		}
		protected function onTmpFeaturedragStop(evt:FeatureEvent):void{
			//We test if the temporary point belongs to the vectorfeature 
			if((this._tmpVerticeUnderTheMouse==evt.feature)||Util.indexOf(this._tmpVertices,evt.feature)!=-1){
				this.registerListeners();
				this.addEventListener(MouseEvent.MOUSE_MOVE,createVerticesUnderMouse);
				
				//this.layer.map.removeEventListener(MouseEvent.MOUSE_MOVE,createVerticesUnderMouse);
				
				//To know when a temporary feature is drag
				this.layer.map.removeEventListener(FeatureEvent.TMP_FEATURE_DRAG_START,onTmpFeaturedragStart);
				this.layer.map.removeEventListener(FeatureEvent.TMP_FEATURE_DRAG_STOP,onTmpFeaturedragStop);
			}
		}
		override protected function verticesShowing(pevt:MouseEvent):void{
			
			//if((this.layer as VectorLayer).tmpVerticesOnFeature){
		/*	if(this.geometry is Collection)
			{
				//To know when a temporary feature is drag
				this.layer.map.addEventListener(FeatureEvent.TMP_FEATURE_DRAG_START,onTmpFeaturedragStart);
				this.layer.map.addEventListener(FeatureEvent.TMP_FEATURE_DRAG_STOP,onTmpFeaturedragStop);
				//We stop the Timer if it's not null
				if(this._tmpVerticesTimer!=null) 
				{
					this._tmpVerticesTimer.stop();
					this._tmpVerticesTimer.removeEventListener(TimerEvent.TIMER,deleteTmpVertices);
					this._tmpVerticesTimer=null;
				}						
				super.verticesShowing(pevt);
				var tmpVertic:TmpPointFeature;
				for each( tmpVertic in this.tmpVertices){
					(this.layer as VectorLayer).removeFeature(tmpVertic);
				}
				this._tmpVertices=new Array();
				this.createTmpVertices(this.geometry as Collection);
			
			//We ad the new temporaries vertices to the layer 
				for each( tmpVertic in this.tmpVertices){
					(this.layer as VectorLayer).addFeature(tmpVertic);
				}
				this.addEventListener(MouseEvent.MOUSE_MOVE,createVerticesUnderMouse);
			
			//}
			
			}*/
		}
		
		override protected function verticesHiding(pevt:MouseEvent):void{
		 	//when  a tmpVertices is dragged the mousout event is dispatched
		 	//but we don't want the deleting of vertices in this case
		/*  if((this.layer as VectorLayer).tmpVerticesOnFeature){
		 		this.createVerticesUnderMouse(pevt);
		 		this._tmpVerticesTimer=new Timer(_tmpTimerValue,1);
		 		this._tmpVerticesTimer.addEventListener(TimerEvent.TIMER_COMPLETE,deleteTmpVertices);
		 		this._tmpVerticesTimer.start();
		 	}*/
		 }
		/**
		 * This function is used to delete the temporaries vertices
		 * when the time between 2 Mousehover  is finished
		 * */
		public function deleteTmpVertices(pevt:TimerEvent):void
		{
			this.layer.map.buttonMode=false;
			for each(var feature:TmpPointFeature in this.tmpVertices){
		 		(this.layer as VectorLayer).removeFeature(feature); 	
		 	}
		 	(this.layer as VectorLayer).removeFeature(this._tmpVerticeUnderTheMouse);
		 	this.tmpVertices.pop();
		 	
		}
		
		public function get tmpVertices():Array{
			return this._tmpVertices;
		}
		
		public function set tmpVertices(value:Array):void{
			this._tmpVertices=value;
		}
		
		public function get tmpVerticeTolerance():Number{
			return this._tmpVerticeTolerance;	
		}
		public function set tmpVerticeTolerance(tolerance:Number):void{
			this._tmpVerticeTolerance=tolerance;
		}
		
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
		 	this._isEditable=isEditable;
		 }
		 /**
		 * To know if the vector feature  is a temporary vector only used 
		 * for edition mode
		 **/
		 public function get isEditionFeature():Boolean{
		 	return this._isEditionFeature;
		 }
		 /**
		 * the geometry of the parent when the feature is an edition feature  
		 **/
		public function get editionFeatureParentGeometry():Collection{
			return this._editionFeatureParentGeometry;
		}
	}
}

