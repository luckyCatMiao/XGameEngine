package XGameEngine.Structure.Graph.Search
{
	import XGameEngine.Structure.Graph.Graph;
	import XGameEngine.Structure.Graph.GraphNode;
	import XGameEngine.Structure.Graph.Path;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;
	import XGameEngine.Structure.PriorityQuene;
	import XGameEngine.Structure.Stack;
	
	/**
	 *计算带权值的最短路径比较快 
	 * @author Administrator
	 * 
	 */	
	public class DijkstraSearch extends BaseSearch
	{
		public function DijkstraSearch(startNode:GraphNode, endNode:GraphNode, graph:Graph)
		{
			super(startNode, endNode, graph);
			
			startSearch();
		}
		
		private function startSearch():void
		{
			//dijkstra和bfs唯一的区别是 dijkstra优先扩展权值低的边
			//因为每次都选择从起点开始花费最少的边(不是当前节点花费最少的边 是总路径的)
			//所以最后到达终点一定是花费最少的
			

			//保存已经访问过的节点
			var hasVisitedNodes:Map=new Map();
			
			//设置初始节点为已访问
			hasVisitedNodes.put(startNode,"");
			
			//保存当前的路径组(使用优先级队列保存 这样就会优先拓展花费最低的)
			var nowPaths:PriorityQuene=new PriorityQuene(PathCostCompare);
			
			//初始待扩展路径
			var path:Path=new Path(graph);
			path.push(startNode);
			
			//将初始节点压入一条初始路径			
			nowPaths.add(path);
			
			while(true)
			{
		
				//如果路径组不为空
				if(!nowPaths.empty())
				{
					//获取当前总花费最短的路径
					var nowPath:Path=nowPaths.peak() as Path; 
					//如果包括终点 此时花费最小 返回
					if(nowPath.peak()==endNode)
					{
						result=nowPath;
						return;
					}
					
					//获取该路径的最新节点
					var nowNode:GraphNode=nowPath.peak();
					//如果有相邻节点
					if(nowNode.linkedNodes.size>0)
					{
						var minCost:Number=Infinity;
						var minCostNode:GraphNode;
						//获取所有相邻节点进行计算  花费最小的节点
						//(如果在此找到终节点并不一定是最小花费,最小花费在开头检查)
						for each(var node:GraphNode in nowNode.linkedNodes.Raw)
						{
							var v1:Object=nowNode.value;
							var v2:Object=node.value;
							var cost:Number=graph.weightCalcuFun(v1,v2);
							if(cost<minCost)
							{
								minCost=cost;
								minCostNode=node;
							}
						}
						//扩展该节点并加入路径组
						nowPaths.add(nowPath.shallowClone().push(minCostNode));
						
					}
					//否则移除该路径 进行下一次循环
					else
					{
						nowPaths.remove(nowPath);
						continue;
					}
					
					
					//如果有终点 直接返回
					
					//否则获取花费最低的节点 进行拓展
				}
				else
				{
					break;
				}
				
				
				
			}
			
		}
		
		private function PathCostCompare(p1:Path,p2:Path):int
		{
			//path的cost根据weightCalcuFun计算 然后队列使用cost排序
			
			return p1.cost-p2.cost;
			
		}
	}
}