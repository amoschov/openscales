package org.openscales.core.basetypes.LinkedList
{
	import flash.display.Bitmap;
	
	import org.openscales.core.UID;

	/**
	 * LinkedListBitmapNode interface
	 * Linked list node that contain a bitmap
	 *
	 * @author slopez
	 */
	public class LinkedListBitmapNode implements ILinkedListNode
	{
		private var _uid:String=null;
		private var _data:Bitmap

		private var _previous:ILinkedListNode = null;
		private var _next:ILinkedListNode = null;
		public function LinkedListBitmapNode(data:Bitmap, uid:String=null)
		{
			if(uid != null && uid.length>0) {
				this._uid = uid;
			} else {
				var uID:UID=new UID();
				this._uid = uID.gen_uid();
			}
			this._data = data;
		}

		public function bitmap():Bitmap {
			return this._data;
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

		public function set uid(value:String):void{
			if(uid != null && uid.length>0)
				this._uid=value;
		}

		public function get uid():String {
			return this._uid;
		}
		public function equals(o:Object):Boolean
		{
			if( o is Bitmap && o == this._data)
				return true;
			return false;
		}
		
		public function clear():void{
			this._data = null;
			this._previous = null;
			this._next = null;
		}
		
	}
}