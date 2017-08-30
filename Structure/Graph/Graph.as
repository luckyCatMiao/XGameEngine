package XGameEngine.Structure.Graph
{
	import XGameEngine.Structure.Graph.GraphNode;
	import XGameEngine.Structure.Graph.Search.ASTARSearch;
	import XGameEngine.Structure.Graph.Search.BFSSearch;
	import XGameEngine.Structure.Graph.Search.BaseSearch;
	import XGameEngine.Structure.Graph.Search.DFSSearch;
	import XGameEngine.Structure.Graph.Search.DijkstraSearch;
	import XGameEngine.Structure.List;

	public class Graph
	{
		public function Graph()
		{
		}
		
		/**
		 * 保存所有节点
		 */
		private var list:List=new List();

		public function get weightCalcuFun():Function
		{
			return _weightCalcuFun;
		}

		private var _weightCalcuFun:Function;
		
		
		/**
		 * 连接两个节点(节点必须已经添加到图中)
		 * @param value1
		 * @param value2
		 * @param twoDirection
		 * @return
		 */
		public function linkNode(value1:Object,value2:Object,twoDirection:Boolean=true)
		{
			
			var node1:GraphNode=CheckContainNode(value1);
			var node2:GraphNode=CheckContainNode(value2);
			
			
			node1.linkedNodes.add(node2);
			if(twoDirection)
			{
				node2.linkedNodes.add(node1);
			}
			
		}
		
		
		/**
		 *设置计算权值的方法 接受两个存放在node里的value变量 返回一个Number值 
		 * @param f
		 * @return 
		 * 
		 */		
		public function set weightCalcuFun(f:Function)
		{
			this._weightCalcuFun=f;
		}
		
		
		/**
		 *检查是否含有指定点 有的话返回 否则报错 
		 * @param value
		 * @return 
		 * 
		 */		
		private function CheckContainNode(value:Object):GraphNode
		{
				var has:Boolean=false;
				for each(var element:GraphNode in list.Raw)
				{
					if(element.value==value)
					{
						return element;
					}
				}
				
				if(!has)
				{
					throw new Error("图不包含该节点");
				}
			
			return null;
			
		}
		
		
		/**
		 *添加一个节点 
		 * @param value
		 * @return 
		 * 
		 */		
		public function addNode(value:Object)
		{
			var node:GraphNode=new GraphNode();
			node.value=value;
			list.add(node);
			
		}
		
		/**
		 *进行搜索 
		 * @param start
		 * @param end
		 * @param type
		 * 
		 */		
		public function search(start:Object, end:Object,type:String=null):Path
		{
			var node1:GraphNode=CheckContainNode(start);
			var node2:GraphNode=CheckContainNode(end);
			
			
			var s:BaseSearch
			var path:Path;
			
			if(node1!=null&&node2!=null)
			{
				if(type==SearchType.BFS)
				{
					s=new BFSSearch(node1,node2,this);
				}	
				else if(type==SearchType.DFS)
				{
					s=new DFSSearch(node1,node2,this);
					
				}
				else if(type==SearchType.DIJKSTRA)
				{
					s=new DijkstraSearch(node1,node2,this);
				}	
				else if(type==SearchType.ASTAR)
				{
					s=new ASTARSearch(node1,node2,this);
				}
				else
				{
					throw new Error("未知搜索类型");
				}
				
				path=s.getPath();
				return path;
				
				
			}
			else
			{
				throw new Error("图不包含该节点");
			}
			
			
			
		}
		
		public function getLinkedPoint(value:Object) {
			CheckContainNode(value);
			
		
			for each(var node:GraphNode in list.Raw)
			{
				if(node.value==value)
				{
					return node.linkedNodes;
				}
			}
			
			return null;
		}
	}
}