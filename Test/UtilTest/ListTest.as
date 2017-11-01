package XGameEngine.Test.UtilTest
{
	import XGameEngine.Collections.List;
	import XGameEngine.Test.TestBean.Student;

	public class ListTest
	{
	
		
		public static function runTest():void
		{
			//test1();
			//test2();
			test3();
			
			
			
			
			
			

		}
		
		private static function test3():void
		{
			
			  
			var list:List=new List(false,true);
			//填充空分
			for(var i:int=0;i<6;i++)
			{
				list.add(0);
			}
			
			list.replace(300,0);
			
			trace(list);
			
			
		}
		
		private static function test2():void
		{
			
			//不能添加重复值的list
			var list:List=new List();
			try
			{
				//添加空值
				list.add(null);
			} 
			catch(error:Error) 
			{
				trace("添加空值失败");
			}
			
		}
		
		private static function test1():void
		{
			//不能添加重复值的list
			var list:List=new List();
			var stu1:Student=new Student();
			stu1.age=18;
			stu1.name="张三";
			list.add(stu1);
			try
			{
				list.add(stu1);
			} 
			catch(error:Error) 
			{
				trace("添加重复值失败");
			}
			
		}		

		
		
	}
}