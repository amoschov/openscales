package org.openscales.core.event
{
	
	import org.openscales.core.basetypes.Pixel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	
	public class OpenScalesEvent extends Event
	{
		public var observers:Object = false;
		
		public static var KEY_BACKSPACE:int = 8;

    	public static var KEY_TAB:int = 9;

    	public static var KEY_RETURN:int = 13;

    	public static var KEY_ESC:int = 27;

    	public static var KEY_LEFT:int = 37;

    	public static var KEY_UP:int = 38;

    	public static var KEY_RIGHT:int = 39;

    	public static var KEY_DOWN:int = 40;

    	public static var KEY_DELETE:int = 46;
    	
    	public var xy:Pixel = null;
    	
    	public function OpenScalesEvent():void {
    		super("", true, true);
    	}
    	
    	public static function element(event:OpenScalesEvent):Object {
    		return event.currentTarget;
    	}
    	
    	public static function isLeftClick(event:MouseEvent):Boolean {
    		if (event is MouseEvent) {
    			var mouseevent:MouseEvent = MouseEvent(event);
    			return (mouseevent.type == MouseEvent.CLICK || mouseevent.type == MouseEvent.MOUSE_DOWN);
    		}
    		return false;
    	}
    	
    	public static function stop(event:Object, allowDefault:Boolean = false):void {
    		
    		if (!allowDefault) {
    			if (event.preventDefault) {
    				event.preventDefault();
    			}
    		}
    		
    		if (event.stopPropagation) {
    			event.stopPropagation();
    		}
    	}
    	
    	public static function findElement(event:OpenScalesEvent, tagName:String):Object {
    		var element:Object = element(event);
	        while (element.parent && (!element.tagName ||
	              (element.tagName.toUpperCase() != tagName.toUpperCase())))
	            element = element.parent;
	        return element;	
    	}
    	
    	public function observe(element:Object, name:String, observer:Function, useCapture:Boolean = false):void {
    /*		var element:Object = new Util().getElement(elementParam);
	
	        if (name == 'keypress' &&
	           (element.attachEvent)) {
	            name = 'keydown';
	        }

	        if (!this.observers) {
	            this.observers = new Object();
	        }

	        if (!element._eventCacheID) {
	            var idPrefix:String = "eventCacheID_";
	            if (element.id) {
	                idPrefix = element.id + "_" + idPrefix;
	            }
	            element._eventCacheID = Util.createUniqueID(idPrefix);
	        }
	
	        var cacheID:String = element._eventCacheID;

	        if (!this.observers[cacheID]) {
	            this.observers[cacheID] = new Array();
	        }

	        this.observers[cacheID].push({
	            "element": element,
	            "name": name,
	            "observer": observer,
	            "useCapture": useCapture
	        });
*/
	        if (element.addEventListener) {
	            element.addEventListener(name, observer, useCapture);
	        }
	    }
	    
	    public static function stopObservingElement(name:String, elementParam:Object):void {
	    	if (elementParam != null) {
		    	if (elementParam.hasEventListener(name)) {
		    		elementParam.removeEventListener(name);
		    	}
	    	}
	    }
	    
	    private function _removeElementObservers(elementObservers:Array):void {
	    	if (elementObservers) {
	            for(var i:int = elementObservers.length-1; i >= 0; i--) {
	                var entry:Object = elementObservers[i];
	                var args:Array = new Array(entry.element,
	                                     entry.name,
	                                     entry.observer,
	                                     entry.useCapture);
	                var removed:Boolean = this.stopObserving.apply(this, args);
	            }
	        }
	    }
	    
	    public function stopObserving(element:Object, name:String, observer:Function, useCapture:Boolean = false):Boolean {
/*	    	useCapture = useCapture || false;
	    
	        var element:Object = new Util().getElement(elementParam);
	        var cacheID:String = element._eventCacheID;
	
	        if (name == 'keypress') {
	            if ( element.detachEvent) {
	              name = 'keydown';
	            }
	        }

	        var foundEntry:Boolean = false;
	        var elementObservers:Object = this.observers[cacheID];
	        if (elementObservers) {

	            var i:int=0;
	            while(!foundEntry && i < elementObservers.length) {
	                var cacheEntry:Object = elementObservers[i];
	    
	                if ((cacheEntry.name == name) &&
	                    (cacheEntry.observer == observer) &&
	                    (cacheEntry.useCapture == useCapture)) {
	    
	                    elementObservers.splice(i, 1);
	                    if (elementObservers.length == 0) {
	                        delete this.observers[cacheID];
	                    }
	                    foundEntry = true;
	                    break; 
	                }
	                i++;           
	            }
	        }
*/
	        if (element.removeEventListener) {
	            element.removeEventListener(name, observer, useCapture);
	        }
	        return true;
	    }
	    
	    public function unloadCache():void {
	        if (this.observers) {
	            for (var cacheID:String in this.observers) {
	                var elementObservers:Object = this.observers[cacheID];
	                this._removeElementObservers.apply(this, [elementObservers]);
	            }
	            this.observers = false;
	        }
	    }
    	
	}
}