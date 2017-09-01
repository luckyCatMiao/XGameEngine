package XGameEngine.Structure.Graph
{
	import XGameEngine.Constant.Error.ParamaterError;
	import XGameEngine.Structure.Graph.GraphNode;
	import XGameEngine.Structure.Graph.Search.ASTARSearch;
	import XGameEngine.Structure.Graph.Search.BFSSearch;
	import XGameEngine.Structure.Graph.Search.BaseSearch;
	import XGameEngine.Structure.Graph.Search.DFSSearch;
	import XGameEngine.Structure.Graph.Search.DijkstraSearch;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;

	public class Graph
	{
		
		
		public function Graph()
		{
			
			
		}
		
		/**
		 * 保存所有节点
		 */
		protected var list:List=new List();
		/**
		 *保存id对应关系(和上面那一份存的数据是一样的 删节点的时候也要删两个)
		 *(为什么不只用map存是因为...之前已经写了很多代码用list 不想改了) 
		 */		
		protected var map:Map=new Map();
		
		
		/**
		 *给节点分配的ID 
		 */		
		private var nowId:int=0

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
		public function linkNodeByValue(value1:Object,value2:Object,twoDirection:Boolean=true)
		{
			
			var node1:GraphNode=CheckContainNode(value1);
			var node2:GraphNode=CheckContainNode(value2);
			
			
			_linkNode(node1,node2,twoDirection);
			
		}
		
		private function _linkNode(node1:GraphNode, node2:GraphNode,twoDirection:Boolean):void
		{
			node1.linkedNodes.add(node2);
			if(twoDirection)
			{
				node2.linkedNodes.add(node1);
			}
			
		}
		
		public function get raw():Array
		{
			return list.Raw;
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
		 * @param id 如果由外部设置id 必须由外部保证id值唯一
		 * @return 
		 * 
		 */		
		public function addNode(value:Object,id:int=-1):int
		{
			
			var node:GraphNode=new GraphNode();
			node.value=value;
			list.add(node);
			if(id==-1)
			{
				node.id=++nowId;
				map.put(node.id,node);
				return nowId;
			}
			else
			{
				node.id=id;
				map.put(node.id,node);
				return id;
			}
			
		}
		
		/**
		 *进行搜索 
		 * @param start
		 * @param end
		 * @param type
		 * 
		 */		
		public function search(start:Object, end:Object,type:String=null,aStarFun:Function=null):Path
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
					if(aStarFun==null)
					{
						throw new ParamaterError();
					}
					s=new ASTARSearch(node1,node2,this,aStarFun);
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
		
		public function linkNodeByID(id1:int, id2:int,twoDirection:Boolean=true):void
		{
			var node1:GraphNode=getNodeByID(id1);
			var node2:GraphNode=getNodeByID(id2);
			
			if(node1!=null&&node2!=null)
			{
				_linkNode(node1,node2,twoDirection);
			}
			
		}
		
		private function getNodeByID(id:int):GraphNode
		{
			//如果由外部提供id点 但是id又不唯一 就会出现逻辑bug(为了效率起见没有在添加的时候检查id是否已经存在)
			
			
			
			return map.get(id) as GraphNode;
		}
	}
}