package XGameEngine.Structure
{
	
	/**
	 * ...
	 * @author o
	 */
	public class List 
	{
		private var arr:Array=[];
		private var _size = 0;
		
		public function List()
		{
			
		}
		
		public function add(a:Object)
		{
			_size=arr.push(a);
		}
		
		public function get(index:int):Object
		{
			
			checkIndex(index);
			return arr[index];
		}
		
		public function get size():int
		{
			return _size;
		}
		
		
		private function checkIndex(index:int)
		{
			if (index<0||index>_size-1)
			{
				throw new Error("index is" +index+" ,but the list only have "+_size+" elements")
			}
		}
		
		
	}
	
}