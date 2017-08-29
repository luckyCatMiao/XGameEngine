package XGameEngine.Structure.Graph
{
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Stack;

	public class Path
	{
	
		private var list:List;
		private var _cost:Number;
		/**
		 *所从属的图 
		 */		
		private var g:Graph;
		
		public function Path(s:Stack,g:Graph)
		{
			this.list=s.toList();
			this.g=g;
			calcuCost();
		}
		
		private function calcuCost():void
		{
			//计算花费
			//如果没有设置权值方法 则默认的权值为1
			if(g.weightCalcuFun==null)
			{
				//花费直接设置为边的数量 边数为点数-1
				_cost=list.size-1;
			}
			else
			{
				var allCost:Number=0;
				for(var i:int=0;i<list.size-1;i++)
				{
					var v1:Object=(list.get(i) as GraphNode).value;
					var v2:Object=(list.get(i+1) as GraphNode).value;
					
					allCost+=g.weightCalcuFun(v1,v2);
				}
				_cost=allCost;
				
			}
			
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
		
		
	}
}