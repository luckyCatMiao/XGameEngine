package XGameEngine.Structure.Graph.Search
{
	import XGameEngine.Structure.Graph.Graph;
	import XGameEngine.Structure.Graph.GraphNode;
	import XGameEngine.Structure.Graph.Path;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;
	import XGameEngine.Structure.Stack;
	
	/**
	 *广度优先搜索 
	 * @author Administrator
	 * 
	 */	
	public class BFSSearch extends BaseSearch
	{
		/**
		 *搜索结果(如果没有这样一条路径就是null) 
		 */		
	
		
		public function BFSSearch(startNode:GraphNode,endNode:GraphNode,graph:Graph)
		{
			super(startNode,endNode,graph);
			
			if(graph.weightCalcuFun==null)
			{
				//无权值的搜索 更快一些
				startSearch();
			}
			else
			{
				//有权值的搜索 需要搜索完整个图才能得出结果
				startWeightSearch();
			}
		}
		
		private function startWeightSearch():void
		{
			
			//有权值的搜索 需要搜索完整个图才能得出结果
			
			//不保存搜索过的节点 因为有可能从另外一个节点访问该节点更有效率
			//唯一的限制是不能访问该路径已经存在的节点 因为这样一定会更慢
			//例如从1-5-4 4不能再次返回5 但是4可以访问一个已经被访问过的3
			
			
			//保存当前的路径组
			var nowPaths:List=new List();
			
			//初始待扩展路径
			var stack:Stack=new Stack();
			stack.push(startNode);
			
			//将初始节点压入一条初始路径			
			nowPaths.add(stack);
			
			//搜索完成的路径组(如果有多条路径到达同一点都会被计算出来)
			var resultPaths:List=new List();
			
			
			while(true)
			{
				//新的路径组 
				var newPaths:List=new List();
				
				//获取当前的路径
				for each(var nowPath:Stack in nowPaths.Raw)
				{
					//获取当前路径头节点的连接节点
					var linkedPoints:List=(nowPath.peak() as GraphNode).linkedNodes;
					
					
					//如果节点包含结束节点
					if(linkedPoints.contains(endNode))
					{
						nowPath.push(endNode);

						//加入一条完成路径 同时该路径不再拓展
						resultPaths.add(nowPath.shallowClone());
					}
					else
					{
						for each(var node:GraphNode in linkedPoints.Raw)
						{

							//如果该节点该路径之前没有访问过
							if(!nowPath.contains(node))
							{
								
								
								//创建新路径并添加到新路径组
								var newPath:Stack=nowPath.shallowClone();
								newPath.push(node);
								newPaths.add(newPath);
							}
							
						}
					}
					
					
				}
				
				//没有可拓展的新节点 此时所有可能的路径都被计算完毕
				if(newPaths.isEmpty())
				{
					
					break;
				}
				
				//将拓展节点组替换为新的
				nowPaths=newPaths;
				
			}
			
			//这个时候对每条路径计算权值 返回总花费最小的
			var minCost:Number=Infinity;
			var minCostPath:Path;
			for each(var s:Stack in resultPaths.Raw)
			{
				var path:Path=createPathByStack(s);
				if(path.cost<minCost)
				{
					minCost=path.cost;
					minCostPath=path
				}
			}
			
			
			this.result=minCostPath;
			
		}
	
		
		private function startSearch():void
		{
			
			//保存已经访问过的节点
			var hasVisitedNodes:Map=new Map();
			
			//设置初始节点为已访问
			hasVisitedNodes.put(startNode,"");
			
			//保存当前的路径组
			var nowPaths:List=new List();
			
			//初始待扩展路径
			var stack:Stack=new Stack();
			stack.push(startNode);
			
			//将初始节点压入一条初始路径			
			nowPaths.add(stack);
			
			
			while(true)
			{
				//新的路径组 
				var newPaths:List=new List();
				
				//获取当前的路径
				for each(var nowPath:Stack in nowPaths.Raw)
				{
					//获取当前路径头节点的连接节点
					var linkedPoints:List=(nowPath.peak() as GraphNode).linkedNodes;
					
					
					//如果节点包含结束节点
					if(linkedPoints.contains(endNode))
					{
						nowPath.push(endNode);
						this.result=createPathByStack(nowPath);
						return;
					}
					else
					{
						for each(var node:GraphNode in linkedPoints.Raw)
						{
							
						
							//如果该节点当前没有被访问过
							if(hasVisitedNodes.get(node)==null)
							{
								//设置当前节点为已经访问
								hasVisitedNodes.put(node,"");
								
								//创建新路径并添加到新路径组
								var newPath:Stack=nowPath.shallowClone();
								newPath.push(node);
								newPaths.add(newPath);
							}
							
						}
					}
					
					
				}
				
				//没有可拓展的新节点 返回Null
				if(newPaths.isEmpty())
				{
					
					return;
				}
				
				//将拓展节点组替换为新的
				nowPaths=newPaths;
				
			}
		}
		
	
		
	}
}