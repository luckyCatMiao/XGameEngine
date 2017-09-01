package XGameEngine.Structure
{
	import XGameEngine.Structure.Graph.GraphNode;

	public class Stack extends AbstractCollection
	{
		//内部使用数组存储数据
		private var list:List
		
		
		public function Stack(flag_canNull:Boolean=false,flag_canSame:Boolean=false,comparefun:Function=null)
		{
			list=new List(flag_canNull,flag_canSame,comparefun);
			super(flag_canNull,flag_canSame,comparefun);
		}
		
		
		
		public function size() {
			// TODO Auto-generated method stub
			return list.size;
		}
		
		public function push(obj:Object)
		{
			list.add(obj);
		}
		
		public function pop()
		{
			if(list.size>0)
			{
			var obj:Object=list.get(list.size-1);
			list.remove(obj);
			return obj;
			}
			else
			{	
				throw new Error("stack empty!!")
			}
		}
		
		public function peak()
		{
			if(list.size>0)
			{
				var obj:Object=list.get(list.size-1);
				return obj;
			}
			else
			{	
				throw new Error("stack empty!!")
			}
			
		}
		
		
		
		 public function shallowClone():Stack {
			
			var stack:Stack=new Stack(flag_canNull,flag_canSame,comparefun);
			for(var i=0;i<list.size;i++)
			{
				stack.push(list.get(i));
			}
			
			return stack;
		}
		 
		 public function toString() {
			 
			 
			 return list.toString();
		 }
		
		 public function isEmpty():Boolean
		 {
			 // TODO Auto Generated method stub
			 return size()==0;
		 }
		 
		 public function contains(o:Object):Boolean
		 {
			 return list.contains(o);
		 }
		 
		 public function toList():List
		 {
			 // TODO Auto Generated method stub
			 return list;
		 }
	}
}