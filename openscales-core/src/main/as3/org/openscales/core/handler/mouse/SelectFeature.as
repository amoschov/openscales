package org.openscales.core.handler.mouse
{
	import flash.utils.getQualifiedClassName;

	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.Style;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.handler.Handler;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.feature.VectorFeature;

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

		private var _ctrl:Boolean=false;

		/**
		 * Array witch keep all selectFeature using ctrl key
		 */
		private var _selectFeatures:Array = new Array();

		/**
		 * real number of feature in the tab. We don't use lenght, because selectFeatures maybe contain null.
		 */
		private var _selectFeauturesLength:int = 0;	

		/**
		 * iterator for selectFeature (in the tab "selectFeatures")
		 */
		private var _iteratorFeatures:Number = 0;

		/**
		 * The style for selected feature (you can change its color)
		 */
		private var _selectStyle:Style = new Style(); 

		private var _layer:VectorLayer;
		private var _lastfeature:Feature=null;
		private var _currentfeature:VectorFeature=null;


		//Accept hover or not
		private var _hover:Boolean=true;

		private var _startPixel:Pixel=null;

		public function SelectFeature(map:Map=null,layer:VectorLayer=null,active:Boolean=false)
		{
			super(map,active);
			this.layer=layer;

			this.selectStyle.fillColor = 0xFFD700;
			this.selectStyle.strokeColor = 0xFFD700;
		}

		override protected function registerListeners():void{
			if(map!=null){
				this.map.addEventListener(FeatureEvent.FEATURE_OVER,this.OnOver);
				this.map.addEventListener(FeatureEvent.FEATURE_OUT,this.OnOut);
				this.map.addEventListener(FeatureEvent.FEATURE_CLICK,this.OnClick);
				/* this.map.addEventListener(FeatureEvent.FEATURE_MOUSEDOWN, this.onMouseDown);
		 		this.map.addEventListener(FeatureEvent.FEATURE_MOUSEUP, this.onMouseUp); */	
			}
		}
		
		override protected function unregisterListeners():void{
			if(map!=null){		
				this.map.removeEventListener(FeatureEvent.FEATURE_OVER,this.OnOver);
				this.map.removeEventListener(FeatureEvent.FEATURE_OUT,this.OnOut);			
				this.map.removeEventListener(FeatureEvent.FEATURE_CLICK,this.OnClick);
				/* this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEDOWN, this.onMouseDown);
		 		this.map.removeEventListener(FeatureEvent.FEATURE_MOUSEUP, this.onMouseUp); */
		 	}
		}

		public function OnOut(pevt:FeatureEvent):void{
			if(pevt.feature.layer==this.layer)
			{
				if(this._unselect!=null)this._unselect(pevt);
			}
		}
		public function OnOver(pevt:FeatureEvent):void{
			if(hover)
			{
				if(pevt.feature.layer==this.layer)
				{
					if(this._select!=null) this._select(pevt);
				}
			}
		}

		public function OnClick(pevt:FeatureEvent):void{			
			if(!this.hover)
			{
				if(this._select!=null)this._select(pevt);
			}
		}

		public function OnSelection():void{
			var i:Number = 0;	// to iterate
			var f:VectorFeature;

			if(selectFeatures == null){selectFeatures = new Array();} 

			//It's not the first selection
			if(lastfeature != null){		
				//Feature is not already selected
				if(!currentfeature.selected){
					//ctrl key isn't pressed
					if(!ctrl){
						selectFeauturesLength=0;
						for each(f in selectFeatures){
							if(f != null){
								if(f.selected){f.style = f.originalStyle;f.selected=false;f.layer.redraw();selectFeatures=null;selectFeatures = new Array(currentfeature);}
							}							
						}
						iteratorFeatures=0;
					}
					//ctrl key is pressed
					else{iteratorFeatures++;}
					selectFeauturesLength++;
					ChangeToSelected();
				}
				//Feature is already selected
				else{
					//ctrl key isn't pressed
					if(!ctrl){
						selectFeauturesLength=1;
						var others:Boolean = false;
						for(i=0;i<=selectFeatures.length;i++){
							f=selectFeatures[i];
							if(f!=null && f.selected && f!=currentfeature){others=true;f.selected = false;f.style = f.originalStyle;f.layer.redraw();selectFeatures[i]=null;}
						}			
						if(!others){
							currentfeature.style = currentfeature.originalStyle;												 
							currentfeature.selected = false;
							selectFeatures[iteratorFeatures]= null;
							lastfeature = null;
							currentfeature.layer.redraw();						
							/* btnDeleteSelected.enabled = false; */			

							selectFeauturesLength--;					
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
						selectFeauturesLength--;
					}
					//clear the information tab
					this.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_UNSELECTED, this.currentfeature));								
				}
			}
			//This is the first selection
			else{selectFeauturesLength++;this.ChangeToSelected();}
		/* else{isDragging=false;} */
		}

		/**
		 * Change the current feature with the select style. The feature is now selected,
		 * placed in the tab of selected features and the current is copy to the last.
		 */		
		private function ChangeToSelected():void{
			this.currentfeature.originalStyle=this.currentfeature.style;					
			this.currentfeature.style = selectStyle;							 
			this.currentfeature.selected = true;
			this.selectFeatures[iteratorFeatures]=this.currentfeature;						
			this.currentfeature.layer.redraw();  
			this.lastfeature = this.currentfeature;
			this.layer.map.dispatchEvent(new FeatureEvent(FeatureEvent.FEATURE_SELECTED,this.currentfeature));
		}

		/**
		 * determine if the merge button can be enabled or not.
		 * return boolean
		 */
		public function Comparison():Boolean{
			var rep:Boolean = false;
			if(selectFeauturesLength >= 2) 
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
						if(((((getQualifiedClassName((selectFeatures[k] as VectorFeature).geometry) == "org.openscales.core.geometry::Point") || (getQualifiedClassName((selectFeatures[k] as VectorFeature).geometry) == "org.openscales.core.geometry::MultiPoint")) && ((getQualifiedClassName((selectFeatures[k-l] as VectorFeature).geometry) == "org.openscales.core.geometry::Point") ||(getQualifiedClassName((selectFeatures[k-l] as VectorFeature).geometry) == "org.openscales.core.geometry::MultiPoint")))))
						{
							rep = true;
						}
						else if(((((getQualifiedClassName((selectFeatures[k] as VectorFeature).geometry) == "org.openscales.core.geometry::LineString") || (getQualifiedClassName((selectFeatures[k] as VectorFeature).geometry) == "org.openscales.core.geometry::MultiLineString")) && ((getQualifiedClassName((selectFeatures[k-l] as VectorFeature).geometry) == "org.openscales.core.geometry::LineString") ||(getQualifiedClassName((selectFeatures[k-l] as VectorFeature).geometry) == "org.openscales.core.geometry::MultiLineString")))))
						{
							rep = true;
						}
						else if(((((getQualifiedClassName((selectFeatures[k] as VectorFeature).geometry) == "org.openscales.core.geometry::Polygon") || (getQualifiedClassName((selectFeatures[k] as VectorFeature).geometry) == "org.openscales.core.geometry::MultiPolygon")) && ((getQualifiedClassName((selectFeatures[k-l] as VectorFeature).geometry) == "org.openscales.core.geometry::Polygon") ||(getQualifiedClassName((selectFeatures[k-l] as VectorFeature).geometry) == "org.openscales.core.geometry::MultiPolygon")))))
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

		public function get selectStyle():Style{
			return _selectStyle;
		}
		public function set selectStyle(newStyle:Style):void{
			_selectStyle = newStyle;
		}

		public function get selectFeatures():Array{
			return _selectFeatures;
		}
		public function set selectFeatures(newArray:Array):void{
			_selectFeatures = newArray;
		}

		public function get selectFeauturesLength():Number{
			return _selectFeauturesLength;
		}
		public function set selectFeauturesLength(value:Number):void{
			_selectFeauturesLength = value;
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

