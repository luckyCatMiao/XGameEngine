package XGameEngine.Collections.Tree
{
	import XGameEngine.Collections.Graph.Graph;

	/**
	 *树 
	 * @author Administrator
	 * 
	 */	
	public class Tree
	{
		/**
		 *实际上包装了一个图 
		 */		
		protected var graph:Graph=new Graph();
		protected var root:*;
	
		public function Tree(rootValue:Object)
		{
			graph.addNode(rootValue);
			this.root=rootValue;
			
		}
		
		public function get size():int
		{
			//遍历累加
			return graph.raw.length;
		}

		public function addNode(value:Object,parent:Object)
		{
			graph.addNode(value);
			graph.linkNodeByValue(parent,value,false);
		}
		
		
		
	
		
	}
}