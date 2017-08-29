package XGameEngine.Structure.Graph
{
	import XGameEngine.Structure.List;

	public class GraphNode
	{
		public var value:Object;
		
		public var linkedNodes:List=new List();
		
		
		public function toString()
		{
			var s:String="";
			for each(var n:GraphNode in linkedNodes.Raw)
			{
				s+=n.value+" ";
			}
			
			return s;
		}
		
		public function equals(obj:Object) {
			
				if(obj is GraphNode)
				{
					
					return (obj as GraphNode).value==this.value;
				}
				else
				{
					return false;
				}
					
					
	}
	}
	
		
}