﻿package XGameEngine.GameObject.CommonComponent
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
	}
	
}