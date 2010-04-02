package org.openscales.core.basetypes.LinkedList
{
	/**
	 * LinkedListNode interface
	 * Interface to describe generic node of a linked list
	 *
	 * @author slopez
	 */
	public interface ILinkedListNode
	{
		/**
		 * The previous node in the linked list
		 */
		function get previousNode():ILinkedListNode;
		function set previousNode(value:ILinkedListNode):void;
		
		/**
		 * The next node in the linked list
		 */
		function get nextNode():ILinkedListNode;
		function set nextNode(value:ILinkedListNode):void;

		/**
		 * the uid of the node
		 */
		function set uid(value:String):void;
		function get uid():String;
		
		/**
		 * Tests the equality of this node with a given object
		 * @param	o	An object with which to compare this node 
		 */
		function equals(o:Object):Boolean;
		
		/**
		 * cleanup before destroying the node
		 */
		function clear():void;
	}
}