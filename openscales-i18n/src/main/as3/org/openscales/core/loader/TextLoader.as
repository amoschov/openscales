package org.openscales.core.loader {
	import flash.system.Capabilities;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequest;

	import org.openscales.core.StringUtils;

	/**
	 * Text loader base class. A text file is a UTF-8 text file
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class TextLoader extends URLLoader {

		/**
		 * the data format.
		 */
		public static const PROPERTIES_FORMAT:String=URLLoaderDataFormat.TEXT;

		/**
		 * The regexp for relacing special characters.
		 */
		public static const _SCHARRX:RegExp=new RegExp("[\u000D\u2028\u2029]", "g");

		/**
		 * The source containing the properties.
		 * @private
		 */
		private var _srcName:String;

		/**
		 * The parsed properties.
		 * @private
		 */
		private var _props:Object;

		/**
		 * Error text, also used as asynchronous call token. At the beginning, set to undefined. on
		 * Event.OPEN, set to "OPEN", on ProgressEvent.PROGRESS, set to null, on
		 * IOErrorEvent.IO_ERROR or SecurityErrorEvent.SECURITY_ERROR, set to event.text.
		 * @private
		 */
		private var _errorText:String;

		/**
		 * Build a properties loader.
		 */
		public function TextLoader() {
			super();
			this.dataFormat=PROPERTIES_FORMAT;
			this.source=null;
			this.properties=null;
			this.errorText=undefined;
		}

		/**
		 * Configure the events listeners.
		 * @private
		 */
		private function configureListeners():void {
			if (!this.hasEventListener(Event.OPEN)) {
				this.addEventListener(Event.OPEN, this.openHandler);
			}
			if (!this.hasEventListener(ProgressEvent.PROGRESS)) {
				this.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
			}
			if (!this.hasEventListener(HTTPStatusEvent.HTTP_STATUS)) {
				this.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
			}
			if (!this.hasEventListener(IOErrorEvent.IO_ERROR)) {
				this.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			}
			if (!this.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) {
				this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
			}
			if (!this.hasEventListener(Event.COMPLETE)) {
				this.addEventListener(Event.COMPLETE, this.completeHandler);
			}
		}

		/**
		 * The source has been opened : dispatched when the download operation commences following a
		 * call to the URLLoader.load() method. If defined at creation time, the onOpen(e:Event)
		 * callback is called. Does set the errorText to "OPEN".
		 *
		 * @param e the Event.OPEN event fired. The event.target holds the loader.
		 * @private
		 */
		private function openHandler(e:Event):void {
			this.errorText="OPEN";
		}

		/**
		 * The loading is under processing : dispatched when data is received as the download
		 * operation progresses. If defined at creation time, the onProgress(e:Event) callback is
		 * called. Does set the errorText to null.
		 *
		 * @param e the ProgressEvent.PROGRESS event fired. The event.target holds the loader,
		 * event.bytesLoaded the amount of downloaded bytes, event.bytesTotal the total amount of
		 * bytes to download.
		 * @private
		 */
		private function progressHandler(e:Event):void {
			this.errorText=null;
		}

		/**
		 * Retreive the HTTP status : an HTTPStatusEvent object does not necessarily indicate an
		 * error condition; it simply reflects the HTTP status code (if any) that is provided by the
		 * networking stack. Some Flash Player environments may be unable to detect HTTP status
		 * codes; a status code of 0 is always reported in these cases. If defined at creation time,
		 * the onHttpStatus(e:Event) callback is called.
		 *
		 * @param e the HTTPStatusEvent.HTTP_STATUS event fired. The event.target holds the loader,
		 *          event.status holds the HTTP code.
		 * @private
		 */
		private function httpStatusHandler(e:Event):void {
		}

		/**
		 * Process an I/O error: dispatched if a call to URLLoader.load() results in a fatal error
		 * that terminates the download. If defined at creation time, the onIOError(e:Event)
		 * callback is called. Does set the errorText to event.text.
		 *
		 * @param e the IOErrorEvent.IO_ERROR event fired. The event.target holds the loader,
		 *          event.text holds the error message.
		 * @private
		 */
		private function ioErrorHandler(e:Event):void {
			this.errorText=(e as IOErrorEvent).text;
		}

		/**
		 * Process an security error : dispatched if a call to URLLoader.load() attempts to load data
		 * from a server outside the security sandbox. If defined at creation time, the
		 * onSecurityError(e:Event) callback is called. Does set the errorText to event.text.
		 *
		 * @param e the SecurityErrorEvent.SECURITY_ERROR event fired. The event.target holds the
		 * loader, event.text holds the error message.
		 * @private
		 */
		private function securityErrorHandler(e:Event):void {
			this.errorText=(e as SecurityErrorEvent).text;
		}

		/**
		 * Finish the loading. If defined at creation time, the onComplete(e:Event)
		 * callback is called, otherwise parse the properties file.
		 *
		 * @param e the Event.COMPLETE event fired. The event.target holds the loader.
		 * @private
		 */
		private function completeHandler(e:Event):void {
			this.properties=this.parse(this.data);
		}

		/**
		 * Parse the loaded lines. Does nothing (it is called on Event.COMPLETE by the relevant
		 * handler).
		 *
		 * @param source the return UTF-8 text to parse.
		 */
		public function parse(source:String):Object {
			return null;
		}

		/**
		 * Return the properties.
		 *
		 * @return the loaded properties.
		 */
		public function get properties():Object {
			return this._props;
		}

		/**
		 * Set the properties.
		 *
		 * @param p the properties.
		 */
		public function set properties(p:Object):void {
			this._props=p;
		}

		/**
		 * Return the error text.
		 *
		 * @return the message.
		 */
		public function get errorText():String {
			return this._errorText;
		}

		/**
		 * Set the error text.
		 *
		 * @param t the message.
		 */
		public function set errorText(t:String):void {
			this._errorText=t;
		}

		/**
		 * Get the path to be applied to the source name. This method is meant to be overriden by
		 * sub-class of this class.
		 *
		 * @return ""
		 */
		public function getPath():String {
			return "";
		}

		/**
		 * Get the source to load.
		 *
		 * @return the properties file to read.
		 */
		public function get source():String {
			return this._srcName;
		}

		/**
		 * Set the source to load.
		 *
		 * @param source the properties file to read.
		 */
		public function set source(source:String):void {
			this._srcName=source;
		}

		/**
		 * Fetch data from the given source. The errorText getter is null if no errors have been
		 * encountered.
		 * The properties file is build upon the returned getPath() concatenated with the source.
		 */
		public function loadTextData():void {
			if (this.source != null) {
				var hdr:URLRequestHeader=new URLRequestHeader("Accept", "text/plain");
				var rqst:URLRequest=new URLRequest(this.getPath() + this.source);
				rqst.requestHeaders.push(hdr);
				this.errorText=undefined;
				this.properties=null;
				this.configureListeners();
				try {
					this.load(rqst);
				} catch (e:Error) {
					this.errorText=e.toString();
				}
			} else {
				var msg:String;
				switch (Capabilities.language) {
					case "fr":
						msg="aucune source à charger.";
						break;
					case "en":
					default:
						msg="no source set.";
						break;
				}
				this.errorText=msg;
			}
		}

	}

}
