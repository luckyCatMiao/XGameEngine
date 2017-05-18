package XGameEngine.GameObject.Component
{
	import flash.display.DisplayObject;
	import XGameEngine.GameObject.BaseGameObject;
	
	/**
	 * ...
	 * @author o
	 */
	public class GameObjectComponent extends BaseComponent 
	{
		public function GameObjectComponent(o:BaseGameObject)
		{
			super(o);
		}
		
		
		
		/**
		 * 设置最低深度
		 * @param	o
		 */
		public function addChildToLowestDepth(o:DisplayObject)
		{
			//0就是最低索引 如果该索引处已经有对象 则所有对象会自动向上调整
			//确实比AS2好用的多
			host.addChildAt(o, 0);
		}
		
		
		/**
		 * 加入对象,设置最高深度
		 * @param	o
		 */
		public function addChildToHighestDepth(o:DisplayObject)
		{
			
			host.addChild(o);
		}
		
		
		
		/**
		 * 加入对象,设置为次高深度(如果只有该物体 则设置为最高深度)
		 * @param	o
		 */
		public function addChildToBeforeHighestDepth(o:DisplayObject)
		{
			if (host.numChildren == 0)
			{
				host.addChild(o);
			}
			else
			{
				host.addChildAt(o, host.numChildren - 1);
			}
			
		}
	}
	
}