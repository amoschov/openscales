package org.openscales.core.control
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Unit;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.events.MapEvent;

	public class ScaleLine extends Control
	{
		/**
		 * @param Maximum width of the scale line in pixels.  Default is 100.
		 */
		private var scaleMaxWidth:int = 200;

		/**
		 * @param Units for zoomed out on top bar.  Default is km.
		 */
		private var topOutUnits:String = "km";

		/**
		 * @param Units for zoomed in on top bar.  Default is m.
		 */
		private var topInUnits:String = "m";

		/**
		 * @param Units for zoomed out on bottom bar.  Default is mi.
		 */
		private var bottomOutUnits:String = "mi";

		/**
		 * @param Units for zoomed in on bottom bar.  Default is ft.
		 */
		private var bottomInUnits:String = "ft";
		private var labelMiles:TextField = null;
		private var labelKm:TextField = null;
		private var _color:int = 0x666666;

		public function ScaleLine(position:Pixel=null){
			super(position);
		}

		/**
		 * Get the existing map
		 *
		 * @param value
		 */
		override public function set map(value:Map):void {
			if(value != null)
			{
				this._map=value;	      	
				this.map.addEventListener(MapEvent.ZOOM_END,updateScaleLine);
				this.map.addEventListener(LayerEvent.BASE_LAYER_CHANGED,updateScaleLine);
			}
		}

		override public function draw():void{
			super.draw();
			this.updateScale();
		}

		public function updateScaleLine(event:Event):void {
			this.draw()
		}

		/**
		 * Method: getBarLen
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
			var digits:Number = parseInt((Math.log(maxLen) / Math.log(10)).toString());
			var pow10:Number = Math.pow(10, digits);

			// ok, find first character
			var firstChar:Number = parseInt((maxLen / pow10).toString());

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
		 * Method: update
		 * Update the size of the bars, and the labels they contain.
		 */
		private function updateScale():void
		{
			var res:Number = this.map.resolution;
			if (!res) {
				return;
			}

			var curMapUnits:String = this.map.units;

			// convert scaleMaxWidth to map units
			var maxSizeData:Number = this.scaleMaxWidth * res * Unit.getInchesPerUnit(curMapUnits);  

			// decide whether to use large or small scale units     
			var topUnits:String;
			var bottomUnits:String;
			if(maxSizeData > 100000) {
				topUnits = this.topOutUnits;
				bottomUnits = this.bottomOutUnits;
			} else {
				topUnits = this.topInUnits;
				bottomUnits = this.bottomInUnits;
			}

			// and to map units units
			var topMax:Number = maxSizeData / Unit.getInchesPerUnit(topUnits);
			var bottomMax:Number = maxSizeData / Unit.getInchesPerUnit(bottomUnits);

			// now trim this down to useful block length
			var topRounded:Number = this.getBarLen(topMax);
			var bottomRounded:Number = this.getBarLen(bottomMax);

			// and back to display units
			topMax = topRounded / Unit.getInchesPerUnit(curMapUnits) * Unit.getInchesPerUnit(topUnits);
			bottomMax = bottomRounded / Unit.getInchesPerUnit(curMapUnits) * Unit.getInchesPerUnit(bottomUnits);

			// and to pixel units
			var topPx:Number = topMax / res;
			var bottomPx:Number = bottomMax / res;

			this.graphics.clear();
			this.graphics.beginFill(this._color);

			//Draw the ScaleLine
			if(Math.round(bottomPx)>Math.round(topPx))
			{
				this.graphics.drawRect(10,50,Math.round(bottomPx),2);
				this.graphics.drawRect(10+Math.round(topPx),+32,1,18);
				this.graphics.drawRect(10+Math.round(bottomPx),+50,1,20);
			}
			else
			{
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
		 this.idScaleLine.addChild(labelScaleKm); */
		}

		public function get color():int {
			return this._color;
		}
		public function set color(value:int):void {
			this._color = value;
		}

	}
}

