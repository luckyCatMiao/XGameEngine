package XGameEngine.Structure.Graph
{
	import XGameEngine.Structure.List;

	public class GraphNode
	{
		/**
		 *导入导出的时候作为辅助值..不然xml很难写 
		 */		
		public var id:int;
		
		public var value:Object;
		
		public var linkedNodes:List=new List(false,true);
		
		
		public function toString()
		{
//			var s:String="";
//			for each(var n:GraphNode in linkedNodes.Raw)
//			{
//				s+=n.value+" ";
//			}

			
			return value.toString();
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