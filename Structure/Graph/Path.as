package XGameEngine.Structure.Graph
{
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Stack;

	public class Path
	{
	
		private var list:List;
		public function Path(s:Stack)
		{
			this.list=s.toList();
		}
		
		public function toString():String
		{
			var s:String="";
			for(var i:int=0;i<list.size;i++)
			{
				s+=(list.get(i) as GraphNode).value+"->";
			}
			
			s=s.substr(0,s.length-2);
			
			return s;
		}
		
		
		
	}
}