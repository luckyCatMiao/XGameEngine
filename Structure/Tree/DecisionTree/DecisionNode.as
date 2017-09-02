package XGameEngine.Structure.Tree.DecisionTree
{
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;

	/**
	 *包含一个问题和几个回复 回复的数量必须和当前所属于树的子节点数量匹配 
	 * @author Administrator
	 * 
	 */	
	public class DecisionNode
	{
		/**
		 * 
		 */		
		public var question:*;
		private var map:Map=new Map();
		
		public function DecisionNode()
		{
			
		}
		
		/**
		 * 一个回答
		 * @param s
		 * @param childNodeID 回答映射到当前的几号节点
		 * @return 
		 * 
		 */		
		public function addAnswer(s:Object,childNodeID:int=-1)
		{
			if(childNodeID==-1)
			{
				childNodeID=map.size;
			}
			map.put(s,childNodeID);
		}
		
		public function toString():String
		{
			
			return "question:"+question+"  answer:"+map.keys.toString();
		}
		
		
		/**
		 *返回回答对应的id 
		 * @param answer
		 * @return 
		 * 
		 */		
		public function checkAnswer(answer:Object):int
		{
			if(map.get(answer)!=null)
			{
				return map.get(answer);
			}
			else
			{
				throw new Error("没有此回答");
			}
			
		}
	}
}