package XGameEngine.Test.UtilTest
{
	import XGameEngine.Collections.Stack;

	public class StackTest
	{
		public static function runTest():void
		{
			var stack:Stack=new Stack();
			stack.push(1);
			stack.push(2);
			stack.push(3);
			stack.push(4);
			
			trace(stack);
			trace(stack.pop()==4);
			
			
		}
	}
}