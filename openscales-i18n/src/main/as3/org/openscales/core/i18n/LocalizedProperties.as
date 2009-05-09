/**
 * @see http://code.google.com/p/andromed-as/ under MPL 1.1
 * @see http://www.ekameleon.net/vegas/docs/andromeda/i18n/Localization.html
 */
package org.openscales.core.i18n
{
    import flash.system.Capabilities;
    import flash.utils.getQualifiedClassName;
    import flash.events.Event;
    import flash.events.ErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.events.IEventDispatcher;
    import flash.events.SecurityErrorEvent;

    import org.openscales.core.StringUtils;
    import org.openscales.core.i18n.Lang;
    import org.openscales.core.i18n.events.LanguageEvent;
    import org.openscales.core.i18n.PropertiesLoader;

    /**
     * Handle properties localized in several languages.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9
     * @author didier.richard@ign.fr
     */
    public class LocalizedProperties implements IEventDispatcher {

        /**
         * Default identification for the localized properties.
         */
        public static const DEFAULT_ID:String= "__defaultLocalizedProperties__";

        /**
         * The list of all localized properties resources.
         * @private
         */
        private static var _LOCALIZED_RESOURCES:Object= {
            DEFAULT_ID: {
                "en" : {
                    "already.known.id" : "Localization '${id}' already exists."
                },
                "fr" : {
                    "already.known.id" : "La traduction '${id}' existe déjà."
                }
            }
        };

        /**
         * Identifier of this localized properties.
         * @private
         */
        protected var _id:String;

        /**
         * The prefix of the localized properties.
         * @private
         */
        protected var _prefix:String;

        /**
         * Current language.
         * @private
         */
        private var _currentLang: Lang;

        /**
         * Last loaded language. It is considered as being the current language.
         * @private
         */
        private var _currentlyLoadingLang: Lang;

        /**
         * The list of translations. The keys are languages.
         * @private
         */
        private var _propertiesLocalizations:Object;

        /**
         * The resources loader.
         * @private
         */
        private var _loader:PropertiesLoader;

        /**
         * The internal flag to indicates if the loader is under parsing or not.
         * @private
         */
        private var _locked:Boolean;

        /**
         * Build a new localized properties.
         *
         * @example
         * <listing version="3.0">
         * var lp:LocalizedProperties= new LocalizedProperties("MyProps");
         * lp.language= "fr";// load MyProps_fr.properties
         * var s:String= lp.translate("key");// french translation
         * lp.language= "en";// load MyProps_en.properties
         * s= lp.translate("key");// english translation
         * </listing>
         *
         * @param id the identification of the localized properties.
         * @param rez the properties loader.
         */
        public function LocalizedProperties ( id:String= null, rez:PropertiesLoader= null ) {
            this._setId(id);
            this._currentLang= null;
            this._currentlyLoadingLang= null;
            this._propertiesLocalizations= null;
            this._locked= false;
            this._setLoader(rez);
        }

        /**
         * Return the identifier value.
         *
         * @return the identification of the localized properties.
         */
        public function get id ( ) : String {
            return this._id;
        }

        /**
         * Assign the identifier value. Store the localized properties in the _LOCALIZED_RESOURCES
         * property.
         *
         * @param id the identification of the localized properties.
         *
         * @throws DefinitionError when the resource id already exists.
         *
         * @private
         */
        private function _setId ( id:String ) : void {
            this._id= id==null? DEFAULT_ID : StringUtils.trim(id);
            if (_LOCALIZED_RESOURCES[this._id]!=null) {
                var msg:String= LocalizedProperties.translate(
                    DEFAULT_ID,
                    this.preferedLang(),
                    "already.known.id",
                    {id:this._id}
                );
                throw new DefinitionError(msg);
            }
            _LOCALIZED_RESOURCES[this._id]= this;
            this.prefix= this._id;
        }

        /**
         * Return the prefix of the properties.
         *
         * @return the prefix.
         */
        public function get prefix ( ) : String {
            return this._prefix;
        }

        /**
         * Set the prefix of the properties. Does no filtering.
         *
         * @param str A string to filter for setting the prefix.
         */
        public function set prefix ( str:String ) : void {
            this._prefix= str;
        }

        /**
         * Return the properties loader.
         *
         * @return the properties loader.
         */
        public function get loader ( ) : PropertiesLoader {
            return this._loader;
        }

        /**
         * Assign the properties loader. When null, create a PropertiesLoader object and set events
         * listeners.
         *
         * @param rez the properties loader.
         *
         * @private
         */
        private function _setLoader ( rez:PropertiesLoader= null ) : void {
            if (rez==null) {
                rez= new PropertiesLoader();
            }
            this._loader= rez;
        }

        /**
         * Intercept an ErrorEvent (IOErrorEvent, SecurityErrorEvent) event.
         *
         * @param e the fired event.
         *
         * @private
         */
        private function _errorH ( e:Event ) : void {
            this.loader.errorText= (e as ErrorEvent).text;
            this.setLocale(this._currentlyLoadingLang, {__failed__:this.loader.errorText});
            this._currentlyLoadingLang= null;
            this.unlock();
            this.notifyChangeLang(LanguageEvent.FAILED_LOADING_LANG);
        }

        /**
         * Intercept the Event.COMPLETE event. When parsing is terminated
         * issue a LanguageEvent.CHANGE event.
         *
         * @param e the fired event.
         *
         * @private
         */
        private function _completeH ( e:Event ) : void {
            this.setLocale(
                this._currentlyLoadingLang,
                this.loader.parse(this.loader.data));
            this.unlock();
            this.language= this._currentlyLoadingLang;
            this._currentlyLoadingLang= null;
        }

        /**
         * Return the last loaded language.
         *
         * @return the current language.
         */
        public function get language() : Lang {
            return this._currentLang;
        }

        /**
         * Set the current language. Setting occurs only if there is no on-going loading.
         *
         * @param lang the language as String or Lang.
         */
        public function set language ( lang:Lang ) : void {
            if (lang!=null && lang!=this.language && !this.isLocked()) {
                if (this.contains(lang)) {
                    this._currentLang= lang;
                    this.notifyChangeLang(
                        this._currentlyLoadingLang==lang?
                            LanguageEvent.LOADED_LANG
                        :   LanguageEvent.CHANGE_LANG
                    );
                } else {
                    this.lock();
                    this._currentlyLoadingLang= lang;
                    if (!this.loader.hasEventListener(IOErrorEvent.IO_ERROR)) {
                        this.loader.addEventListener(
                            IOErrorEvent.IO_ERROR,this._errorH);
                    }
                    if (!this.loader.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) {
                        this.loader.addEventListener(
                            SecurityErrorEvent.SECURITY_ERROR,this._errorH);
                    }
                    if (!this.loader.hasEventListener(Event.COMPLETE)) {
                        this.loader.addEventListener(
                            Event.COMPLETE,this._completeH);
                    }
                    // load the localized properties : prefix_lang.properties
                    this.loader.source= this.prefix+"_"+lang+".properties";
                    this.loader.loadTextData();
                }
            }
        }

        /**
         * Try to find out the appropriate language supported by this localized properties. The
         * current language is first tried, If none, the language on which the system is running. If
         * it is not supported, "en" is tried. If it is not supported, null is returned.
         *
         * @return the appropriate language.
         */
        public function preferedLang ( ) : Lang {
            if (this.language!=null) {
                return this.language;
            }
            var l:Lang= Lang.getInstance(Capabilities.language);
            if (!this.contains(l)) {
                l= Lang.EN;
                if (!this.contains(l)) {
                    return null;
                }
            }
            this.language= l;
            return l;
        }

        /**
         * Return true if the localized properties are locked.
         *
         * @return true if the object is locked.
         */
        public function isLocked ( ) : Boolean {
            return this._locked==true;
        }

        /**
         * Lock the localized properties. Prevents to load new translations by setting the current
         * language.
         */
        public function lock () : void {
            this._locked= true;
        }

        /**
         * Unlock the localized properties.
         */
        public function unlock ( ) : void {
            this._locked= false;
        }

        /**
         * Indicate whether these localized properties support some languages.
         *
         * @return true if no translations have been added, false otherwise.
         */
        public function isEmpty ( ) : Boolean {
            return this._propertiesLocalizations==null;
        }

        /**
         * Indicate whether a language is part of the localized properties.
         *
         * @param lang the language to check.
         *
         * @return true if the language is supported, false otherwise.
         */
        public function contains ( lang:Lang ) : Boolean {
            if (!this.isEmpty() && lang!=null) {
                var l:String= lang.toString();
                if (this._propertiesLocalizations[l]==null) {
                    return false;
                }
                if (this._propertiesLocalizations[l]['__failed__']!=null) {
                    return false;
                }
                return true;
            }
            return false;
        }

        /**
         * Return the supported languages of these localized properties.
         *
         * @return an array of languages, may be null if none.
         */
        public function supportedLanguages ( ) : Array {
            if (this.isEmpty()) {
                return null;
            }
            var sl:Array= [];
            for (var l:String in this._propertiesLocalizations) {
                sl.push(Lang.getInstance(l));
            }
            return sl;
        }

        /**
         * Append or update the given object to the properties' translations. This method can be used
         * to directly add translations to this localized properties.
         *
         * @param l the translations language to add or update.
         * @param t the translations.
         *
         * @return true if the process has been done successfully, false otherwise.
         */
        public function setLocale ( l:Lang, t:Object ) : Boolean {
            if (l!=null && t!=null) {
                if (!this.contains(l)) {
                    if (this._propertiesLocalizations==null) {
                        this._propertiesLocalizations= {};
                    }
                    this._propertiesLocalizations[l.toString()]= {};
                }
                var pl:Object= this._propertiesLocalizations[l.toString()];
                for (var p:String in t) {
                    pl[p]= t[p];
                }
                return true;
            }
            return false;
        }

        /**
         * Return the properties' translations for a given or current language.
         *
         * @param l the language for which translations are read.
         *
         * @return a reference to the translations, null if none.
         */
        public function getLocale ( l:Lang= null ) : Object {
            if (l==null) {
                if (this._propertiesLocalizations==null) {
                    return null;
                }
                l= this.preferedLang();
                if (l==null) {
                    return null;
                }
                return this._propertiesLocalizations[this.language.toString()];
            }
            return this._propertiesLocalizations[l.toString()];
        }

        /**
         * Notify when the language change.
         *
         * @param type the event category. Defaults to LanguageEvent.CHANGE_LANG.
         */
        public function notifyChangeLang ( type:String= null ) : void {
            if (!this.isLocked()) {
                type= type==null?
                    LanguageEvent.CHANGE_LANG
                :   type;
                this.dispatchEvent(new LanguageEvent(type,this));
            }
        }

        /**
         * Return a string containing all the properties of the LocalizedProperties object.
         *
         * @return "[LocalizedProperties id=value lang={k=\"v\"}]"
         */
        public function toString ( ) : String {
            var s:String= "["+getQualifiedClassName(this)+
                    this.id?
                        " id="+this.id
                    :   "";
            var ps:Object;
            for (var l:Object in this.supportedLanguages()) {
                s+= " "+(l as Lang).toString()+"={";
                ps= this.getLocale((l as Lang));
                for (var p:String in ps) {
                    s+= p+"=\""+ps[p]+"\" ";
                }
                s+= "}"
            }
            s+= "]";
            return s;
        }

        /**
         * Return a translated string for the localized properties and current language.
         *
         * @param key the property key to retrieve.
         * @param context An object with properties corresponding to the tokens in the format
         *                string. If no context, the property value is returned unchanged.
         * @param args arguments to pass to any functions found in the context.  If a context
         *             property is a function, the token will be replaced by the return from the
         *             function called with these arguments.
         *
         * @return A string with tokens replaced with properties from the given context object.
         */
        public function translate ( key:String, context:Object= null, args:Array= null ) : String {
            var lp:Object= this.getLocale();
            if (lp==null) {
                return key;
            }
            return lp[key]==null? key : StringUtils.format(lp[key],context,args);
        }

        /**
         * Return a translated string for the given localized properties identifier and language.
         *
         * @param id the identification of the localized properties.
         * @param lang the target language.
         * @param key the property key to retrieve.
         * @param context An object with properties corresponding to the tokens in the format
         *                string. If no context, the property value is returned unchanged.
         * @param args arguments to pass to any functions found in the context.  If a context
         *             property is a function, the token will be replaced by the return from the
         *             function called with these arguments.
         *
         * @return A string with tokens replaced with properties from the given context object.
         */
        public static function translate ( id:String, lang:Lang, key:String, context:Object= null, args:Array= null ) : String {
            if (id==null) {
                id= DEFAULT_ID;
            }
            var lp:Object= _LOCALIZED_RESOURCES[id];
            if (lp==null) {
                return key;
            }
            lp.language= lang || lp.preferedLang();
            return lp.format(key,context,args);
        }

        // IEventDispatcher functions definitions :

        /**
         * Allow the registration of event listeners on the event target.
         *
         * @param type A string representing the event type to listen for.
         * @param listener The object that receives a notification when an event of the specified
         *                 type occurs. This must be an object implementing the EventListener
         *                 interface.
         * @param useCapture Determinates if the event flow use capture or not.
         * @param priority Determines the priority level of the event listener.
         * @param useWeakReference Indicates if the listener is a weak reference.
         */
        public function addEventListener ( type:String, listener:Function, useCapture:Boolean= false, priority:int= 0.0, useWeakReference:Boolean= false ) : void {
            this.loader.addEventListener(type,listener,useCapture,priority,useWeakReference);
        }

        /**
         * Dispatch an event into the event flow.
         *
         * @param event The Event object that is dispatched into the event flow.
         *
         * @return true if the Event is dispatched.
         */
        public function dispatchEvent ( event:Event ) : Boolean {
            return this.loader.dispatchEvent(event);
        }

        /**
         * Check whether this object has any listeners registered for a specific type of
         * event. This allows you to determine where altered handling of an event type has been
         * introduced in the event flow hierarchy by an IEventDispatcher interface implementation.
         *
         * @param type A string representing the event type to listen for.
         */
        public function hasEventListener ( type:String ) : Boolean {
            return this.loader.hasEventListener(type);
        }

        /**
         * Remove a listener from the object. If there is no matching listener registered with the
         * EventDispatcher object, then calling this method has no effect.
         *
         * @param type The type of event.
         * @param listener The listener object to remove.
         * @param useCapture Specifies whether the listener was registered for the capture phase or
         *                   the target and bubbling phases. If the listener was registered for both
         *                   the capture phase and the target and bubbling phases, two calls to
         *                   removeEventListener() are required to remove both, one call with
         *                   useCapture() set to true , and another call with useCapture() set to
         *                   false .
         */
        public function removeEventListener ( type:String, listener:Function, useCapture:Boolean= false ) : void {
            this.loader.removeEventListener(type,listener,useCapture);
        }

        /**
         * Check whether an event listener is registered with this  object or any of its
         * ancestors for the specified event type. This method returns true if an event listener is
         * triggered during any phase of the event flow when an event of the specified type is
         * dispatched to this EventDispatcher object or any of its descendants.
         *
         * @return A value of true if a listener of the specified type will be triggered, false
         *        otherwise.
         */
        public function willTrigger ( type:String ) : Boolean {
            return this.loader.willTrigger(type);
        }

   }

}
