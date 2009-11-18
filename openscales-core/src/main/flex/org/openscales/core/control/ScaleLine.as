package org.openscales.core.control
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.openscales.core.Map;
	import org.openscales.core.Trace;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Unit;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.events.MapEvent;

	/**
	 * The scaleLine
	 * Calcul and display an approximate scale of the current baselayer.
	 */	
	public class ScaleLine extends Control
	{
		/**
		 * Maximum width of the scale line in pixels.  Default is 100.
		 */
		private var _scaleMaxWidth:Number = 100;

		/**
		 * Units for zoomed out on top bar.  Default is km.
		 */
		private var _topOutUnits:String = "km";

		/**
		 * Units for zoomed in on top bar.  Default is m.
		 */
		private var _topInUnits:String = "m";

		/**
		 * Units for zoomed out on bottom bar.  Default is mi.
		 */
		private var _bottomOutUnits:String = "mi";

		/**
		 * Units for zoomed in on bottom bar.  Default is ft.
		 */
		private var _bottomInUnits:String = "ft";
		
		/**
		 * Label wich display the distance in miles, or feet represented by the scaleLine.
		 */
		private var _labelMiles:TextField = null;
		
		/**
		 * Label wich display the distance in kilometers, or meters represented by the scaleLine.
		 */
		private var _labelKm:TextField = null;
		
		/**
		 * Color of the text in labels. Default is grey (0x666666)
		 */
		private var _color:int = 0x666666;
			
		/**
		 * Size (or lenght) in pixel of the scaleLine, just before drawing (and after calculating size)
		 */
		private var _topPx:Number;

		/**
		 * Constructor
		 * 
		 */
		public function ScaleLine(position:Pixel=null){
			super(position);
		}

		/**
		 * Get the existing map and add event listener on event Zoom end and baseLayer change.
		 *
		 * @param value
		 */
		override public function set map(value:Map):void {
			if(value != null) {
				this._map=value;	      	
				this.map.addEventListener(MapEvent.ZOOM_END,updateScaleLine);
				this.map.addEventListener(LayerEvent.BASE_LAYER_CHANGED,updateScaleLine);
			}
		}

		override public function draw():void{
			super.draw();
			this.updateScale();
		}
		
		/**
		 * Redraw the scaleline with new parameters.
		 * 
		 * @param event the event can be a MapEvent.ZOOM_END or LayerEvent.BASE_LAYER_CHANGED.
		 */
		public function updateScaleLine(event:Event):void {
			this.draw()
		}

		/**
		 * Given a number, round it down to the nearest 1,2,5 times a power of 10.
		 * That seems a fairly useful set of number groups to use.
		 *
		 * @param maxLen the number we're rounding down from
		 *
		 * @return the rounded number (less than or equal to maxLen)
		 */
		private function getBarLen(maxLen:Number):Number 
		{
			// nearest power of 10 lower than maxLen
			var digits:Number = int(Math.log(maxLen) / Math.log(10));
			var pow10:Number = Math.pow(10, digits);

			// ok, find first character
			var firstChar:Number = int(maxLen / pow10);

			// right, put it into the correct bracket
			var barLen:Number;
			if(firstChar > 5) {
				barLen = 5;
			} else if(firstChar > 2) {
				barLen = 2;
			} else {
				barLen = 1;
			}

			// scale it up the correct power of 10
			return barLen * pow10;
		}

		/**
		 * Update the size of the bars, and the labels which contains.
		 */
		 private function updateScale():void
		{
			// Get the resolution of the map
			var mapResolution:Number = this.map.resolution;
			
			// Map has no resolution, return.
			if (!mapResolution) {return;}

			// get the current units of the map
			/* var currentBaseLayerUnits:String = this.map.units; */
			var currentBaseLayerUnits:String = this.map.baseLayer.projection.projParams.units;

			// convert the scaleMaxWidth to map units
			// The result is the max distance IN MAP UNIT, represent in the scaleline
			var maxSizeData:Number = this._scaleMaxWidth * mapResolution * Unit.getInchesPerUnit(currentBaseLayerUnits);

			// decide whether to use large or small scale units. it's independent of the map unit    
			var topUnits:String;		
			var bottomUnits:String;	
			if(maxSizeData > 100000) {
				topUnits = this.topOutUnits;
				bottomUnits = this._bottomOutUnits;
			} else {
				topUnits = this.topInUnits;
				bottomUnits = this._bottomInUnits;
			}

			// and to map units units
			var topMax:Number = maxSizeData / Unit.getInchesPerUnit(topUnits);
			var bottomMax:Number = maxSizeData / Unit.getInchesPerUnit(bottomUnits);

			// now trim this down to useful block length
			
			var topRounded:Number = this.getBarLen(topMax);
			var bottomRounded:Number = this.getBarLen(bottomMax);

			// and back to display units
			topMax = topRounded / Unit.getInchesPerUnit(currentBaseLayerUnits) * Unit.getInchesPerUnit(topUnits);
			bottomMax = bottomRounded / Unit.getInchesPerUnit(currentBaseLayerUnits) * Unit.getInchesPerUnit(bottomUnits);
	
			// and to pixel units
			_topPx = topMax / mapResolution;
			var bottomPx:Number = bottomMax / mapResolution;
			
			this.graphics.clear();
			this.graphics.beginFill(this._color);

			// Draw the ScaleLine
			 if(Math.round(bottomPx)>Math.round(topPx)){
				this.graphics.drawRect(10,50,Math.round(bottomPx),2);
				this.graphics.drawRect(10+Math.round(topPx),+32,1,18);
				this.graphics.drawRect(10+Math.round(bottomPx),+50,1,20);
			}
			else{
				this.graphics.drawRect(10,50,Math.round(topPx),2);  	
				this.graphics.drawRect(10+Math.round(topPx),+32,1,20);
				this.graphics.drawRect(10+Math.round(bottomPx),+52,1,18);
			}

			this.graphics.drawRect(10,32,1,20);
			this.graphics.drawRect(10,50,1,20); 
			this.graphics.endFill(); 
			
			labelMiles = new TextField();
			labelMiles.text = bottomRounded + " " + bottomUnits ;
			labelMiles.x=13;
			labelMiles.y=55;

			labelKm = new TextField();
			labelKm.text = topRounded + " " + topUnits ;
			labelKm.x=13;
			labelKm.y=35;

			var labelFormat:TextFormat = new TextFormat();
			labelFormat.size = 11;
			labelFormat.color = this._color;
			labelFormat.font = "Verdana";

			this.labelKm.setTextFormat(labelFormat);
			this.labelMiles.setTextFormat(labelFormat);
			this.addChild(labelMiles);
			this.addChild(labelKm);

			//Calcul scale
			/* var sizeCM:Number = (topPx)/((this.parentApplication.height)*(this.parentApplication.width))*2.54;
			 var scaleD:Number; */
	
				 //Show the scale 1/xxxxx
			/* if(labelScaleKm != null)
			   {
			   idScaleLine.removeChild(labelScaleKm);
			   }
			   labelScaleKm = new Label();
			   labelScaleKm.text = "1/"+Math.round(scaleD).toString();
			   labelScaleKm.x = this.position.x;
			   labelScaleKm.y = 0;
			 this.idScaleLine.addChild(labelScaleKm);*/
		}

		// GETTERS AND SETTERS
		
		public function get color():int {
			return this._color;
		}
		public function set color(value:int):void {
			this._color = value;
		}
		
		public function get labelKm():TextField {
			return _labelKm;
		}
		public function set labelKm(value:TextField):void {
			_labelKm = value;
		}
		
		public function get labelMiles():TextField {
			return _labelMiles;
		}
		public function set labelMiles(value:TextField):void {
			_labelMiles = value;
		}
		
		public function get topPx():Number {
			return _topPx;
		}
		public function set topPx(value:Number):void {
			_topPx = value;
		}
		
		public function get scaleMaxWidth():Number {
			return _scaleMaxWidth;
		}
		public function set scaleMaxWidth(value:Number):void {
			_scaleMaxWidth = value;
		}
		
		public function get topOutUnits():String {
			return _topOutUnits;
		}
		public function set topOutUnits(value:String):void {
			_topOutUnits = value;
		}
		
		public function get topInUnits():String {
			return _topInUnits;
		}
		public function set topInUnits(value:String):void {
			_topInUnits = value;
		}
		
		public function get bottomOutUnits():String {
			return _bottomOutUnits;
		}
		public function set bottomOutUnits(value:String):void {
			_bottomOutUnits = value;
		}
		
		public function get bottomInUnits():String {
			return _bottomInUnits;
		}
		public function set bottomInUnits(value:String):void {
			_bottomInUnits = value;
		}
	}
}

