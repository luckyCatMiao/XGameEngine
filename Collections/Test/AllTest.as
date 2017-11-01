package XGameEngine.Collections.Test
{
	import XGameEngine.Collections.Test.UtilTest.ListTest;
	import XGameEngine.Collections.Test.UtilTest.StackTest;

	public class AllTest
	{
		public function AllTest()
		{
		}
		
		static public function runTest():void
		{
			ListTest.runTest();
			//StackTest.runTest();
		}
		
	}
}