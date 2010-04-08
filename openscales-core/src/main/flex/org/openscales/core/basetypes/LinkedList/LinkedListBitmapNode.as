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
	public class LinkedListBitmapNode extends AbstractLinkedListNode
	{
		private var _uid:String=null;
		private var _data:Bitmap

		public function LinkedListBitmapNode(data:Bitmap, uid:String=null)
		{
			if(uid != null && uid.length>0) {
				this.uid = uid;
			} else {
				var uID:UID=new UID();
				this.uid = uID.gen_uid();
			}
			this._data = data;
		}

		public function bitmap():Bitmap {
			return this._data;
		}

		override public function equals(o:Object):Boolean
		{
			if( o is Bitmap && o == this._data)
				return true;
			return false;
		}
		
		override public function clear():void{
			this._data = null;
			super.clear();
		}
		
	}
}