package XGameEngine.Structure.Graph.Search
{
	import XGameEngine.Constant.Error.AbstractMethodError;
	import XGameEngine.Structure.Graph.Graph;
	import XGameEngine.Structure.Graph.GraphNode;
	import XGameEngine.Structure.Graph.Path;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;
	import XGameEngine.Structure.Stack;

	public class BaseSearch
	{
		/**
		 *搜索结果(如果没有这样一条路径就是null) 
		 */		
		protected var result:Path;

		
		protected var startNode:GraphNode;
		protected var endNode:GraphNode;
		protected var graph:Graph;
		public function BaseSearch(startNode:GraphNode,endNode:GraphNode,graph:Graph)
		{
			this.startNode=startNode;
			this.endNode=endNode;
			this.graph=graph;
		}
		
		public function getPath():Path
		{
			
			return result;
		}
		
		/**
		 *两点是否连通 
		 * @return 
		 * 
		 */		
		public function get linkAble()
		{
			return result!=null;
		}
		
		public function GetUnVisitedLinkPoint(node:GraphNode, hasVisited:Map) 
		{
			//获取所有连接点
			var linkPoints:List=node.linkedNodes;
			
			
			//找到一个没有访问过的点
			for each(var value:GraphNode in linkPoints.Raw)
			{
				if(hasVisited.get(value)==null)
				{
					return value;
				}
			}
			
			return null;
		}
		
		
		protected function createPathByStack(nowPath:Stack):Path
		{
			var path:Path=new Path(graph);
			var list:List=nowPath.toList();
			for(var i:int=0;i<list.size;i++)
			{
				path.push(list.get(i) as GraphNode);
			}
				
			return path;
			
		}		
	}
}