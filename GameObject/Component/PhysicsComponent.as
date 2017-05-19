package XGameEngine.GameObject.Component
{
	import XGameEngine.GameObject.*;
	import XGameEngine.Structure.*;
	import XGameEngine.Structure.Math.*;
	/**
	 * ...
	 * @author o
	 */
	public class PhysicsComponent extends BaseComponent 
	{
		
		private var xSpeed:Number=0;
		private var ySpeed:Number = 0;
		
		private var xSpeed2:Number=0;
		private var ySpeed2:Number=0;
		
		
		private var xASpeed:Number=0;
		private var yASpeed:Number=0;
		
		private var forces:List = new List();
		private var speeds:List = new List();
		
		private var thresholdX:Number = 0;
		private var thresholdY:Number = 0;
		
		private var listener:Function;
		
		/**
		 * 上一帧移动的位置,用于复原
		 */
		private var lastMoveX:Number = 0;
		private var lastMoveY:Number = 0;
		
		public function PhysicsComponent(o:BaseGameObject)
		{
			super(o);
		}
		
		
		/**
		 * 施加恒定速度
		 * @param	name
		 * @param	v
		 */
		public function AddConstantSpeed(name:String,v:Vector2)
		{
			var bean:NVBean = new NVBean();
			bean.name = name;
			bean.v2 = v;
			speeds.add(bean);
		}
		
		
		
		/**
		 * 设置阈值,低于该值的位置移动将不会被施加到玩家身上(不过速度会继续累加),该阈值的存在是为了防止细小的抖动
		 * 例如与地面碰撞时,设置一定的阈值,可以使第一帧不移动,而第一帧结尾时调用clearSpeed该速度会被清除
		 * 如果没有阈值,则第一帧也会移动
		 * @param	x
		 * @param	y
		 */
		public function setThreshold(x:Number,y:Number)
		{
			thresholdX = x;
			thresholdY = y;
		}
		
	
		/**
		 * 施加一个瞬间速度
		 * @param	name
		 * @param	v
		 */
		public function AddInstantSpeed(v:Vector2)
		{
			xSpeed += v.x;
			ySpeed += v.y;
			
			calulate();
		}
		
		
		
		
		/**
		 * 清空当前为止累加的速度,不清空速度和力向量,特别注意对已经存在的速度向量无效
		 * @param	x 是否清空x轴的速度
		 * @param	y 是否清空y轴的速度
		 * @param	fixX 是否对X轴位置进行校准
		 * @param	fixY 是否对Y轴位置进行校准
		 */
		public function ResetSpeed(x:Boolean=true,y:Boolean=true,fixX:Boolean=false,fixY:Boolean=false)
		{
			
			var v:Vector2 = SumUpVector2(forces);
			
			if (x)
			{
				if (fixX)
				{
					host.x -= v.x;
				}
				xSpeed = 0;
			}
			if (y)
			{
				if (fixY)
				{
					host.y += v.y;
				}
				ySpeed = 0;
			}
			
			
			
			
			
		}
		
		
		/**
		 * 施加一直持续的恒力
		 * @param	name
		 * @param	v
		 */
		public function AddForce(name:String,v:Vector2)
		{
			var bean:NVBean = new NVBean();
			bean.name = name;
			bean.v2 = v;
			forces.add(bean);
		}
		
		
		
		/**
		 *  清空速度和力
		 * @param	v
		 * @param	resetSpeed 是否清空当前累加的速度?
		 */
		public function clearAll(v:Vector2,resetSpeed:Boolean=false)
		{
			clearForces();
			clearSpeeds();
			
			if (resetSpeed)
			{
				ResetSpeed();
			}
		}
		
		/**
		 * 清空存在的力向量
		 */
		public function clearForces()
		{
			forces.clear();
		}
		
		/**
		 * 清空速度向量
		 */
		public function clearSpeeds()
		{
			speeds.clear();
		}
		
		/**
		 * 计算一次
		 */
		public function calulate()
		{
			//计算出加速度
			var force2:Vector2 = SumUpVector2(forces);
		
			
			//计算出恒定速度的总和
			var speed2:Vector2 = SumUpVector2(speeds);
			
			
			//当前速度加上加速度
			xSpeed += force2.x;
			ySpeed += force2.y;
			
			
			//追加上恒定速度
		
			var posX:Number = xSpeed + speed2.x;
			var posY:Number =ySpeed+speed2.y;
			
			
			//如果没有监听器 直接变化位置
			if (listener == null)
			{
			if (Math.abs(posX) >= thresholdX)
			{
				host.x += posX ;
				lastMoveX = posX;
			}
			if (Math.abs(posY) >= thresholdY)
			{
				host.y -= posY;
				lastMoveY = posY;
			}
			}
			else
			{
				//如果有监听器 则把计算出的移动数据返回给监听器
				listener(posX, posY);
			}
			
			
		}
		
		
		private function SumUpVector2(l:List):Vector2
		{
			xASpeed = 0;
			yASpeed = 0;
			for each(var n:NVBean in l.Raw)
			{
				xASpeed += n.v2.x;
				yASpeed += n.v2.y;
			}
				//速度可能太大了 这里缩小一下 不然填的时候只能填小数了，有点麻烦
			return new Vector2(xASpeed/10, yASpeed/10);
		}
		
		/**
		 * 停止工作
		 */
		public function stop()
		{
			enable = false;
		}
		
		public function addCalcuListener(onPhysicsMove:Function):void 
		{
			this.listener = onPhysicsMove;
		}
		
	}
	
}

class NVBean
{
	public var name:String;
	public var v2:XGameEngine.Structure.Math.Vector2;
	
	public function toString():String 
	{
		return "[NVBean name=" + name + " v2=" + v2 + "]";
	}
}