package XGameEngine.Structure.Graph.Search
{
	import XGameEngine.Structure.Graph.Graph;
	import XGameEngine.Structure.Graph.GraphNode;
	import XGameEngine.Structure.Graph.Path;
	import XGameEngine.Structure.List;
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
		private var result:Path;
		
		public function BFSSearch(startNode:GraphNode,endNode:GraphNode,graph:Graph)
		{
			super(startNode,endNode,graph);
			
			startSearch();
		}

		public function getPath():Path
		{
			
			return result;
		}
		
		private function startSearch():void
		{

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
						createPathByStack(nowPath);
						return;
					}
					else
					{
						for each(var node:GraphNode in linkedPoints.Raw)
						{
							//如果该路径此前不包含该节点(否则两个相互连接的节点可能导致路径不停往返)
							if(!(stack.contains(node)))
							{
							
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
		
		private function createPathByStack(nowPath:Stack):void
		{
			this.result=new Path(nowPath);
			
		}		
		
	}
}