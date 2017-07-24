package XGameEngine.Test.UtilTest
{
	import XGameEngine.Structure.List;
	import XGameEngine.Test.TestBean.Student;

	public class ListTest
	{
	
		
		public static function runTest():void
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
		

		
		
	}
}