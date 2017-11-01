package XGameEngine.Collections.Tree.DecisionTree
{
	import XGameEngine.Collections.Graph.GraphNode;
	import XGameEngine.Collections.List;
	import XGameEngine.Collections.Tree.Tree;

	/**
	 *对话树 用来完成分支对话之类的效果 
	 * @author Administrator
	 * 
	 */	
	public class DecisionTree extends Tree
	{
		private var _currentQuestion:DecisionNode;
	
		public function DecisionTree(rootValue:DecisionNode)
		{
			super(rootValue);
			this._currentQuestion=rootValue;
		}
		
		/**
		 *当前的问题 
		 */
		public function get currentQuestion():DecisionNode
		{
			return _currentQuestion;
		}

		public function addDesionNode(value:DecisionNode,parent:DecisionNode)
		{
			super.addNode(value,parent);
		}
		
		
		/**
		 *回答当前的问题 
		 * @param param0
		 * 
		 */		
		public function answerCurrentQuestion(answer:Object):void
		{
			var q:DecisionNode=currentQuestion;
			var id:int=q.checkAnswer(answer);
			
			answerCurrentQuestionById(id);
	
		}
		
		/**
		 *直接跳到对应答案对应的id的下一个节点 
		 * @param id
		 * 
		 */		
		public function answerCurrentQuestionById(id:int):void
		{
			var childs:List=graph.getLinkedPoint(currentQuestion);
			
			_currentQuestion=(childs.get(id) as GraphNode).value;
			
		}
		
		/**
		 *直接跳到下一个节点 只有在当前节点的只有一个子节点才能这么做 
		 * 
		 */		
		public function jumpToNext():void
		{
			var childs:List=graph.getLinkedPoint(currentQuestion);
			if(childs.size==1)
			{
				_currentQuestion=(childs.get(0) as GraphNode).value;
			}
		}
		
		
		/**
		 *跳转到另一个问题 
		 * @param q
		 * 
		 */		
		public function jumpToQuestion(q:DecisionNode):void
		{
			_currentQuestion=q;
		}
		
		/**
		 *重置回初始问题 
		 * 
		 */		
		public function reset():void
		{
			_currentQuestion=root;
		}
	}
}