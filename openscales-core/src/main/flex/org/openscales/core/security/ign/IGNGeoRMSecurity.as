package org.openscales.core.security.ign
{
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.utils.Timer;

    import org.openscales.core.Map;
    import org.openscales.core.Trace;
    import org.openscales.core.events.LayerEvent;
    import org.openscales.core.request.XMLRequest;
    import org.openscales.core.security.AbstractSecurity;
    import org.openscales.core.security.events.SecurityEvent;

    /**
     * IGN GeoRM security implementation.
     * This module will retreive an GeoRM token in order to be able to request protected datas
     * Documentation is available at https://api.ign.fr/geoportail/api/doc/index.html
     */
    public class IGNGeoRMSecurity extends AbstractSecurity
    {

        /** Host used to retreive the token **/
        private var _host:String = "http://jeton-api.ign.fr";

        /** Security parameter name, the value will be the token retreived from the server **/
        private var _securityParameterName:String = "gppkey";

        /**
         * The key that will identify you. You have to create your own key for your own domain
         * on https://api.ign.fr
         */
        private var _key:String = null;

        /**
         * The token returned by the GeoRM. It will be appended as a parameter to data request.
         */
        private var _token:String = null;

        /**
         * Timer used to request token updates
         */
        private var _timer:Timer = null;

        /**
         * Time to live of the token in milliseconds. Default to 10 minutes.
         */
        private var _ttl:int = 60000;

        /**
         * Is a init or update request pending ?
         */
        private var _requestPending:Boolean = false;

        /**
         * How many time since last token update
         */
        private var _lastTokenUpdate:Date = null;


        public function IGNGeoRMSecurity(map:Map, key:String, proxy:String = null, host:String = null) {
            if (host) {
                this.host = host;
            }
            if (proxy) {
                this.proxy = proxy;
            }
            this.key = key;
            this._timer = new Timer(this.ttl, 1);
            this._timer.addEventListener(TimerEvent.TIMER, tokenExpiredHandler);
            map.addEventListener(LayerEvent.LAYER_LOAD_START, userActivityHandler);
            super(map);
        }

        public function userActivityHandler(e:LayerEvent):void {
            if (!this._requestPending) {
                if (!this._initialized) {
                    Trace.log("Token has expired, so get a new one");
                    this.initialize();
                } else if ((new Date().valueOf() - this._lastTokenUpdate.valueOf()) > (ttl/2)) {
                    this.update();
                }
            }
        }

        /**
         * Authenticate and retreive config to print it in logs
         */
        override public function initialize():void {
            Trace.log("Request a new token");
            this._requestPending = true;
            // GET:
            var xr:XMLRequest= new XMLRequest(this.authUrl+this.authParams, authenticationResponse, this.proxy);
            // POST:
            //var uv:URLVariables= new URLVariables(this.authParams);
            //var xr:XMLRequest= new XMLRequest(this.authUrl, authenticationResponse, this.proxy, URLRequestMethod.POST, null, null, uv);
        }

        /**
         * Authentication asynchronous response
         */
        private function authenticationResponse(e:Event):void {
            var loader:URLLoader = e.target as URLLoader;
            try {
                var doc:XML =  new XML(loader.data);
                this.token = doc.toString();
                this._initialized = true;
                Trace.log("Valid token received : " + this.token);
                map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_INITIALIZED, this));
                this.reset();
            } catch (err:Error) {
                 Trace.error("Error during parsing XML response : " + loader.data)
            }
        }

        /**
         * Reset timer after reveived an init or update response
         */
        private function reset():void {
            this._requestPending = false;
            this._lastTokenUpdate = new Date();
            this._timer.reset();
            this._timer.start();
        }

        /**
         * Config asynchronous response
         */
        private function configResponse(e:Event):void {
            var loader:URLLoader = e.target as URLLoader;
            try {
                var doc:XML =  new XML(loader.data);
                Trace.log(doc.toString());
            } catch (err:Error) {
                 Trace.error("Error during parsing XML response : " + loader.data)
            }
        }

        /** Return authentication URL, use random parameter to avoid caching **/
        private function get authUrl():String {
            return this.host + "/getToken?random=" + Math.random().toString() + "&";
        }

        /** Return parameters string for authentication URL **/
        private function get authParams():String {
            return "key=" + this.key + "&output=xml";
        }

        /** Return config URL, use random parameter to avoid caching  **/
        private function get configUrl():String {
            return this.host + "/getConfig?";
        }

        /** Return parameters string for config URL **/
        private function get configParams():String {
            return "key=" + this.key + "&output=xml";
        }

        /** Return update URL, use random parameter to avoid caching  **/
        private function get updateUrl():String {
            return this.host + "/getToken?random=" + Math.random().toString() + "&";
        }

        /** Return parameters string for release URL **/
        private function get updateParams():String {
            return "key=" + this.key + "&" + this.securityParameter + "&output=xml";
        }

        /** Return release URL, use random parameter to avoid caching  **/
        private function get releaseUrl():String {
            return this.host + "/release?random=" + Math.random().toString() + "&";
        }

        /** Return parameters string for release URL **/
        private function get releaseParams():String {
            return this.securityParameter + "&output=xml";
        }

        /** Will use the same mechanism than at layer startup to update datas when the token will be retreived **/
        private function tokenExpiredHandler(e:TimerEvent):void {
            Trace.log("Token expired");
            this._initialized = false;
        }

        override public function update():void {
            Trace.log("Update token");
            this._requestPending = true;
            // GET:
            var xr:XMLRequest= new XMLRequest(this.updateUrl+this.updateParams, authenticationUpdateResponse, this.proxy);
            // POST:
            //var uv:URLVariables= new URLVariables(this.updateParams);
            //var xr:XMLRequest= new XMLRequest(this.updateUrl, authenticationUpdateResponse, this.proxy, URLRequestMethod.POST, null, null, uv);
        }

        /**
         * Authentication update asynchronous response
         */
        private function authenticationUpdateResponse(e:Event):void {
            var loader:URLLoader = e.target as URLLoader;
            try {
                var doc:XML =  new XML(loader.data);
                this.token = doc.toString();
                Trace.log("Valid token received : " + this.token);
                map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_UPDATED, this));
                this.reset();
            } catch (err:Error) {
                 Trace.error("Error during parsing XML response : " + loader.data)
            }
        }

        override public function get securityParameter():String {
            return this.securityParameterName + "=" + this.token;
        }

        override public function logout():void {
            new XMLRequest(this.releaseUrl, authenticationLogoutResponse, this.proxy);
        }

        /**
         * Authentication release asynchronous response
         */
        private function authenticationLogoutResponse(e:Event):void {
            map.dispatchEvent(new SecurityEvent(SecurityEvent.SECURITY_LOGOUT, this));
            this._initialized = false;
            Trace.log("token " + this._key + " released");
        }

        public function get host():String {
            return this._host;
        }

        public function set host(value:String):void {
            if (! value) {
                Trace.error("IGNGeoRMSecurity - set host: invalid void URL");
                return;
            }
            var strlen:int = value.length;
            var tail:String = value.substr(strlen-1,1);
            if (tail != "/") {
                this._host = value;
            } else if((tail=="/") && (strlen > 1)) {
                this._host = value.substr(0,strlen-1);
            } else {
                Trace.error("IGNGeoRMSecurity - set host: malformed host URL \""+value+"\"");
            }
        }

        public function get key():String {
            return this._key;
        }

        public function set key(value:String):void {
            this._key = value;
        }

        public function get token():String {
            return this._token;
        }

        public function set token(value:String):void {
            this._token = value;
        }

        public function get securityParameterName():String {
            return this._securityParameterName;
        }

        public function set securityParameterName(value:String):void {
            this._securityParameterName = value;
        }

        public function get ttl():int {
            return this._ttl;
        }

        public function set ttl(value:int):void {
            this._ttl = value;
            this._timer.delay = value;
        }

    }
}
