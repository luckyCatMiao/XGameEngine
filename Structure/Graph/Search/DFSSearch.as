package XGameEngine.Structure.Graph.Search
{
	import XGameEngine.Structure.Graph.Graph;
	import XGameEngine.Structure.Graph.GraphNode;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;
	import XGameEngine.Structure.Stack;
	
	/**
	 *深度优先搜索 (权值对dfs没什么用 因为反正也不是返回最短路径)
	 * @author Administrator
	 * 
	 */	
	public class DFSSearch extends BaseSearch
	{
		
		
		
		public function DFSSearch(startNode:GraphNode, endNode:GraphNode, graph:Graph)
		{
			super(startNode, endNode, graph);
			
			startSearch();
		}
		
		private function startSearch():void
		{
			
			//保存当前的路径
			var nowPath:Stack=new Stack();
			
			//保存已经访问过的节点
			var hasVisitedNodes:Map=new Map();
			
			//保存当前进行操作的节点
			var nowNode:GraphNode=startNode;
			
			//将初始节点压入路径
			nowPath.push(nowNode);
			
			//设置初始节点为已访问
			hasVisitedNodes.put(startNode,"");
			
			while(true)
			{
			
				//判断当前节点是不是结束节点
				if(nowNode.equals(endNode))
				{
					
					break;
				}
				
				//找到一个没有被访问过的临接节点
				var newNode:GraphNode=GetUnVisitedLinkPoint(nowNode,hasVisitedNodes);
				
				//如果该节点的所有连接节点都访问过了
				if(newNode==null)
				{
					
					//尝试退回到该节点的上一个节点
					
					//如果当前节点是最后一个节点
					//查找失败 返回null
					if(nowPath.size()==1)
					{
						
						return;
					}
					else
					{	//回退节点
						nowPath.pop();
						nowNode=nowPath.peak();
					}
				}
				else
				{
					//转变当前节点为连接的节点
					//设置节点已经访问
					nowNode=newNode;
					
					nowPath.push(newNode);
					hasVisitedNodes.put(newNode,"");
					
				}
				
			}
			
			
					this.result=createPathByStack(nowPath);
			
		}
	}
}