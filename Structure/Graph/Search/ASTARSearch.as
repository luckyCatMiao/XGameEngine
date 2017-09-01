package XGameEngine.Structure.Graph.Search
{
	import XGameEngine.Structure.Graph.Graph;
	import XGameEngine.Structure.Graph.GraphNode;
	import XGameEngine.Structure.Graph.Path;
	import XGameEngine.Structure.Graph.SpecialGraph.NavigationGraph.PositionValue;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;
	import XGameEngine.Structure.PriorityQuene;
	import XGameEngine.Structure.Stack;
	
	/**
	 *Dijkstra的另一种实现 不过不知道为什么很卡 我感觉会比原来快的
	 * 想了很久也不知道为什么 先放着吧
	 * @author Administrator
	 * 
	 */	
	public class ASTARSearch extends BaseSearch
	{
		private var fun:Function;
		public function ASTARSearch(startNode:GraphNode, endNode:GraphNode, graph:Graph,fun:Function)
		{
			super(startNode, endNode, graph);
			this.fun=fun;
			startSearch();
			
		}
		
		private function startSearch():void
		{
			//dijkstra和bfs唯一的区别是 dijkstra优先扩展权值低的边
			//因为每次都选择从起点开始花费最少的边(不是当前节点花费最少的边 是总路径的)
			//所以最后到达终点一定是花费最少的
			
			//保存已经访问过的节点
			var hasVisitedNodes:Map=new Map();
			hasVisitedNodes.put(startNode,"");
			
			//初始待扩展路径
			var path:Path=new Path(graph);
			path.push(startNode);
			
			//所有路径 根据总花费排序
			var nextPaths:List=new List(false,true,compare);
			
			
			//把初始可能路径添加到路径组
			for each(var e:GraphNode in startNode.linkedNodes.Raw)
			{
				//此时扩展该节点并加入路径组
				var possiblePath:PossiblePath=new PossiblePath(e,path,graph.weightCalcuFun);
				nextPaths.add(possiblePath);
				
			}
			nextPaths.sort();
			
			
			
			
			while(!nextPaths.empty())
			{
				
				//获得花费最小的路径
				var nowPath:PossiblePath=nextPaths.removeAt(nextPaths.size-1) as PossiblePath;
				
				
				//获取该路径的最新节点
				var nowNode:GraphNode=nowPath.nextNode;
				
				
				if(nowNode==endNode)
				{
					result=nowPath.path.push(nowNode);
					return;
				}
				
				var newPath:Path=nowPath.expandToPath();
				
				//如果此节点没有被访问过
				if(hasVisitedNodes.get(nowNode)==null)
				{
					//把该节点的所有未访问连接节点加入待拓展节点组
					for each(var expandNode:GraphNode in nowNode.linkedNodes.Raw)
					{
						if(hasVisitedNodes.get(expandNode)==null)
						{
							//此时扩展该节点并加入路径组
							var pp:PossiblePath=new PossiblePath(expandNode,newPath,graph.weightCalcuFun);
							nextPaths.add(pp);
							
						}
					}
				}
				
				//设置为已访问
				hasVisitedNodes.put(nowNode,"");
				
				
				nextPaths.sort();
			}
			
			
			
			
			
			
		}
		
		private function compare(p1:PossiblePath,p2:PossiblePath):int
		{
			//a*需要加上该节点到终点的花费计算 因此会离终点更近但是花费更高的点
			//会比离终点更远但是花费更低的点先拓展
		
			var cost2:Number=(p2.cost+fun(p2.nextNode.value,endNode.value));
			var cost1:Number=(p1.cost+fun(p1.nextNode.value,endNode.value));
			
			return cost2-cost1;
			
		}
		
	}
	
	
	
}
import XGameEngine.Structure.Graph.GraphNode;
import XGameEngine.Structure.Graph.Path;

/**
 *一个路径 加上下一个节点 以及他们的总花费 
 * @author Administrator
 * 
 */
class PossiblePath
{
	public var cost:Number;
	public var nextNode:GraphNode;
	public var path:Path;
	public function PossiblePath(expandNode:GraphNode,path:Path,weightCalcuFun:Function)
	{
		this.path=path;
		this.nextNode=expandNode;
		
		if(path.empty())
		{
			cost=0;
		}
		else
		{
			var nowPath:Path=path;
			//获取该路径的最新节点
			var nowNode:GraphNode=nowPath.peak();
			
			var v1:Object=nowNode.value;
			var v2:Object=expandNode.value;
			
			//计算总的花费
			if(weightCalcuFun!=null)
			{
				cost=weightCalcuFun(v1,v2)+path.cost;;
			}
			else
			{
				cost=1+path.cost;
			}
		}
		
		
	}
	
	public function expandToPath():Path
	{
		// TODO Auto Generated method stub
		return path.shallowClone().push(nextNode);
	}
	
	public function toString():String
	{
		// TODO Auto Generated method stub
		return path.toString()+"->"+nextNode.toString();
	}
	
	
	
}