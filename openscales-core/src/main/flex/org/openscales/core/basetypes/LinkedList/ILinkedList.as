package org.openscales.core.basetypes.LinkedList
{
	/**
	 * LinkedList interface
	 * Interface to describe generic linked list
	 *
	 * @author slopez
	 */
	public interface ILinkedList
	{
		/**
		 * The head of the linked list
		 */
		function get head():ILinkedListNode;

		/**
		 * The tail of the linked list
		 */
		function get tail():ILinkedListNode;

		/**
		 * Inserts a node after another
		 * if af
		 * @param node The new node
		 * @param before The uid after which to place the new node
		 * 
		 * @return true if inserted, else false
		 */
		function insertAfter(node:ILinkedListNode, after:String):Boolean;

		/**
		 * Inserts a node before another
		 * @param node The new node
		 * @param before The uid before which to place the new node
		 * 
		 * @return true if inserted, else false
		 */
		function insertBefore(node:ILinkedListNode, before:String):Boolean;

		/**
		 * Inserts a node at the head of the linked list
		 * @param node The new node to insert
		 */
		function insertHead(node:ILinkedListNode):void;

		/**
		 * Inserts a node at the tail of the linked list
		 * @param node The new node to insert
		 */
		function insertTail(node:ILinkedListNode):void;

		/**
		 * Removes a node at the head of the linked list
		 * @return the firdt node
		 */
		function removeHead():void;

		/**
		 * Removes a node at the tail of the linked list
		 * @return the last node
		 */
		function removeTail():void;

		/**
		 * move a node to the tail
		 * @param UID The uid to move
		 * 
		 * @return true if found and moved
		 */
		function moveTail(UID:String):Boolean;

		/**
		 * move a node to the head
		 * @param UID The uid to move
		 * 
		 * @return true if found and moved
		 */
		function moveHead(UID:String):Boolean

		/**
		 * Removes a uid from the linked list
		 * @param UID The uid to remove
		 * 
		 * @return true if found and removed, else false
		 */
		function remove(UID:String):Boolean;

		/**
		 * Returns the list as an array
		 */
		function toArray():Array;

		/**
		 * Get the index of a uid.
		 * @param uid the searched uid.
		 * 
		 * @return int the index of the uid if exists, else -1
		 */
		function getIndex(UID:String):int;

		/**
		 * get the node identified by an UID
		 * @param uid the searched uid.
		 * 
		 * @return the node if exists, else null;
		 */
		function getUID(UID:String):ILinkedListNode;

		/**
		 * cleanup the linked list
		 */
		function clear():void;

		/**
		 * size of the linked list
		 */
		function get size():uint;
	}
}