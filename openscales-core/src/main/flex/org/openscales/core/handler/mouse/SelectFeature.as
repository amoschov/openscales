package org.openscales.core.handler.mouse
{
	import flash.utils.getQualifiedClassName;
	
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.MultiPointFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.VectorFeature;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.Fill;
	import org.openscales.core.style.symbolizer.Mark;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.PolygonSymbolizer;
	import org.openscales.core.style.symbolizer.Stroke;

	/**
	 *
	 * SelectFeature is use to select feature by hover
	 * Create a new instance of  SelectFeature with the constructor
	 *
	 * To use this handler, it's  necessary to add it to the map
	 * SelectFeature is a pure ActionScript class. Flex wrapper and components can be found in the
	 * openscales-fx module FxSelectFeature.
	 */
	public class SelectFeature extends Handler
	{
		/**
		 * Callback's function
		 */
		private var _select:Function=null;
		private var _unselect:Function=null;
		private var _selectBySelectBox:Function=null;
		
		/**
		 * Array of feature wich contain all feature to select. Most of time, it contains only one feature
		 * but because of the selectBox, sometimes there are several features to select.
		 */
		private var _featureToSelect:Array=null;
		
		/**
		 * ctrl status. Indicate if the user pressed the ctrl key
		 */
		private var _ctrl:Boolean=false;

		/**
		 * Array witch keep all selectFeature using ctrl key
		 */
		private var _selectFeatures:Array = new Array();

		/**
		 * real number of feature in the array. We don't use lenght, because selectFeatures maybe contain null.
		 */
		private var _selectFeaturesLength:int = 0;	

		/**
		 * iterator for selectFeature (in the array "selectFeatures")
		 */
		private var _iteratorFeatures:Number = 0;
		
		/**
		 * The layer wich contain our features
		 */
		private var _layer:VectorLayer;
		
		/**
		 * To prevent duplicate points
		 */
		private var _lastfeature:Feature=null;
		
		
		private var _currentfeature:VectorFeature=null;

		//Accept hover or not
		private var _hover:Boolean=false;

		/* private var _startPixel:Pixel=null; */

		public function SelectFeature(map:Map=null,layer:VectorLayer=null,active:Boolean=false)
		{
			super(map,active);
			this.layer=layer;
		}

		override protected function registerListeners():void{
			if(map!=null){
				this.map.addEventListener(FeatureEvent.FEATURE_OVER,this.onOver);
				this.map.addEventListener(FeatureEvent.FEATURE_OUT,this.onOut);
				this.map.addEventListener(FeatureEvent.FEATURE_CLICK,this.onClick);
				this.map.addEventListener(FeatureEvent.FEATURE_SELECTED,this.onSelectBySelectBox);
			}
		}
		
		override protected function unregisterListeners():void{
			if(map!=null){		
				this.map.removeEventListener(FeatureEvent.FEATURE_OVER,this.onOver);
				this.map.removeEventListener(FeatureEvent.FEATURE_OUT,this.onOut);			
				this.map.removeEventListener(FeatureEvent.FEATURE_CLICK,this.onClick);
				this.map.removeEventListener(FeatureEvent.FEATURE_SELECTED,this.onSelectBySelectBox);
		 	}
		}

		public function onOut(pevt:FeatureEvent):void{
			if(pevt.features[0].layer==this.layer)
			{
				if(this._unselect!=null)this._unselect(pevt);
			}
		}
		public function onOver(pevt:FeatureEvent):void{
			if(hover)
			{
				if(pevt.features[0].layer==this.layer)
				{
					if(this._select!=null) this._select(pevt);
				}
			}
		}

		public function onClick(pevt:FeatureEvent):void{			
			if(!this.hover){
				this._ctrl = pevt.ctrlPressed;
				this.currentfeature = pevt.features[0] as VectorFeature;
				
				if(this._select!=null) {
					this._select(pevt);
				} else {
					onSelection();
				}
			}
		}
		
		public function onSelectBySelectBox(pevt:FeatureEvent):void{
Trace.debug("onSelectBySelectBox "+pevt.features.length);
			if(!this.hover){
				this._ctrl = pevt.ctrlPressed;
				this._featureToSelect = pevt.features;

				this.currentfeature = pevt.features[0] as VectorFeature;
				
				if(this._selectBySelectBox!=null) {
					this._selectBySelectBox(pevt);
				} else { 
					onSelectionBySelectBox();
				}				
			}
		}
		
		public function test():void
		{
			var f:VectorFeature, f1:VectorFeature;
			if(!ctrl)
			{
				for(var i:int=0;i<selectFeatures.length;i++)
				{
					f=selectFeatures[i];
					if(f != null){
						if(f.selected){
							//we check if the feature is not in the selection area
							var find:Boolean=false;
							for each (f1 in _featureToSelect){
								if(f == f1){find=true;break;}
							}
							//if the features is not in the area, we deselect it.
							if(!find){
								f.style = f.originalStyle;
								f.selected=false;
								f.layer.redraw();
								selectFeatures[i]=null;
								iteratorFeatures--; 
								selectFeaturesLength--;
							}
						}
					}
				}
			}
			for(var k:int=0;k<this._featureToSelect.length;k++)
			{
					selectFeatures.push(_featureToSelect[k]);
			}
		}
		
		public function onSelectionBySelectBox():void{			
			var f:VectorFeature;
			// If ctrl key isn't pressed, first unselect all the currently
			// selected features that are not reselected
			if (! ctrl) {
				var f1:VectorFeature;
				var found:Boolean = false;
				var layersToRedraw:Array = new Array();
				var i:int, j:int;
				for(i=0; i<selectFeatures.length; i++) {
					f = selectFeatures[i];
					if ((f != null) && f.selected) { // FixMe: It should not be possible that a selectFeature is null or not selected !
						// Check if the feature is reselected in the new area
						found = false;
						for each (f1 in _featureToSelect) {
							if (f == f1) {
								found = true;
								break;
							}
						}
						// If the feature is not in the area, unselect it.
						if (! found){
							selectFeatures[i] = null;
							iteratorFeatures--; 
							selectFeaturesLength--;
							f.style = f.originalStyle;
							f.selected = false;
							// Add the layer of the feature to the array of the
							// layers to redraw (if necessary)
							found = false;
							for (j=0; (!found) && (i<layersToRedraw.length); j++) {
								if (layersToRedraw[j].name == f.layer.name) {
									found = true;
								}
							}
							if (! found) {
								layersToRedraw.push(f.layer.name);
							}
						}
					}
				}
				// Redraw all the layers that have almost one feature unselected
				for(i=0; i<layersToRedraw.length; i++) {
					this.map.getLayerByName(layersToRedraw[j]).redraw();
				}
			}
			
			// Add all the new selected features in the global selection
			var featureIterator:VectorFeature;
			for each (f in _featureToSelect) {
				currentfeature = f;
				if (! currentfeature.selected) {
					iteratorFeatures++;
					selectFeaturesLength++;
					changeToSelected();
				}
			}
var sfList:String=""; for each (f in selectFeatures) { sfList += ((f) ? f.name : "null") + ", "; }
Trace.debug("onSelectionBySelectBox - ctrl="+ctrl+" => "+sfList);
		}

		public function onSelection():void{
			var i:Number = 0;	// to iterate
			var f:VectorFeature;

			if(selectFeatures == null){selectFeatures = new Array();} 

			//It's not the first selection
			if(lastfeature != null){		
				//Feature is not already selected
				if(!currentfeature.selected){
					//ctrl key isn't pressed
					if(!ctrl){
						selectFeaturesLength=0;
						for each(f in selectFeatures){
							if(f != null){
								if(f.selected){
									f.style = f.originalStyle;
									f.selected=false;
									f.layer.redraw();
									 selectFeatures=null;
									selectFeatures = new Array(currentfeature); 
								}
							}							
						}
						iteratorFeatures=0;
					}
					//ctrl key is pressed
					else{iteratorFeatures++;}
					selectFeaturesLength++;
					changeToSelected();
				}
				//Feature is already selected
				else{
					//ctrl key isn't pressed
					if(!ctrl){
						selectFeaturesLength=1;
						var others:Boolean = false;
						for(i=0;i<=selectFeatures.length;i++){
							f=selectFeatures[i];
							if(f!=null && f.selected && f!=currentfeature){
								others=true;
								f.selected = false;
								f.style = f.originalStyle;
								f.layer.redraw();
								selectFeatures[i]=null;
							}
						}			
						if(!others){
							currentfeature.style = currentfeature.originalStyle;												 
							currentfeature.selected = false;
							selectFeatures[iteratorFeatures]= null;
							lastfeature = null;
							currentfeature.layer.redraw();
							selectFeaturesLength--;
							this.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_UNSELECTED, this.currentfeature,ctrl));					
						}
						else{
							this.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_SELECTED, this.currentfeature,ctrl));
						}				
					}							
					//ctrl key is pressed
					else{
						currentfeature.style = currentfeature.originalStyle;												 
						currentfeature.selected = false;
						for(i;i<selectFeatures.length;i++){
							f=selectFeatures[i];
							if(f == currentfeature){selectFeatures[i]=null;}
						}
						currentfeature.layer.redraw();
						selectFeaturesLength--;
						
						//clear the information array
						this.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_UNSELECTED, this.currentfeature));
						
					}
				}
			}
			//This is the first selection
			else{selectFeaturesLength++; this.changeToSelected(); }
		}

		/**
		 * Change the current feature with the select style. The feature is now selected,
		 * placed in the array of selected features and the current is copy to the last.
		 */		
		public function changeToSelected():void{			
Trace.debug("changeToSelected "+this.currentfeature.name);
			this.currentfeature.originalStyle=this.currentfeature.style;
			
			// Little test to see if the style to be created should be a point style or a polygon style
			// Anyway, this should not be here but either to an external class or in a specific method for managing display of selected features 
			
			var selectStyle:Style= Style.getDefaultPointStyle();
			/* var selectStyle:Style =  new Style(); */
			 selectStyle.rules[0] = new Rule();
			if(this.currentfeature is PointFeature || this.currentfeature is MultiPointFeature){					
				selectStyle.rules[0].symbolizers.push(new PointSymbolizer(new Mark(Mark.WKN_SQUARE,new Fill(0xFFD700,0.5),new Stroke(0xFFD700,2),12)));
			}
			else{
				selectStyle.rules[0].symbolizers.push(new PolygonSymbolizer(new Fill(0xFFD700,0.5),new Stroke(0xFFD700,2)));
			} 

			this.currentfeature.style = selectStyle;							 
			this.currentfeature.selected = true;
			this.selectFeatures[iteratorFeatures]=this.currentfeature;						
			this.currentfeature.layer.redraw();  
			this.lastfeature = this.currentfeature;
			//this.currentfeature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_SELECTED,this.currentfeature,ctrl));
			this.currentfeature.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_SHOW_INFORMATIONS,this.currentfeature));
		}

		/**
		 * determine if the merge button can be enabled or not.
		 * return boolean
		 */
		public function Comparison():Boolean{
			var rep:Boolean = false;
			if(selectFeaturesLength >= 2) 
			{
				for(var k:int=0;k<selectFeatures.length;k++)
				{
					var l:int = 1;
					if(selectFeatures[k] != null)
					{
						while(selectFeatures[k-l] == null)
						{
							if((k-l) <= 0){l = 0;}
							else{l++;}
						}
						if(((((getQualifiedClassName((selectFeatures[k] as VectorFeature).geometry) == "org.openscales.core.geometry::Point") || 
								(getQualifiedClassName((selectFeatures[k] as VectorFeature).geometry) == "org.openscales.core.geometry::MultiPoint")) && ((getQualifiedClassName((selectFeatures[k-l] as VectorFeature).geometry) == "org.openscales.core.geometry::Point") ||
									(getQualifiedClassName((selectFeatures[k-l] as VectorFeature).geometry) == "org.openscales.core.geometry::MultiPoint")))))
						{
							rep = true;
						}
						else if(((((getQualifiedClassName((selectFeatures[k] as VectorFeature).geometry) == "org.openscales.core.geometry::LineString") ||
						 	(getQualifiedClassName((selectFeatures[k] as VectorFeature).geometry) == "org.openscales.core.geometry::MultiLineString")) && ((getQualifiedClassName((selectFeatures[k-l] as VectorFeature).geometry) == "org.openscales.core.geometry::LineString") ||
						 		(getQualifiedClassName((selectFeatures[k-l] as VectorFeature).geometry) == "org.openscales.core.geometry::MultiLineString")))))
						{
							rep = true;
						}
						else if(((((getQualifiedClassName((selectFeatures[k] as VectorFeature).geometry) == "org.openscales.core.geometry::Polygon") || 
							(getQualifiedClassName((selectFeatures[k] as VectorFeature).geometry) == "org.openscales.core.geometry::MultiPolygon")) && ((getQualifiedClassName((selectFeatures[k-l] as VectorFeature).geometry) == "org.openscales.core.geometry::Polygon")  ||
								(getQualifiedClassName((selectFeatures[k-l] as VectorFeature).geometry) == "org.openscales.core.geometry::MultiPolygon")) )))
						{
							rep = true;
						}
						else
						{
							return false;
						}
					}
				}

			}
			else{rep = false;}
			return rep;
		}

		// There is a problem with the function, so we rollback to the old version of selection (with Onclick)

		/* public function onMouseUp(pevt:FeatureEvent):void
		   {
		   if(!this.hover)
		   {
		   if((this._startPixel.x-pevt.vectorfeature.layer.mouseX==0)&&(this._startPixel.y-pevt.vectorfeature.layer.mouseY==0))
		   {
		   if(this._select!=null)this._select(pevt);
		   }
		   }
		   }
		   public function onMouseDown(pevt:FeatureEvent):void
		   {
		   if(!this.hover)
		   {
		   this._startPixel=new Pixel(pevt.vectorfeature.layer.mouseX,pevt.vectorfeature.layer.mouseY);
		   if(this._unselect!=null)this._unselect(pevt);
		   }
		 } */


		//Properties
		public function  get select():Function{
			return this._select;
		}
		public function set select(select:Function):void{
			this._select=select; 
		}

		public function  get unselect():Function{
			return this._unselect;
		}
		public function set unselect(unselect:Function):void{
			this._unselect=unselect;
		}
		
		public function get selectBySelectBox():Function{
			return this._selectBySelectBox;
		}
		public function set selectBySelectBox(selectBySelectBox:Function):void{
			this._selectBySelectBox=selectBySelectBox;
		}
		
		public function  get layer():VectorLayer
		{
			return this._layer;
		}
		public function set layer(layer:VectorLayer):void
		{
			this._layer=layer;
		}

		public function  get hover():Boolean
		{
			return this._hover;
		}
		public function set hover(hover:Boolean):void
		{
			this._hover=hover;
		}

		public function  get lastfeature():Feature
		{
			return this._lastfeature;
		}
		public function set lastfeature(lastfeature:Feature):void
		{
			this._lastfeature=lastfeature;
		}

		public function  get currentfeature():VectorFeature
		{
			return this._currentfeature;
		}

		public function set currentfeature(currentfeature:VectorFeature):void
		{
			this._currentfeature=currentfeature;
		}

		public function get selectFeatures():Array{
			return _selectFeatures;
		}
		public function set selectFeatures(newArray:Array):void{
			_selectFeatures = newArray;
		}

		public function get selectFeaturesLength():Number{
			return _selectFeaturesLength;
		}
		public function set selectFeaturesLength(value:Number):void{
			_selectFeaturesLength = value;
		}

		public function get iteratorFeatures():Number{
			return _iteratorFeatures;
		}
		public function set iteratorFeatures(value:Number):void{
			_iteratorFeatures = value;
		}

		public function get ctrl():Boolean{
			return _ctrl;
		}
		public function set ctrl(value:Boolean):void{
			_ctrl = value;
		} 		
	}
}

