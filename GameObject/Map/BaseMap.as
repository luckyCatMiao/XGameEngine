package XGameEngine.GameObject.Map
{
	import flash.display.Sprite;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.CommonComponent.FunComponent;
	import XGameEngine.GameObject.Component.GameObjectComponent;
	
	/**
	 * ...
	 * @author o
	 */
	public class BaseMap extends BaseGameObject
	{
	
		
		
		
		
		
		/**
		 * 地图的边界是否可以显示在地图内
		 */
		public var canOver:Boolean = false;
		
		
		public function BaseMap()
		{
		
		}
		
		/**
		 * 移动 如果无法继续移动则返回false
		 * @param	x
		 * @param	y
		 */
		public function move(x:Number,y:Number):Boolean
		{
			
			//这次移动是否成功
			var b:Boolean=false;
			
			if (canOver == false)
			{
				if (x > 0&&this.x < 0)
				{
						this.x += x;
						b = true;
										
				}
				
				else if (x < 0 && this.x+width > stage.stageWidth)
				{
					this.x += x;
					b = true;
				}
			}
			else
			{
					this.x += x;
					this.y += y;
			}
			
			
			return b;
		
			//throw new Error("can't call the base function!");
		}
		
		
		
		
		
		
	}
	
}