package org.openscales.core
{
	import flash.events.MouseEvent;
	
	import org.openscales.core.basetypes.Pixel;
	
	public class Events
	{
    	
    	public var listeners:Object = null;
    	
    	public var object:Object = null;
    	
    	public var element:Object = null;
    	
    	public var eventTypes:Array = null;
    	
    	private var eventHandler:Function = null;
    	
    	public var fallThrough:Boolean = false;
    	
    	public static var BROWSER_EVENTS:Array = [
	        MouseEvent.MOUSE_OVER, MouseEvent.MOUSE_OUT,
	        MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_UP, MouseEvent.MOUSE_MOVE, 
	        MouseEvent.CLICK, MouseEvent.DOUBLE_CLICK,
	        MouseEvent.ROLL_OVER, MouseEvent.ROLL_OUT,
	        "resize", "focus", "blur"];
    	
    	public function Events(object:Object, element:Object, eventTypes:Array, fallThrough:Boolean = false) {
    		this.object = object;
    		this.element = element;
    		this.eventTypes = eventTypes;
    		this.fallThrough = fallThrough;
    		this.listeners = new Object();
    		
    		this.eventHandler = this.handleBrowserEvent;
    		
    		if (this.eventTypes != null) {
	            for (var i:int = 0; i < this.eventTypes.length; i++) {
	                this.listeners[ this.eventTypes[i] ] = new Array();
	            }
	        }
	        
	        if (this.element != null) {
	            this.attachToElement(element);
	        }
    	}
    	
    	public function destroy():void {
	        this.element = null;
	
	        this.listeners = null;
	        this.object = null;
	        this.eventTypes = null;
	        this.fallThrough = false;
	        this.eventHandler = null;
    	}
    	
    	public function addEventType(eventName:String):void {
    		if (!this.listeners[eventName]) {
    			this.listeners[eventName] = [];
    		}
    	}
    	
    	public function attachToElement(element:Object):void {
    		for (var i:int = 0; i < Events.BROWSER_EVENTS.length; i++) {
	            var eventType:String = Events.BROWSER_EVENTS[i];
	
	            if (this.listeners[eventType] == null) {
	                this.listeners[eventType] = new Array();
	            }
	            
	            //element.addEventListener(eventType, this.eventHandler);
	            new EventOL().observe(element, eventType, this.eventHandler, this.fallThrough);
	        }
	        new EventOL().observe(element, "dragstart", EventOL.stop, this.fallThrough);
    	}
    	
    	public function register(type:String, obj:Object, func:Function):void {
    		
    		if (func != null) {
    			if (obj == null) {
    				obj = this.object;
    			}
    			var listeners:Array = this.listeners[type];
    			if (listeners != null) {
    				listeners.push({obj: obj, func: func});
    			}
    		}
    	}
    	
    	public function registerPriority (type:String, obj:Object, func:Function):void {
    		
    		if (func != null) {
	            if (obj == null)  {
	                obj = this.object;
	            }
	            var listeners:Object = this.listeners[type];
	            if (listeners != null) {
	                listeners.unshift( {obj: obj, func: func} );
	            }
	        }
    	}
    	
    	public function unregister (type:String, obj:Object, func:Function):void {
    		
	        if (obj == null)  {
	            obj = this.object;
	        }
	        var listeners:Object = this.listeners[type];
	        if (listeners != null) {
	            for (var i:int = 0; i < listeners.length; i++) {
	                if (listeners[i].obj == obj && listeners[i].func == func) {
	                    listeners.splice(i, 1);
	                    break;
	                }
	            }
	        }
    	}
    	
    	public function remove(type:String):void {
			if (this.listeners[type] != null) {
	            this.listeners[type] = new Array();
	        }
    	}
    	
    	public function triggerEvent(type:String, evt:Object = null):void {
	        if (evt == null) {
	            evt = new MouseEvent(type);
	        }

	        var listeners:Object = (this.listeners[type]) ?
	                            this.listeners[type].slice() : null;
	        if ((listeners != null) && (listeners.length > 0)) {
	            for (var i:int = 0; i < listeners.length; i++) {
	                var callback:Object = listeners[i];
	                var continueChain:Object;
	                if (callback.obj != null) {
	                    continueChain = callback.func.call(callback.obj, evt);
	                } else {
	                    continueChain = callback.func(evt);
	                }
	    
	                if ((continueChain != null) && (continueChain == false)) {
	                    break;
	                }
	            }
	            if (!this.fallThrough) {           
	                EventOL.stop(evt, true);
	            }
	        }
    	}
    	
    	public function handleBrowserEvent(evt:Object):void {
	        this.triggerEvent(evt.type, evt)
    	}
    	
    	public function getMousePosition(evt:Object):Pixel {
	        return new Pixel(evt.stageX, evt.stageY); 
    	}
    	
	}
}