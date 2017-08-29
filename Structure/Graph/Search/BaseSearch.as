package XGameEngine.Structure.Graph.Search
{
	import XGameEngine.Structure.Graph.Graph;
	import XGameEngine.Structure.Graph.GraphNode;

	public class BaseSearch
	{
		protected var startNode:GraphNode;
		protected var endNode:GraphNode;
		protected var graph:Graph;
		public function BaseSearch(startNode:GraphNode,endNode:GraphNode,graph:Graph)
		{
			this.startNode=startNode;
			this.endNode=endNode;
			this.graph=graph;
		}
	}
}