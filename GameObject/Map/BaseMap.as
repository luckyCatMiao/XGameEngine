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
		 * 移动缩放系数 即与正常移动速度之比
		 */
		public var moveScale:Number = 1;
		
		
		/**
		 * 地图的边界是否可以显示在地图内
		 */
		public var canOver:Boolean = false;
		
		
		public function BaseMap()
		{
		
		}
		
		/**
		 * 移动 如果无法继续移动则返回false 只有xy都可以移动时才会真正改变位置
		 * @param	x
		 * @param	y
		 */
		public function move(x:Number,y:Number)
		{
			
			//这次移动是否成功(xy都需要移动成功才行,只有同时成功时才可以真正移动)
			
			if (canMove(x*moveScale,y*moveScale))
			{
				this.x += x*moveScale;
				this.y += y*moveScale;
			}
			
				
			
		
			//throw new Error("can't call the base function!");
		}
		
		
		/**
		 * 测试能否移动
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function canMove(x:Number,y:Number):Boolean
		{
			var b:int=0;
			
			if (canOver == false)
			{
				if (x > 0&&this.x < 0)
				{
						b += 1;				
				}
				
				else if (x < 0 && this.x+width > stage.stageWidth)
				{
					b += 1;
				}
				else if (x == 0)
				{
					b += 1;
				}
				
				if (y > 0&&this.y < 0)
				{
						b += 1;					
				}
				
				else if (y < 0 && this.y+height > stage.stageHeight)
				{
					b += 1;
				}
				else if (y == 0)
				{
					b += 1;
				}
			}
			else
			{
					b = 2;
			}
			
				return b==2;

		}
		
		
		
		
	}
	
}