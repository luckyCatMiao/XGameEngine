package XGameEngine.Structure.List
{
	import XGameEngine.Structure.List;
	
	/**
	 * ...
	 * 每个值都为唯一的list 默认比较方法为==
	 */
	public class DifferentList extends List
	{
	
		public var throwErrorWhenSame:Boolean = false;
		private var equalWay:Function = null;
		
		
		override public function add(a:Object)
		{
			if (!hasExist(a))
			{
				arr.push(a);
			}
			else
			{
				//如果设置为重复添加报错 则报错 否则只是丢弃这个需要添加的物体
				if (throwErrorWhenSame)
				{
					
					throw new Error("the "+a+" has Exist!")
				}
			}
			
		}
		
		
		/**
		 * 设置方法 方法需要有以下签名
		 * fun(o1:object,o2:object):boolean
		 */
		public function setEqual(fun:Function)
		{
			//为了保持状态的一致 该方法只能设置一次
			if (equalWay == null)
			{
				equalWay = fun;
			}
			else
			{
				throw new Error("the equal function has exist!");
			}
			
			
			
		}
		
		
		private function hasExist(a:Object):Boolean
		{
			
			//过滤出相等的(如果有的话)
			var fun:Function = function(element:*):Boolean
			{
				if (equalWay == null)
				{
					//如果没有设置相等检测方法 默认比较引用相等
					return a == element;
				}
				else
				{
					return equalWay(a, element);
				}
			}
			var q:List = this.filter(fun);
			
			return q.size != 0;
			
		}
	}
	
}