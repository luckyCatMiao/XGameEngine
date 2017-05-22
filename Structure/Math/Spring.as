package XGameEngine.Structure.Math
{
	import flash.geom.Point;
	import XGameEngine.Structure.Math.Vector2;
	
	/**
	 * ...
	 * 一个弹簧的数学结构
	 */
	public class Spring
	{
		/**
		 * xy表示当前点与弹簧原点的偏移距离
		 */
		public var x:Number=0;
		public var y:Number=0;
		
		//加速度
		private var ySpeed:Number = 0;
		private var xSpeed:Number = 0;
		
		/**
		 * 弹簧系数
		 */
		private var _springScale:Number=1;
		
		/**
		 * 反震 即 弹簧反弹之后是否会继续向反方向继续运动(发现高中物理都忘得差不多了,,忘了咋写了 就先算了 反正当前也只是用于地图,更专业的需求
		 * 直接用Box2d就可以了)
		 */
		public var reverse:Boolean = false;
		
		public function Spring(springScale:Number)
		{
			this.springScale = springScale;
		}
		
		
		/**
		 * 计算一次单位时间的弹簧运动 并返回结果
		 */
		public function calculate():Vector2
		{
			/**
			 * 当前帧中需要移动的距离
			 */
			var moveX:Number;
			var moveY:Number;
			
			//可以把1当做是一个特殊值 特殊处理 即在弹簧弹性系数为1的时候 一帧即可让弹簧复原
			if (_springScale==1) {
				moveX = -x;
				moveY = -y;
			}
			else
			{
				xSpeed = -x * 0.02*_springScale;
				ySpeed = -y * 0.02*_springScale;
				
				moveX = xSpeed;
				moveY = ySpeed;
				/*xSpeed += -x / 50 * _springScale;
				ySpeed += -y / 50 * _springScale;
				
				
				moveX = xSpeed;
				if (moveX > 0)
				{
					if (x + moveX > 0&&reverse)
					{
						moveX = -x;
					}
				}
				if (moveX < 0)
				{
					if (x + moveX < 0&&reverse)
					{
						moveX = -x;
					}
				}
				
				moveY = ySpeed;*/
			}
			
			x +=moveX;
			y +=moveY;
			
			
			return new Vector2(moveX, moveY);
		}
		
		public function get springScale():Number 
		{
			return _springScale;
		}
		
		public function set springScale(value:Number):void 
		{
			//系数为0-1
			if (value >= 0 && value <= 1)
			{
				_springScale = value;
			}
			
			else
			{
				throw new Error("the value need between 0-1");
			}
		}
		
	}
	
}