package XGameEngine.Structure
{
	/**
	 *优先级队列 
	 * @author Administrator
	 * 
	 */	
	public class PriorityQuene
	{
		private var list:List;
		
		public function PriorityQuene(comparefun:Function,flag_canNull:Boolean=false,flag_canSame:Boolean=false)
		{
			this.list=new List(flag_canNull,flag_canSame,comparefun);
		}
		
		public function get Raw():Array
		{
			return list.Raw;
		}

		public function add(o:Object)
		{
			list.add(o);
			//进行排序
			list.sort();
		}
		
		public function removeFirst():Object
		{
			var o:Object=list.get(list.size-1);
			
			list.remove(o);
			return o;
		}
		
		public function remove(o:Object):Object
		{
			
			return list.remove(o);
		}
		public function peak():Object
		{
			
			return list.get(list.size-1);
		}

		public function empty():Boolean
		{
			return list.size==0
		}
		
		
		public function addAll(arr:Array):void
		{
			list.addAll(arr);
			list.sort();
		}
		
		
		public function addAllList(list:List):void
		{
			list.addAllList(list);
			list.sort();
			
		}
		
		public function toString():String
		{
			return list.toString();
		}
		
		
		
		public function removeAll(invalidPaths:List):void
		{
			list.removeAll(invalidPaths.Raw);
			
		}
	}
}