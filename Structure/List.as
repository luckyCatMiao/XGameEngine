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
			
			if (flag_canSame==false&&contains(a))
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
		
		 public function set(index:int,v:Object)
		 {
			 
			 checkIndex(index);
				arr[index]=v;;
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
					return comparefun(q, o)==0;
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
			if(list==null)
			{
				return;
			}
			for each(var q:Object in list.Raw)
			{
				add(q);
			}
			
		}
		
		/**
		 *移除所有 
		 * @param needDelete
		 * 
		 */		
		public function removeAll(arr:Array):void
		{
			for each(var o:Object in arr)
			{
			remove(o);	
			}
			
		}
		
		
		/**
		 *排序 使用插入排序 
		 * 
		 */		
		public function sort():void
		{
			if(comparefun==null)
			{
				throw new Error("无法排序");
			}
			else
			{
				//为每个数排序
				for(var i:int=1;i<size;i++)
				{
					var nowValue:Object=get(i);
					//为该数寻找合适的位置 左边是已经排好的
					for(var a:int=0;a<i;a++)
					{
						var loopValue:Object=get(a);
						//如果小于左边的数 则插入在该位置
						if(comparefun(nowValue, loopValue)<0)
						{
							var cache:Object=nowValue;
							removeAt(i);
							addAt(a,cache);
							
							
							break;
						}
						
						
					}
				}
				
				
			
			}
			
		}
		
		private function removeAt(index:int):void
		{
			arr.splice(index,1);
			
		}
		
		private function addAt(index:int, o:Object):void
		{
			checkIndex(index);
			arr.splice(index,0,o);
			
		}
		
		/**
		 *在索引处替换
		 * @param value
		 * @param index
		 * 
		 */		
		public function replace(value:Object, index:int):void
		{
			checkIndex(index);
			arr.splice(index, 1,value);
			
		}
		
		public function isEmpty():Boolean
		{
			// TODO Auto Generated method stub
			return size==0;
		}
	}
	
}