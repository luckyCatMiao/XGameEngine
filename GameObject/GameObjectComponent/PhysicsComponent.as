package XGameEngine.GameObject.GameObjectComponent
{
	import XGameEngine.GameObject.*;
	import XGameEngine.Structure.*;
	import XGameEngine.Structure.Math.*;
	import XGameEngine.BaseObject.BaseComponent.BaseComponent;

	/**
	 * 物理组件 可以施加力和速度之类的
	 * @author o
	 */
	public class PhysicsComponent extends BaseGameObjectComponent 
	{
		
		
		/**
		 *由加速度累加起来的那一部分合速度 加上固定速度后才是总速度 
		 */		
		private var partXSpeed:Number=0;
		private var partYSpeed:Number = 0;
		
	
		/**
		 *加速度 
		 */		
		private var xASpeed:Number=0;
		private var yASpeed:Number=0;
		
		/**
		 *力组 每次都会转化为加速度 加速度再累加到最终速度上 
		 */		
		private var forces:List = new List();
		
		/**
		 *恒定速度组 每次计算最终速度时这里面的值都会被加入 
		 */		
		private var speeds:List = new List();
		
		/**
		 *移动阈值 
		 */		
		private var thresholdX:Number = 0;
		private var thresholdY:Number = 0;
		
		private var listener:Function;
		
		/**
		 * 上一帧移动的位置,用于复原
		 */
		private var lastMoveX:Number = 0;
		private var lastMoveY:Number = 0;
		
		public var sumSpeedX:Number;
		public var sumSpeedY:Number;
		
		public function PhysicsComponent(o:BaseGameObject)
		{
			super(o);
		}
		
		
		/**
		 * 增加一个速度向量到速度组中
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
		 * 直接追加一个速度向量到最终速度中
		 * @param	name
		 * @param	v
		 */
		public function AddInstantSpeed(v:Vector2)
		{
			partXSpeed += v.x;
			partYSpeed += v.y;
			
			calulate();
		}
		
		
		
		
		/**
		 * 清空当前为止累加的速度,不清空速度和力向量,特别注意对已经存在的速度向量无效
		 * 可以进行反向的位置校准 例如游戏中的墙壁 清空速度之后还可能需要往反方向移动,防止穿过部分墙壁
		 * @param	x 是否清空x轴的速度
		 * @param	y 是否清空y轴的速度
		 * @param	fixX  x轴需要校准的距离
		 * @param	fixY  y轴需要校准的距离
		 */
		public function ResetSpeed(x:Boolean=true,y:Boolean=true,fixX:Number=0,fixY:Number=0)
		{
			
			
		
			
			if (x)
			{
				if (fixX)
				{
					//host.x -= v.x;
//					var moveX:int=v.x;
//					setHostPostion(new Vector2(-moveX,0));
					instanceMove(new Vector2(0,fixX));
				}
				partXSpeed = 0;
			}
			if (y)
			{
				if (fixY)
				{
//					var moveY:int=v.y;
//					setHostPostion(new Vector2(-moveY,0));
//					trace(-moveY);
					
					instanceMove(new Vector2(0,fixY));
				}
				partYSpeed = 0;
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
		 */
		public function clearAll()
		{
			clearForces();
			clearSpeeds();
			
			//清零当前累加的速度
			ResetSpeed();
			
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
			//加速度可能太大了 这里缩小一下 不然填的时候只能填小数了，有点麻烦
			force2.divide(10.0);
			
			//计算出恒定速度的总和
			var speed2:Vector2 = SumUpVector2(speeds);
			
			
			//当前速度加上加速度
			partXSpeed += force2.x;
			partYSpeed += force2.y;
			
			
			//追加上恒定速度
			//设置物理速度总和 供外界读取
			this.sumSpeedX =partXSpeed + speed2.x;
			this.sumSpeedY =partYSpeed+ speed2.y;
		
			
			//根据计算出的距离设置host的位置
			setHostPostion(new Vector2(sumSpeedX,sumSpeedY));

		}
		
		private function setHostPostion(v:Vector2):void
		{
			
			var posX:Number =v.x;
			var posY:Number =v.y;
			
			//如果没有监听器 直接变化位置
			if (listener == null)
			{
				//超过阈值才能移动
				if (Math.abs(posX) >= thresholdX)
				{
					host.x += posX ;
					lastMoveX = posX;
				}
				if (Math.abs(posY) >= thresholdY)
				{
					host.y += posY;
					lastMoveY = posY;
				}
			}
			else
			{
				//如果有监听器 则把计算出的移动数据返回给监听器
				listener(posX, posY);
			}
			
		}		
		
		
		/**
		 *将一组向量全加起来返回结果向量(为了方便起见 值会被缩小10倍) 
		 * @param l
		 * @return 
		 * 
		 */		
		private function SumUpVector2(l:List):Vector2
		{
			xASpeed = 0;
			yASpeed = 0;
			for each(var n:NVBean in l.Raw)
			{
				xASpeed += n.v2.x;
				yASpeed += n.v2.y;
			}
				
			return new Vector2(xASpeed, yASpeed);
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
		
		
		/**
		 *	施加瞬时的移动 
		 * @param param0
		 * 
		 */		
		public function instanceMove(move:Vector2):void
		{
			setHostPostion(move);
			
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