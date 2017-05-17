package XGameEngine.Structure
{
	
	/**
	 * ...
	 * @author o
	 */
	public class List 
	{
		private var arr:Array=[];
		
		public function List(array:Array=null)
		{
			if (array != null)
			{
				this.arr = array;
			}
		}
		
		public function add(a:Object)
		{
			arr.push(a);
		}
		
		public function get(index:int):Object
		{
			
			checkIndex(index);
			return arr[index];
		}
		
		public function get size():int
		{
			return arr.length;
		}
		
		public function get Raw():Array
		{
			return arr;
		}
		
		public function clear()
		{
			arr = [];
		}
		
		public function remove(o:Object)
		{
			var index:int=arr.indexOf(o);
			arr.splice(index, 1);
			
		}
		
		private function checkIndex(index:int)
		{
			if (index<0||index>size-1)
			{
				throw new Error("index is" +index+" ,but the list only have "+size+" elements")
			}
		}
		
		public function filter(fun:Function):List
		{
			
			var arr:Array = arr.filter(fun);
			
			
			return new List(arr);
		}
		
		public function toString():String 
		{
			return arr.toString();
		}
		
	}
	
}