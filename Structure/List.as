package XGameEngine.Structure
{
	import fl.transitions.Fade;
	
	import flash.geom.Point;
	
	/**
	 * 基础的线性表 
	 */
	public class List extends AbstractCollection
	{
		
		protected var arr:Array=[];

	
		/**
		 * 
		 * @param flag_canNull
		 * @param flag_canSame
		 * @param comparefun
		 * 
		 */		
		public function List(flag_canNull:Boolean=false,flag_canSame:Boolean=false,comparefun:Function=null)
		{
			super(flag_canNull,flag_canSame,comparefun);
		}
		
		/**
		 *添加 
		 * @param a
		 * @return 
		 * 
		 */		
		public function add(a:Object)
		{
			
			if(a==null&&flag_canNull==false)
			{
				//不能为空 报错	
				throw new Error("the "+a+" is null!")
			}
			
			if (contains(a)&&flag_canSame==false)
			{
				//不能重复 报错	
				throw new Error("the "+a+" has Exist!")

			}
			else
			{
				
				arr.push(a);
			}
			
			
		}
		
		
		/**
		 * 浅克隆 
		 * @return 
		 * 
		 */		
		 public function shallowClone():List
		{
			var list:List=new List();
			list.addAll(arr);
			return list;

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
		
		/**
		 * 过滤 
		 * @param fun
		 * @return 
		 * 
		 */		
		public function filter(fun:Function):List
		{
			
			var fun2:Function=function(element:*, index:int, arr:Array):Boolean {
            return fun(element);
        }

			
			var arr:Array = arr.filter(fun2);
			
			var list:List=new List(flag_canNull,flag_canSame);
			list.addAll(arr);
			
			return list;
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
				//如果没有设置相等检测方法 默认比较引用相等
				if(comparefun==null)
				{
					if (q == o)
					{
						return true;
					}
				}
				else
				{
				//使用compareFun比较
					return comparefun(q, o);
				}
			}
			
			return false;
		}
		
		
		public function forEach(fun:Function):void 
		{
		var fun2:Function=function(element:*, index:int, arr:Array):void {
           fun(element);
        }

			arr.forEach(fun2);
		}
		
		public function addAll(arr:Array):void
		{
			for each(var q:Object in arr)
			{
				add(q);
			}
			
		}
		
		
		public function addAllList(list:List):void
		{
			for each(var q:Object in list.Raw)
			{
				add(q);
			}
			
		}
	}
	
}