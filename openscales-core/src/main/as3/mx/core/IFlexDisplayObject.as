////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package mx.core
{

import flash.accessibility.AccessibilityProperties;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.IBitmapDrawable;
import flash.display.LoaderInfo;
import flash.display.Stage;
import flash.events.IEventDispatcher;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.geom.Transform;

/**
 *  The IFlexDisplayObject interface defines the interface for skin elements.
 *  At a minimum, a skin must be a DisplayObject and implement this interface.
 */
public interface IFlexDisplayObject extends IBitmapDrawable, IEventDispatcher
{

   //include "IDisplayObjectInterface.as"

   /**
     *  @copy flash.display.DisplayObject#root
     */
    function get root():DisplayObject;


    /**
     *  @copy flash.display.DisplayObject#stage
     */
    function get stage():Stage;


    /**
     *  @copy flash.display.DisplayObject#name
     */
    function get name():String;
    function set name(value:String):void;


    /**
     *  @copy flash.display.DisplayObject#parent
     */
    function get parent():DisplayObjectContainer;


    /**
     *  @copy flash.display.DisplayObject#mask
     */
    function get mask():DisplayObject;
    function set mask(value:DisplayObject):void;


    /**
     *  @copy flash.display.DisplayObject#visible
     */
    function get visible():Boolean;
    function set visible(value:Boolean):void;


    /**
     *  @copy flash.display.DisplayObject#x
     */
    function get x():Number;
    function set x(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#y
     */
    function get y():Number;
    function set y(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#scaleX
     */
    function get scaleX():Number;
    function set scaleX(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#scaleY
     */
    function get scaleY():Number;
    function set scaleY(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#mouseX
     */
    function get mouseX():Number; // note: no setter


    /**
     *  @copy flash.display.DisplayObject#mouseY
     */
    function get mouseY():Number; // note: no setter


    /**
     *  @copy flash.display.DisplayObject#rotation
     */
    function get rotation():Number;
    function set rotation(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#alpha
     */
    function get alpha():Number;
    function set alpha(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#width
     */
    function get width():Number;
    function set width(value:Number):void;

    /**
     *  @copy flash.display.DisplayObject#height
     */
    function get height():Number;
    function set height(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#cacheAsBitmap
     */
    function get cacheAsBitmap():Boolean;
    function set cacheAsBitmap(value:Boolean):void;

    /**
     *  @copy flash.display.DisplayObject#opaqueBackground
     */
    function get opaqueBackground():Object;
    function set opaqueBackground(value:Object):void;


    /**
     *  @copy flash.display.DisplayObject#scrollRect
     */
    function get scrollRect():Rectangle;
    function set scrollRect(value:Rectangle):void;


    /**
     *  @copy flash.display.DisplayObject#filters
     */
    function get filters():Array;
    function set filters(value:Array):void;

    /**
     *  @copy flash.display.DisplayObject#blendMode
     */
    function get blendMode():String;
    function set blendMode(value:String):void;

    /**
     *  @copy flash.display.DisplayObject#transform
     */
    function get transform():Transform;
    function set transform(value:Transform):void;

    /**
     *  @copy flash.display.DisplayObject#scale9Grid
     */
    function get scale9Grid():Rectangle;
    function set scale9Grid(innerRectangle:Rectangle):void;

    /**
     *  @copy flash.display.DisplayObject#globalToLocal()
     */
    function globalToLocal(point:Point):Point;

    /**
     *  @copy flash.display.DisplayObject#localToGlobal()
     */
    function localToGlobal(point:Point):Point;

    /**
     *  @copy flash.display.DisplayObject#getBounds()
     */
    function getBounds(targetCoordinateSpace:DisplayObject):Rectangle;

    /**
     *  @copy flash.display.DisplayObject#getRect()
     */
    function getRect(targetCoordinateSpace:DisplayObject):Rectangle;

    /**
     *  @copy flash.display.DisplayObject#loaderInfo
     */
    function get loaderInfo() : LoaderInfo;

    /**
     *  @copy flash.display.DisplayObject#hitTestObject()
     */
    function hitTestObject(obj:DisplayObject):Boolean;

    /**
     *  @copy flash.display.DisplayObject#hitTestPoint()
     */
    function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean=false):Boolean;

    /**
     *  @copy flash.display.DisplayObject#accessibilityProperties
     */
    function get accessibilityProperties() : AccessibilityProperties;
    function set accessibilityProperties( value : AccessibilityProperties ) : void;
    

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------


	//----------------------------------
	//  measuredHeight
	//----------------------------------

	/**
	 *  The measured height of this object.
	 *
	 *  <p>This is typically hard-coded for graphical skins
	 *  because this number is simply the number of pixels in the graphic.
	 *  For code skins, it can also be hard-coded
	 *  if you expect to be drawn at a certain size.
	 *  If your size can change based on properties, you may want
	 *  to also be an ILayoutManagerClient so a <code>measure()</code>
	 *  method will be called at an appropriate time,
	 *  giving you an opportunity to compute a <code>measuredHeight</code>.</p>
	 */
	function get measuredHeight():Number;

	//----------------------------------
	//  measuredWidth
	//----------------------------------

	/**
	 *  The measured width of this object.
	 *
	 *  <p>This is typically hard-coded for graphical skins
	 *  because this number is simply the number of pixels in the graphic.
	 *  For code skins, it can also be hard-coded
	 *  if you expect to be drawn at a certain size.
	 *  If your size can change based on properties, you may want
	 *  to also be an ILayoutManagerClient so a <code>measure()</code>
	 *  method will be called at an appropriate time,
	 *  giving you an opportunity to compute a <code>measuredHeight</code>.</p>
	 */
	function get measuredWidth():Number;


	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Moves this object to the specified x and y coordinates.
	 * 
	 *  @param x The new x-position for this object.
	 * 
	 *  @param y The new y-position for this object.
	 */
	function move(x:Number, y:Number):void;

	/**
	 *  Sets the actual size of this object.
	 *
	 *  <p>This method is mainly for use in implementing the
	 *  <code>updateDisplayList()</code> method, which is where
	 *  you compute this object's actual size based on
	 *  its explicit size, parent-relative (percent) size,
	 *  and measured size.
	 *  You then apply this actual size to the object
	 *  by calling <code>setActualSize()</code>.</p>
	 *
	 *  <p>In other situations, you should be setting properties
	 *  such as <code>width</code>, <code>height</code>,
	 *  <code>percentWidth</code>, or <code>percentHeight</code>
	 *  rather than calling this method.</p>
	 * 
	 *  @param newWidth The new width for this object.
	 * 
	 *  @param newHeight The new height for this object.
	 */
	function setActualSize(newWidth:Number, newHeight:Number):void;
}

}
