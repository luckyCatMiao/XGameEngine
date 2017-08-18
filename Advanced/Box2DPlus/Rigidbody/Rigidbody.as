package XGameEngine.Advanced.Box2DPlus.Rigidbody
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	
	import XGameEngine.Advanced.Box2DPlus.PhysicsWorld;
	import XGameEngine.Advanced.Box2DPlus.Util.CastTool;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Math.Vector2;
	import XGameEngine.Util.MathTool;
	
	import flash.events.EventDispatcher;

	/**
	 *b2Body以及b2def的混合包装类  
	 * 这里保存的属性将在body初次被设置后全部传递给body
	 * 在之后的每一帧 则直接同步body运算后的数据到本类中
	 * 如果调用set方法 属性将会被直接设置给body
	 * @author Administrator
	 * 
	 */	
	public class Rigidbody
	{
		
		
		/**
		 *实际包装的刚体 此类的数据最后都会传递给他 
		 */		
		private var body:b2Body;
	
		/**
		 *是否活动 
		 */		
		private var _active:Boolean=true;
		/**
		 *是否开启高速碰撞检测 
		 */		
		private var _isBullet:Boolean;
		/**
		 *类型 
		 */		
		private var _type:uint;
		/**
		 *是否睡眠 
		 */		
		private var _sleep:Boolean=false;
		/**
		 *坐标 
		 */		
		private var _x:Number=0;
		private var _y:Number=0;
		/**
		 *角度 
		 */		
		private var _rotation:Number=0;
		/**
		 *角速度阻尼 
		 */		
		private var _angularDamping:Number=0;
		/**
		 *角速度惯性 
		 */
		private var _angularInertia:Number=1;
		/**
		 *是否固定角速度 
		 */	
		private var _fixRotation:Boolean;
		/**
		 *角速度 
		 */		
		private var _angularSpeed:Number=0;
		/**
		 * 线速度
		 */		
		private var _linearSpeed:Vector2=new Vector2(0,0);
		/**
		 *线速度阻尼 (空气阻力)
		 */		
		private var _linearDamping:Number=0;
		
		
		/**
		 *保存所有的部件 
		 */		
		private var parts:List=new List();
		
		
		private var valueScale:Number;
		public function Rigidbody()
		{
			
			this.valueScale=PhysicsWorld.valueScale;
		}
		
	
	
		/**
		 *线速度阻尼 (空气阻力)
		 */
		public function get linearDamping():Number
		{
			return _linearDamping;
		}

		/**
		 * @private
		 */
		public function set linearDamping(value:Number):void
		{
			_linearDamping = value;
			SynchronizeDataTo();
		}

		/**
		 *角速度 
		 */
		public function get angularSpeed():Number
		{
			return _angularSpeed;
		}

		/**
		 * @private
		 */
		public function set angularSpeed(value:Number):void
		{
			_angularSpeed = value;
			SynchronizeDataTo();
		}

		/**
		 *线速度 
		 */
		public function get linearSpeed():Vector2
		{
			return _linearSpeed;
		}

		/**
		 * @private
		 */
		public function set linearSpeed(value:Vector2):void
		{
			_linearSpeed = value;
			SynchronizeDataTo();
		}

		/**
		 *是否在睡眠状态 
		 */
		public function get sleep():Boolean
		{
			return _sleep;
		}

		/**
		 * @private
		 */
		public function set sleep(value:Boolean):void
		{
			_sleep = value;
			SynchronizeDataTo();
		}

		/**
		 *是否固定角速度不变 
		 */
		public function get fixRotation():Boolean
		{
			return _fixRotation;
		}

		/**
		 * @private
		 */
		public function set fixRotation(value:Boolean):void
		{
			_fixRotation = value;
			
			SynchronizeDataTo();
			
		}
		
		/**
		 *同步属性到body 
		 * 
		 */		
		private function SynchronizeDataTo():void
		{
			if(body!=null)
			{
				body.SetPosition(new b2Vec2(_x,_y));
				body.SetType(_type);
				body.SetActive(_active);
				body.SetBullet(_isBullet);
				body.SetAngle(_rotation/180*Math.PI);
				body.SetAngularDamping(_angularDamping);		
				body.SetFixedRotation(_fixRotation);
				body.SetAwake(!_sleep);
				body.SetLinearVelocity(CastTool.castVector2ToB2Vec2(_linearSpeed));
				body.SetAngularVelocity(_angularSpeed);
				body.SetLinearDamping(_linearDamping);
				
				

			}
		
		}
		
		/**
		 *角速度惯性 质量对角速度惯性无影响而是单独设置了这个参数
		 *不知道为什么box2d要这么设计，值越大角速度的改变越困难 
		 */
		public function get angularInertia():Number
		{
			return _angularInertia;
		}

		/**
		 * @private
		 */
		public function set angularInertia(value:Number):void
		{
			_angularInertia = value;
			SynchronizeDataTo();
			
		}

		/**
		 *角速度阻尼 
		 */
		public function get angularDamping():Number
		{
			return _angularDamping;
		}

		/**
		 * @private
		 */
		public function set angularDamping(value:Number):void
		{
			MathTool.restrictRange(value,0,1);
			_angularDamping = value;
			
		}

		/**
		 *角度(角度值) 
		 */
		public function get rotation():Number
		{
			return _rotation;
		}

		/**
		 * @private
		 */
		public function set rotation(value:Number):void
		{
			_rotation = value;
			SynchronizeDataTo();
			
		}

		/**
		 *是否开启连续碰撞检测 防止高速状态下的穿透情况 
		 */
		public function get isBullet():Boolean
		{
			return _isBullet;
		}

		/**
		 * @private
		 */
		public function set isBullet(value:Boolean):void
		{
			_isBullet = value;
			SynchronizeDataTo();
			
		}

		/**
		 *是否激活(不激活的话不会参与计算)
		 */
		public function get active():Boolean
		{
			return _active;
		}

		/**
		 * @private
		 */
		public function set active(value:Boolean):void
		{
			_active = value;
			SynchronizeDataTo();
		}

		/**
		 *刚体类型 
		 */
		public function get type():uint
		{
			return _type;
		}

		public function set type(value:uint):void
		{
			_type = value;
			SynchronizeDataTo();
		}

		public function get y():int
		{
			return _y*valueScale;
		}

		public function set y(value:int):void
		{
			_y = value/valueScale;
			SynchronizeDataTo();
			
		}

		/**
		 *坐标 
		 */
		public function get x():int
		{
			return _x*valueScale;
		}

		/**
		 * @private
		 */
		public function set x(value:int):void
		{
			_x = value/valueScale;
			SynchronizeDataTo();
		}

		public function setPackedBody(body:b2Body):void
		{
			//初次创建 将属性全同步给bodu
			this.body=body;
			SynchronizeDataTo();
			
		}
		
	
		
		public function loop()
		{
		
			SynchronizeDataFrom();
			loopParts();
			
		}
		
		/**
		 *循环所有的part的loop 
		 * 
		 */		
		private function loopParts():void
		{
			for each(var bean:RigidPartBean in parts.Raw)
			{
				if(bean.hasAdded)
				{
					bean.part.loop();
				}
			}
			
		}
		
		/**
		 *同步该类的属性与实际包装的b2body,这里因为是每帧调用 
		 * 所以当和实际 world的step频率有区别可能会出现延迟 但一般无法察觉
		 * 
		 */		
		private function SynchronizeDataFrom():void
		{
			//同步body的数据
			if(body!=null)
			{
				this._type=body.GetType();
				var b2:b2Vec2=body.GetPosition();
				this._x=b2.x;
				this._y=b2.y;
				this._active=body.IsActive();
				this._isBullet=body.IsBullet();
				this._rotation=body.GetAngle()*180/Math.PI;
				this._angularDamping=body.GetAngularDamping();
				this._fixRotation=body.IsFixedRotation();
				this._sleep=!body.IsAwake();
				this._linearSpeed=CastTool.castB2Vec2ToVector2(body.GetLinearVelocity());
				this._angularSpeed=body.GetAngularVelocity();
				this._linearDamping=body.GetLinearDamping();
								
				//添加上没有添加的fixture
				for each(var bean:RigidPartBean in parts.Raw)
				{
					
					if(bean.hasAdded==false)
					{
						bean.hasAdded=true;
						
						var f:b2FixtureDef=new b2FixtureDef();
					
						
						//因为除了shape之外所有其他的属性都可以在fixture里面重新设定
						//所以b2FixtureDef没有多大意义 实际上我不是很喜欢这种builder模式的写法。。
						//所以我们这里创建一个空的b2FixtureDef，然后同步一下shape
						//最后把实际的fixture设置回给part 这样part也可以进行同步了
						f.shape=bean.part.shape.getShape();
						var a:b2Fixture=body.CreateFixture(f);
						bean.part.setPackedFixture(a);
						
						
						
					}
				}
				
			}
			
		
			
		}
		
		
	
		
		
		/**
		 *添加一个刚体组成部分 
		 * 添加到一个缓存区中 在循环时会被自动连接并同步到实际包装的b2body上
		 * @return 
		 * 
		 */		
		public function addRigidPart(part:RigidPart)
		{

			if(part.shape==null)
			{
				throw new Error("part必须要有一个shape!");
			}
			this.parts.add(new RigidPartBean(part));

		}
			
	}
	
	
	
	
}
import XGameEngine.Advanced.Box2DPlus.Rigidbody.RigidPart;

import fl.transitions.Fade;

class RigidPartBean
{
	public var part:RigidPart;
	
	/**
	 *是否被添加到实际的b2body中了 
	 */	
	public var hasAdded:Boolean;
	public function RigidPartBean(part:RigidPart,hasAdded:Boolean=false)
	{
		this.part=part;
		this.hasAdded=hasAdded;
	}
}