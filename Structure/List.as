package XGameEngine.Structure
{
	import flash.geom.Point;
	
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
				for each(var o:Object in array)
				{
					arr.push(o);
				}
			}
		}
		
		public function add(a:Object)
		{
			arr.push(a);
		}
		
		public function clone():List
		{
			return new List(arr);

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
			var index:int = arr.indexOf(o);
			if (index != -1)
			{
			arr.splice(index, 1);
			}
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
			return "["+arr.toString()+"]";
		}
		
		
		
		/**
		 * 每个元素视作一个关联数组 查找是否有某个对象的key的值为value
		 * @param	value 
		 * @param	key
		 */
		public function find(value:Object, key:String):Object 
		{
		
			for each(var o:Object in arr)
			{	
				if (o[key] == value)
				{
					return o;
				}
			}
			
			return null;
		}
		
		public function contains(o:Object):Boolean 
		{
			for each(var q:Object in arr)
			{
				if (q == o)
				{
					return true;
				}
			}
			
			return false;
		}
		
	}
	
}