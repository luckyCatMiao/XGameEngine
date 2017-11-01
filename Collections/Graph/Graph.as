package XGameEngine.Collections.Graph
{
	import XGameEngine.Util.Error.ParamaterError;
	import XGameEngine.GameEngine;
	import XGameEngine.Collections.Graph.GraphNode;
	import XGameEngine.Collections.Graph.Search.ASTARSearch;
	import XGameEngine.Collections.Graph.Search.BFSSearch;
	import XGameEngine.Collections.Graph.Search.BaseSearch;
	import XGameEngine.Collections.Graph.Search.DFSSearch;
	import XGameEngine.Collections.Graph.Search.DijkstraSearch;
	import XGameEngine.Collections.List;
	import XGameEngine.Collections.Map;

	public class Graph
	{
		
		
		public function Graph()
		{
			this.pathManager=new PathManager();	
			
		}
		
		/**
		 * 保存所有节点
		 */
		protected var list:List=new List(false,true);
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
		private var pathManager:PathManager;
		
		
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
		public function search(start:Object, end:Object,type:String,aStarFun:Function=null):Path
		{
			var node1:GraphNode=CheckContainNode(start);
			var node2:GraphNode=CheckContainNode(end);
			var path:Path;
			
			//先查询是否有最优路径
			if((path=pathManager.queryBestPath(node1,node2))!=null)
			{
				return path;
			}
			
			
			var s:BaseSearch
		
			
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
				
				//缓存该path
				if(path!=null)
				{
					pathManager.addBestPath(path);
				}

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
		
		
		/**
		 *开始计算所有点对点的最优路径 该任务会被拆分成多帧进行 
		 * 计算完成的最优路径会被放入缓存中
		 * @param progresslistener
		 * @param achieveListener
		 * 
		 */		
		public function cacluAllBestPath(progresslistener:Function,achieveListener:Function):void
		{
			
			new GraphBestPathcalculate(GameEngine.getInstance().stage,this,progresslistener,achieveListener).start();
		}
		
		/**
		 *设置一条路径到缓存中 之后查询最优路径时该路径将替换计算出来的最优路径 
		 * @param idList
		 * 
		 */		
		public function setBestPath(idList:List):void
		{
			//设置小于三个路径点的最优路径没有意义
			if(idList.size<3)
			{
				throw new ParamaterError();
			}
			else
			{
				pathManager.addBestPath(createPathByIdList(idList));
				
			}
			
		}
		
		private function createPathByIdList(idList:List):Path
		{
			var path:Path=new Path(this);
			for(var i:int=0;i<idList.size;i++)
			{
				var id:int=idList.get(i) as int;
				var node:GraphNode=getNodeByID(id);
				
				path.push(node);
			}
			
			return path;
		}
		
	}
}
import XGameEngine.Collections.Graph.Graph;
import XGameEngine.Collections.Graph.GraphNode;
import XGameEngine.Collections.Graph.Path;
import XGameEngine.Collections.Graph.SearchType;
import XGameEngine.Collections.List;
import XGameEngine.Collections.Map;

import flash.display.Stage;
import flash.events.Event;

class GraphBestPathcalculate
{
	private var s:Stage;
	private var g:Graph;
	private var progresslistener:Function;
	private var achieveListener:Function;
	private var needCalcuPaths:List=new List(false,true);
	private var searchType:String;
	private var currentIndex:int=0;
	public function GraphBestPathcalculate(s:Stage,g:Graph,progresslistener:Function,achieveListener:Function)
	{
		this.s=s;
		this.g=g;
		this.progresslistener=progresslistener;
		this.achieveListener=achieveListener;
		//无权值图使用bfs
		//有权值图使用a*
		this.searchType=g.weightCalcuFun==null?SearchType.BFS:SearchType.ASTAR;
	
		//把所有需要计算的路径加入数组中(为点数的平方/2)
		//从起点到终点和从终点到起点只计算一条 路径管理器在返回的时候会自动处理
		for(var out:int=0;out<g.raw.length;out++)
		{
			for(var ins:int=out+1;ins<g.raw.length;ins++)
			{
				var node1:GraphNode=g.raw[out];
				var node2:GraphNode=g.raw[ins];
			
					var p:WaitCacluPath=new WaitCacluPath();
					p.startNode=node1;
					p.endNode=node2;
					
					needCalcuPaths.add(p);
				
			}
		}
		
	
	}
	
	protected function loop(event:Event):void
	{
	
	
		//一帧计算5条路径
		var i:int=0;
		while(i<10)
		{
			
			var p:WaitCacluPath=needCalcuPaths.get(currentIndex+i,false);
			if(p!=null)
			{
				g.search(p.startNode.value,p.endNode.value,searchType);
			}
			else
			{
				//计算结束
				if(achieveListener!=null)
				{
					achieveListener();
				}
				s.removeEventListener(Event.ENTER_FRAME,loop);
				break;
			}
			
			
			i++;	
		}
		
		
		currentIndex+=10;
		if(progresslistener!=null)
		{
			progresslistener(currentIndex/(needCalcuPaths.size));
		}
		
		
		
	}
	public function start()
	{
		s.addEventListener(Event.ENTER_FRAME,loop);
		
		
		
	}
}
class WaitCacluPath
{
	public var startNode:GraphNode;
	public var endNode:GraphNode;
}
class PathManager
{
	private var pathMaps:Map=new Map();
	
	public function addBestPath(path:Path):void
	{
		//每个map保存了一个起点到其他点的最优路径
		var startNode:GraphNode=path.startNode;
		var endNode:GraphNode=path.peak();
		
		var map:Map=pathMaps.get(startNode) as Map;
		if(map==null)
		{
			map=new Map();
			pathMaps.put(startNode,map);
		}
		map.put(endNode,path);
		
		
		
	}
	public function queryBestPath(node1:GraphNode, node2:GraphNode):Path
	{
		
		var path:Path;
		//先查找有没有起点到终点的路径
		if(pathMaps.get(node1)!=null)
		{
			path=(pathMaps.get(node1)as Map).get(node2) as Path
			if(path!=null)
			{
				return path.shallowClone();
			}
			
		}
		//查找终点到起点的路径 翻转一下后返回
		if(pathMaps.get(node2)!=null)
		{
			path=(pathMaps.get(node2)as Map).get(node1) as Path
			if(path!=null)
			{
				return path.reverse();
			}
		}
		
		return null;
		
		
	}

}