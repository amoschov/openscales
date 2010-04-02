package org.openscales.core.basetypes.LinkedList
{
	/**
	 * LinkedList
	 * Generic linked list implementation
	 *
	 * @author slopez
	 */
	public class LinkedList implements ILinkedList
	{
		private var _head:ILinkedListNode = null;
		private var _tail:ILinkedListNode = null;
		private var cpt:uint=0;

		public function LinkedList(){
		}

		public function get head():ILinkedListNode{
			return this._head;
		}

		public function get tail():ILinkedListNode{
			return this._tail;
		}

		public function insertAfter(node:ILinkedListNode, after:String):Boolean{
			if(this._head==null)
				return false;
			if(this._head.uid==after) {
				node.nextNode=this._head.nextNode;
				node.previousNode=this._head;
				this._head.nextNode=node;
				cpt++;
				return true;
			}
			var eachNode:ILinkedListNode = this._head.nextNode;
			while(eachNode!=null && eachNode.uid!=after)
				eachNode = eachNode.nextNode;
			if(eachNode.uid==after){
				node.previousNode=eachNode;
				node.nextNode=eachNode.nextNode;
				eachNode.nextNode=node;
				cpt++;
				return true;
			}
			return false;
		}

		public function insertBefore(node:ILinkedListNode, before:String):Boolean{
			node.nextNode=null;
			node.previousNode=null;
			if(this._head==null)
				return false;
			if(this._head.uid==before) {
				node.nextNode=this._head;
				this._head.previousNode=node;
				this._head=node;
				cpt++;
				return true;
			}
			var eachNode:ILinkedListNode = this._head.nextNode;
			while(eachNode!=null && eachNode.uid!=before)
				eachNode = eachNode.nextNode;
			if(eachNode.uid==before){
				node.previousNode=eachNode.previousNode;
				node.nextNode=eachNode;
				eachNode.previousNode=node;
				cpt++;
				return true;
			}
			return false;
		}

		public function insertHead(node:ILinkedListNode):void{
			cpt++;
			if(this._head==null) {
				this._head = node;
				this._tail = node;
				return;
			}
			this._head.previousNode = node;
			node.nextNode = this._head;
			this._head = node;
		}

		public function insertTail(node:ILinkedListNode):void{
			cpt++;
			node.previousNode=null;
			node.nextNode=null;
			if(this._tail==null) {
				this._head = node;
				this._tail = node;
				return;
			}
			this._tail.nextNode = node;
			node.previousNode = this._tail;
			this._tail = node;
		}

		public function removeHead():void{
			if(this._head!=null) {
				cpt--;
				if(this._head.nextNode==null) {
					this._tail = null;
					this._head = null;
					return;
				}
				this._head = this._head.nextNode;
				this._head.previousNode.clear();
				this._head.previousNode=null;
			}
		}

		public function removeTail():void{
			if(this._tail!=null) {
				cpt--;
				if(this._tail.previousNode==null) {
					this._head==null;
					this._tail==null;
					return;
				}
				this._tail = this._tail.previousNode;
				this._tail.nextNode.clear();
				this._tail.nextNode=null;
			}
		}

		public function moveTail(UID:String):Boolean{
			var node:ILinkedListNode;
			if(this._head==null)
				return false;
			if(this._tail.uid==UID)
				return true;
			if(this._head.uid==UID) {
				node = this._head;
				this._head = this._head.nextNode;
				node.nextNode=null;
				node.previousNode=this._tail;
				this._tail.nextNode=node;
				this._tail=node;
				return true;
			}
			node = this._head;
			while(node.uid != UID && node.nextNode!=null) {
				node = node.nextNode;
			}
			if(node.uid == UID){
				node.previousNode.nextNode = node.nextNode;
				node.nextNode.previousNode = node.previousNode;
				node.nextNode=null;
				node.previousNode=this._tail;
				this._tail.nextNode=node;
				this._tail = node;
				return true;
			}
			return false;
		}

		public function moveHead(UID:String):Boolean{
			var node:ILinkedListNode;
			if(this._head==null)
				return false;
			if(this._head.uid==UID)
				return true;
			if(this._tail.uid==UID) {
				node = this._tail;
				this._tail = this._tail.previousNode;
				node.nextNode=this._head;
				node.previousNode=null;
				this._head.previousNode=node;
				this._head=node;
				return true;
			}
			node = this._head;
			while(node.uid != UID && node.nextNode!=null) {
				node = node.nextNode;
			}
			if(node.uid == UID){
				node.previousNode.nextNode = node.nextNode;
				node.nextNode.previousNode = node.previousNode;
				node.previousNode=null;
				node.nextNode=this._head;
				this._head.previousNode=node;
				this._head = node;
				return true;
			}
			return false;
		}

		public function remove(UID:String):Boolean{
			var node:ILinkedListNode;
			if(this._head==null)
				return false;
			if(this._head.uid==UID) {
				cpt--;
				node = this._head;
				this._head = this._head.nextNode;
				node.clear();
				if(this._head != null)
					this._head.previousNode=null;
				return true;
			}
			if(this._tail.uid == UID) {
				cpt--;
				node = this._tail;
				this._tail=this._tail.previousNode;
				node.clear();
				this._tail.nextNode=null;
				return true;
			}
			node = this._head;
			while(node.uid != UID && node.nextNode!=null) {
				node = node.nextNode;
			}
			if(node.uid == UID){
				cpt--;
				node.previousNode.nextNode = node.nextNode;
				node.nextNode.previousNode = node.previousNode;
				node.clear();
				return true;
			}
			return false;
		}

		public function toArray():Array{
			var arr:Array = [];
			if(this._head==null)
				return arr;
			var node:ILinkedListNode = this._head;
			arr.push(node);
			while (null != (node = node.nextNode))
				arr.push(node);
			return arr;
		}

		public function getIndex(UID:String):int{
			var id:int = -1;
			var node:ILinkedListNode = this._head;
			var i:int = 0;
			while (null != node){
				if (node.uid == UID){
					id = i;
					break;
				}
				node = node.nextNode;
				i++; 
			}
			return id;
		}

		public function getUID(UID:String):ILinkedListNode{
			var node:ILinkedListNode = this._head;
			while (node != null){
				if (node.uid == UID){
					return node;
				}
				node = node.nextNode;
			}
			return null;
		}

		public function clear():void {
			if(this._head==null)
				return;
			if(this._head==this._tail){
				this._head=null;
				this._tail=null;
				return;
			}
			var node:ILinkedListNode = this._head.nextNode;
			this._head = null;
			while(node!=null){
				node=node.nextNode
				if(node.previousNode!=null)
					node.previousNode.clear();
			}
			this._tail.clear();
			this._tail=null;
		}

		public function get size():uint{
			return cpt;
		}
	}
}