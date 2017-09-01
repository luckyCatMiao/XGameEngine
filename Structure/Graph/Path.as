package XGameEngine.Structure.Graph
{
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Stack;

	public class Path
	{
	
		private var list:List;
		private var _cost:Number=0;
		/**
		 *所从属的图 
		 */		
		private var g:Graph;
		
		public function Path(g:Graph)
		{
			list=new List();
			this.g=g;
			
		}
		
		public function push(node:GraphNode):Path
		{
			
			//每次添加节点都会增量计算花费
			list.add(node);
			if(list.size>1)
			{
				var cost:Number;
				//如果没有设置权值方法 则默认的权值为1
				if(g.weightCalcuFun==null)
				{
					cost=1;
				}
				else
				{
					var v1:Object=(list.get(list.size-1) as GraphNode).value;
					var v2:Object=(list.get(list.size-2) as GraphNode).value;
					cost=g.weightCalcuFun(v1,v2);
					
				}
			
				_cost+=cost;
			}
			
			return this;
		}
		
		
		
		
		public function toString():String
		{
			var s:String="";
			for(var i:int=0;i<list.size;i++)
			{
				s+=(list.get(i) as GraphNode).value+"->";
			}
			
			s=s.substr(0,s.length-2);
			
			return s;
		}
		
		/**
		 *路径总花费 
		 * @return 
		 * 
		 */		
		public function get cost()
		{
			return _cost;
			
		}
		
		
		public function shallowClone():Path 
		{
			var path:Path=new Path(g);
		
			for(var i=0;i<list.size;i++)
			{
				path.push(list.get(i) as GraphNode);
			}
			
			return path;
		}
		
		public function toList():List 
		{
			return list;
		}
		
		public function peak():GraphNode
		{
			return list.get(list.size-1) as GraphNode;
		}
		
		public function empty():Boolean
		{
			// TODO Auto Generated method stub
			return list.size==0;
		}
	}
}