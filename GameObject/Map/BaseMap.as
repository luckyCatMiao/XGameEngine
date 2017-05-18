package XGameEngine.GameObject.Map
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author o
	 */
	public class BaseMap extends Sprite
	{
	
		
		/**
		 * 地图的边界是否可以显示在地图内
		 */
		public var canOver:Boolean = false;
		
		/**
		 * 移动
		 * @param	x
		 * @param	y
		 */
		public function move(x:Number,y:Number)
		{
			if (canOver == false)
			{
		
				if (x > 0 && this.x < 0)
				{
					this.x += x;
				}
				
				else if (x < 0 && this.x+width > stage.stageWidth)
				{
					this.x += x;
				}
			}
			else
			{
					this.x += x;
					this.y += y;
			}
		
			//throw new Error("can't call the base function!");
		}
		
		
		
		
		
		
	}
	
}