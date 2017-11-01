package XGameEngine.Collections.Graph
{
	public class SearchType
	{
		/**
		 *bfs返回最短路径
		 */		
		public static var BFS:String="bfs";
		/**
		 *dfs不一定返回最短路径 
		 */		
		public static var DFS:String="dfs";
		/**
		 *计算带权图最短路径时效率比bfs好
		 */		
		public static var DIJKSTRA:String="DIJKSTRA";
		/**
		 *效率最高 但是如果启发因子设计有问题可能返回的不是最短路径 
		 */		
		public static var ASTAR:String="a*";
		
	}
}