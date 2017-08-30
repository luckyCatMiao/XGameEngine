package XGameEngine.Structure.Graph.Search
{
	import XGameEngine.Structure.Graph.Graph;
	import XGameEngine.Structure.Graph.GraphNode;
	import XGameEngine.Structure.Graph.Path;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;
	import XGameEngine.Structure.PriorityQuene;
	
	public class ASTARSearch extends BaseSearch
	{
		public function ASTARSearch(startNode:GraphNode, endNode:GraphNode, graph:Graph)
		{
			super(startNode, endNode, graph);
			startSearch();
		}
		
		private function startSearch():void
		{
			//a*和dijkstra和bfs唯一的区别是使用了启发因子 下一个加入的拓展点不一定使
			//路径花费最短 但是该路径的新节点距离目标最近
			
			
			//保存已经访问过的节点
			var hasVisitedNodes:Map=new Map();
			
			//设置初始节点为已访问
			hasVisitedNodes.put(startNode,"");
			
			//保存当前的路径组(使用优先级队列保存 这样就会优先拓展花费最低的)
			var nowPaths:PriorityQuene=new PriorityQuene(PathCostCompare);
			
			//废弃路径
			var invalidPaths:List=new List();
			
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
					var minCost:Number=Infinity;
					var minCostNode:GraphNode;
					var minCostPath:Path;
					//循环所有当前路径 找到一个扩展后路径总花费最少的节点
					for each(var nowPath:Path in nowPaths.Raw)
					{
						//获取该路径的最新节点
						var nowNode:GraphNode=nowPath.peak();
						//获取所有没有被访问过的节点
						var unVisits:List=GetUnVisitedLinkPoints(nowNode,hasVisitedNodes);
						//如果有的话
						if(unVisits.size>0)
						{
							//循环所有节点 和当前的最小花费做比较
							for each(var node:GraphNode in unVisits.Raw)
							{
								
								var v1:Object=nowNode.value;
								var v2:Object=node.value;
								//a*需要加上该节点到终点的花费计算 因此会离终点更近但是花费更高的点
								//会比离终点更远但是花费更低的点先拓展
								var cost:Number=graph.weightCalcuFun(v1,v2)+graph.weightCalcuFun(v2,endNode.value);
								//最新节点到该节点的花费加上 之前路径的累积花费
								cost+=nowPath.cost;
								if(cost<minCost)
								{
									minCost=cost;
									minCostNode=node;
									minCostPath=nowPath;
								}
							}
							
						}
							//否则移除该路径
						else
						{
							invalidPaths.add(nowPath);
						}
						
					}
					
					//删除废弃路径
					nowPaths.removeAll(invalidPaths);
					invalidPaths.clear();
					
					//如果最小节点非空
					if(minCostNode!=null)
					{
						
						if(minCostNode==endNode)
						{
							result=nowPath.push(minCostNode);
							return;
						}
						//此时扩展该节点并加入路径组
						nowPaths.add(minCostPath.shallowClone().push(minCostNode));
						
						
						//设置为已访问
						hasVisitedNodes.put(minCostNode,"");
					}
					
					
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