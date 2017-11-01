package XGameEngine.GameObject.BaseComponent
{
	
	/**
	 * ...
	 * 通用组件 提供一些基础功能 其他对象使用组合方式持有该对象
	 */
	public class CommonlyComponent 
	{
		public function throwWhileTrue(condition:Boolean, errorMsg:String):void 
		{
			if (condition)
			{
				throw new Error(errorMsg);
			}
		}
		
		
		public function throwWhileNotTrue(condition:Boolean, errorMsg:String):void 
		{
			if (condition==false)
			{
				throw new Error(errorMsg);
			}
		}
		
		
		public function checkNull(obj:Object, errorMsg:String=null):void 
		{
			
			if(obj==null)
			{
				if(errorMsg==null)
				{
					throw new Error("null value!");
				}
				else 
				{
					throw new Error(errorMsg);
				}
			}
		}
	}
	
}