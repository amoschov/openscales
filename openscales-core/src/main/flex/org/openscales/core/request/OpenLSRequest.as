package org.openscales.core.request
{
	import com.adobe.serialization.json.JSON;
	
	import org.openscales.core.Trace;
	
	/**
	 * OpenLSRequest
	 */
	public class OpenLSRequest extends XMLRequest
	{
		private var _dataFile:String = "";
		private var _streetOrPOI:String = "";
		private var _postalCode:String = "";
		private var _city:String = "";
		
		private var _isValidPostalCode:Function = null;
		
		/**
		 * @constructor
		 * 
		 * For the onComplete function, the result of the OpenLS request is
		 * obtained like this:
		 * var result:XML = new XML((event.target as URLLoader).data);
		 */
		public function OpenLSRequest(url:String, onComplete:Function, onFailure:Function=null) {
			super(url, onComplete, onFailure);
			this.postContentType = "text/plain";
		}
		
		/**
		 * Getter and setter of the data file to use for the request.
		 */
		public function get dataFile():String {
			return this._dataFile;
		}
		public function set dataFile(value:String):void {
			this._dataFile = value;
			// Update the content of the request
			this.postContent = this.createContent();
		}
		
		/**
		 * Getter and setter of the street (number and name) or the POI (name) of the request.
		 * Default value is "".
		 */
		public function get streetOrPOI():String {
			return this._streetOrPOI;
		}
		public function set streetOrPOI(value:String):void {
			this._streetOrPOI = (value) ? value : "";
			// Update the content of the request
			this.postContent = this.createContent();
		}
		
		/**
		 * Getter and setter of the postal code of the request.
		 * Default value is "".
		 */
		public function get postalCode():String {
			return this._postalCode;
		}
		public function set postalCode(value:String):void {
			var pc:String = (value) ? value : "";
			if (this.isValidPostalCode != null) {
				if (! this.isValidPostalCode(pc)) {
					Trace.error("OpenLSRequest - set postalCode: invalid value \""+value+"\"");
					return;
				}
			}
			this._postalCode = pc;
			// Update the content of the request
			this.postContent = this.createContent();
		}
		
		/**
		 * Getter and setter of the city (name) of the request.
		 * Default value is "".
		 */
		public function get city():String {
			return this._city;
		}
		public function set city(value:String):void {
			this._city = (value) ? value : "";
			// Update the content of the request
			this.postContent = this.createContent();
		}
		
		/**
		 * Getter and setter of the function that check if a postal code is
		 * valid or not.
		 */
		public function get isValidPostalCode():Function {
			return this._isValidPostalCode;
		}
		public function set isValidPostalCode(value:Function):void {
			this._isValidPostalCode = value;
		}
		
		/**
		 * Define quickly all the fields of an OpenLS request.
		 * @param dataFile
		 * @param streetOrPOI
		 * @param postalCode
		 * @param city
		 */
		public function define(dataFile:String, streetOrPOI:String, postalCode:String, city:String):void {
			this.dataFile = dataFile;
			this.streetOrPOI = streetOrPOI;
			this.postalCode = postalCode;
			this.city = city;
			// Update the content of the request
			this.postContent = this.createContent();
		}
		
		/**
		 * Create the content of the request using the specified fields.
		 * @return a String describing the content of the request.
		 */
		private function createContent():String {
			var request:String = '';
			request += '<XLS xmlns="http://www.opengis.net/xls" xmlns:xls="http://www.opengis.net/xls" xmlns:gml="http://www.opengis.net/gml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/xls" version="1.0">';
			request += '<RequestHeader/>';
			request += '<Request requestID="1" version="" methodName="LocationUtilityService">';
			request += '<GeocodeRequest>';
			request += '<Address countryCode="' + this.dataFile + '">';
			request += '<StreetAddress>';
			request += '<Street>' + this.streetOrPOI + '</Street>';
			request += '</StreetAddress>';
			request += '<Place type="Municipality">' + this.city + '</Place>';
			request += '<PostalCode>' + this.postalCode + '</PostalCode>';
			request += '</Address>';
			request += '</GeocodeRequest>';
			request += '</Request>';
			request += '</XLS>';
			return request;
		}
		
		/**
		 * Get the XML list of geocoded addresses
		 * @param response XML document describing the OpenLS response
		 * @return the XML list of geocoded addresses
		 */
		static public function resultsList(response:XML):XMLList {
			var xls:Namespace = new Namespace("xls", "http://www.opengis.net/xls");
			return response.xls::Response.xls::GeocodeResponse.xls::GeocodeResponseList;
		}
		
		/**
		 * Get the number of geocoded addresses
		 * @param response XML document describing the OpenLS response
		 * @return the number of geocoded addresses
		 */
		static public function resultsNumber(response:XML):Number {
			return OpenLSRequest.resultsList(response).@numberOfGeocodedAddresses.toString() as Number;
		}
		
		/**
		 * Transform a list of results of a geocoding into a JSON formatted
		 * String describing which geocoded address by its "accuracy",
		 * "city", "lat", "lon", "postalCode" and "streetOrPOI".
		 * @param resultsList XML document describing the results of a geocoding
		 * @return a JSON string
		 */
		static public function resultsListtoJSON(resultsList:XMLList):String {
			var xls:Namespace = new Namespace("xls", "http://www.opengis.net/xls");
			var gml:Namespace = new Namespace("gml", "http://www.opengis.net/gml");
			var jsonResults:Array = new Array(), jsonResult:Object, position:Array;
			for each (var gr:XML in resultsList.xls::GeocodedAddress) {
				jsonResult = new Object();
				jsonResult.accuracy = Number(gr.xls::GeocodeMatchCode.@accuracy.toString());
				jsonResult.city = gr.xls::Address.xls::Place.toString();
				position = gr.gml::Point.gml::pos.toString().split(' ');
				if (position.length == 2) {
					jsonResult.lat = Number(position[0]);
					jsonResult.lon = Number(position[1]);
				}
				jsonResult.postalCode = gr.xls::Address.xls::PostalCode.toString();
				jsonResult.streetOrPOI = gr.xls::Address.xls::StreetAddress.xls::Street.toString();
				jsonResults.push(jsonResult);
			}
			return JSON.encode(jsonResults);
		}
		
	}
	
}
