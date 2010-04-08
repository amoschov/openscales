package org.openscales.core.basetypes.LinkedList
{
	/**
	 * AbstractLinkedListNode
	 * To prevent many duplicate code.
	 *
	 * @author slopez
	 */
	public class AbstractLinkedListNode implements ILinkedListNode
	{
		private var _previous:ILinkedListNode = null;
		private var _next:ILinkedListNode = null;
		private var _uid:String;

		public function AbstractLinkedListNode()
		{
		}

		public function get previousNode():ILinkedListNode
		{
			return this._previous;
		}
		
		public function set previousNode(value:ILinkedListNode):void
		{
			this._previous = value;
		}
		
		public function get nextNode():ILinkedListNode
		{
			return this._next;
		}
		
		public function set nextNode(value:ILinkedListNode):void
		{
			this._next = value;
		}
		
		public function set uid(value:String):void
		{
			this._uid = value;
		}
		
		public function get uid():String
		{
			return this._uid;
		}
		
		public function equals(o:Object):Boolean
		{
			return false;
		}
		
		public function clear():void
		{
			this._next = null;
			this._previous = null;
		}
		
	}
}