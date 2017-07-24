package XGameEngine.GameObject.Map
{
	import Script.GameObject.GameMap;
	
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.CommonComponent.FunComponent;
	import XGameEngine.GameObject.Component.GameObjectComponent;
	import XGameEngine.Structure.Math.Spring;
	import XGameEngine.Structure.Math.Vector2;
	
	import flash.display.Sprite;
	
	/**
	 * 普通单层地图
	 * @author o
	 */
	public class BaseMap extends AbstractMap  
	{
	
		/**
		 * 地图的边界是否可以显示在地图内
		 */
		public var canOver:Boolean = false;
		
		/**
		 *移动缩放系数 
		 */		
		public var moveScale:Number = 1;
		
		public function BaseMap(moveScale:Number=-1)
		{
			this.xname ="BaseMap "+this.name;
			
			if (moveScale != -1)
			{
				this.moveScale = moveScale;
			}
		}
		
		
		/**
		 *移动 如果无法继续移动则返回false 只有xy都可以移动时才会真正改变位置 
		 * @param x 移动的x值
		 * @param y 移动的y值
		 * @return  移动缩放后移动的距离
		 * 
		 */		
		override public function move(x:Number,y:Number):Vector2
		{
			
			
			//基于移动缩放系数转换成真实值
			var v:Vector2 = getRealValue(x, y);
			var moveX:Number = v.x;
			var moveY:Number = v.y;
			
			//这次移动是否成功(xy都需要移动成功才行,只有同时成功时才可以真正移动)
			if (canMove(moveX,moveY))
			{
				this.x += moveX;
				this.y += moveY;
				
				return new Vector2(moveX, moveY);
			}
			
			//返回移动的实际值	
			return new Vector2(0,0);
			
		
			//throw new Error("can't call the base function!");
		}
		
		
		/**
		 *计算移动的实际值	 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		private function getRealValue(x:Number, y:Number):Vector2 
		{	
			var p:Vector2 = new Vector2(x*moveScale,y*moveScale);
			return p;
		}
		
	
		
		
		/**
		 * 测试能否移动
		 * @param	x
		 * @param	y
		 * @return
		 */
		override public function canMove(x:Number,y:Number):Boolean
		{
			var b:int = 0;
			
		
			
			if (canOver == false)
			{
				//测试x值是否能够移动
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
				
				
				//测试y值是否能够移动
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
				//没有越界限制则直接返回true
					return true;
			}
			
			//xy值是否都可以移动
				return b==2;

		}
		
		
		
		
	}
	
}