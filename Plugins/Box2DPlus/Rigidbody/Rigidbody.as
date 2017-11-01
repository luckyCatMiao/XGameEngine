package XGameEngine.Plugins.Box2DPlus.Rigidbody
{
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	
	import XGameEngine.Plugins.Box2DPlus.Collision.Collision;
	import XGameEngine.Plugins.Box2DPlus.PhysicsWorld;
	import XGameEngine.Plugins.Box2DPlus.Util.CastTool;
	import XGameEngine.Util.Error.UnSupportMethodError;
	import XGameEngine.Collections.List;
	import XGameEngine.Math.Rect;
	import XGameEngine.Math.Vector2;
	import XGameEngine.Math.MathTool;
	
	import flash.events.EventDispatcher;

	/**
	 *b2Body以及b2def的混合包装类  
	 * 这里保存的属性将在fixture每次被添加后全部传递给body
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
		private var _type:uint=RigidbodyType.dynamicBody;
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
		private var _fixRotation:Boolean=false;
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
		 *保存所有暂存中的部件 
		 */		
		private var cacheParts:List=new List();
		
		/**
		 *所有被实际添加的部件 
		 */		
		private var realPart:List=new List();
		
		
		private var valueScale:Number;
		
		/**
		 * 返回质量 只读属性 根据密度和面积自动计算
		 */		
		private var _mass:Number=1;
		private var _localMassCenter:Vector2=Vector2.VEC2_ZERO;
		private var _worldMassCenter:Vector2=Vector2.VEC2_ZERO;
		
		
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
				
				//这个类我们让质量和惯性质量只读了 感觉修改没什么意义还可能出bug
				//不过重心改起来还是有点用处的 所以我们这里只同步重心到body
				var m:b2MassData=new b2MassData();
				body.GetMassData(m);
				m.center.Set(_localMassCenter.x,_localMassCenter.y);
				body.SetMassData(m);

			

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
			MathTool.checkRange(value,0,1);
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
		
		
		/**
		 *返回质量 只读属性 根据密度和面积自动计算
		 */
		public function get mass():Number
		{
			return _mass;
			
		}

		public function setPackedBody(body:b2Body):void
		{
			
			this.body=body;
			SynchronizeDataTo();
		}
		
		public function getPackedBody():b2Body
		{
			
			return this.body;
		}
		
		public function _loop()
		{
		
			SynchronizeDataFrom();
			loopParts();
			
			loop();
			
		}
		
		public function loop():void
		{
			// TODO Auto Generated method stub
			
		}
		
		/**
		 *循环所有的part的loop 
		 * 
		 */		
		private function loopParts():void
		{
			for each(var bean:RigidPartBean in cacheParts.Raw)
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
				this._mass=body.GetMass();
				this._angularInertia=body.GetInertia();
				
				var v:b2Vec2=body.GetLocalCenter();
				this._localMassCenter=new Vector2(v.x,v.y);
				
			
				v=body.GetWorldCenter();
				this._worldMassCenter=new Vector2(v.x,v.y);
				
				
				
				
				tryAddFixture();
				
			}
			
		
			
		}
		
		private function tryAddFixture():void
		{
			//添加上没有添加的fixture
			for each(var bean:RigidPartBean in cacheParts.Raw)
			{
				
				if(bean.hasAdded==false)
				{
					bean.hasAdded=true;
					
					var f:b2FixtureDef=new b2FixtureDef();
					//这里必须赋值一个初始值 因为质量并不会直接在循环中更新
					//而是在set中才更新 所以这里必须有一个初始值
					f.density=bean.part.density;
					
					
					//因为除了shape之外所有其他的属性都可以在fixture里面重新设定
					//所以b2FixtureDef没有多大意义 实际上我不是很喜欢这种builder模式的写法。。
					//所以我们这里创建一个空的b2FixtureDef，然后同步一下shape
					//最后把实际的fixture设置回给part 这样part也可以进行同步了
					f.shape=bean.part.shape.getShape();
					var a:b2Fixture=body.CreateFixture(f);
					bean.part.setPackedFixture(a);
					bean.part.rigidbody=this;
					
					
					//因为添加子fixture可能会改变重心或者其他属性 所以我们不在传入body的时候
					//初始化属性，而是每次添加fixture时传递属性
					SynchronizeDataTo();
					
					realPart.add(bean.part);
					
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
			
			//如果可以添加就直接添加了
			if(body!=null)
			{
				this.cacheParts.add(new RigidPartBean(part));
				tryAddFixture();
			}
			//否则先放在暂存区中 等待body被设置进来的时候添加
			else
			{
				this.cacheParts.add(new RigidPartBean(part));
			}
			

		}
		
		
		/**
		 *删除一个刚体组成部分 
		 * @return 
		 * 
		 */		
		public function removeRigidPart(part:RigidPart)
		{
			
			if(part.shape==null)
			{
				throw new Error("part必须要有一个shape!");
			}
			
			//这边就不把list里存的fixture删掉了 应该没什么关系
			//只和body断开连接
			if(body!=null)
			{
				body.DestroyFixture(part.fixture);
			}
			
		}
		
		
		/**
		 *施加力 
		 * @param v 力向量
		 * @param point 作用点
		 * @return 
		 * 
		 */		
		public function applyForce(v:Vector2,point:Vector2=null)
		{
			
			if(point==null)
			{
				point=Vector2.VEC2_ZERO;
			}
			
			if(body!=null)
			{
				//这边力就不缩放了 反正我们只是看感觉给数值...不求精确换算了
				var a:b2Vec2=CastTool.castVector2ToB2Vec2(v);
				
				var b:b2Vec2=CastTool.castVector2ToB2Vec2(point);
				b.x/=valueScale;
				b.y/=valueScale;
				
				//这个的作用点居然是全局坐标 真是醉了 不知道写这个框架的人怎么想的
				//这边修改为本地坐标
				b.x+=_x;
				b.y+=_y;
				body.ApplyForce(a,b);
			}
		}
		
		
		/**
		 *施加扭力 增大角速度 
		 * @param value
		 * @return 
		 * 
		 */		
		public function applyTorque(value:Number)
		{
			if(body!=null)
			{
				body.ApplyTorque(value);
			}
		}
		
		/**
		 *返回重心的本地坐标 
		 * @return 
		 * 
		 */		
		public function get localMassCenter():Vector2
		{
			return _localMassCenter.clone().multiply(valueScale);
		}
		
		/**
		 *设置重心位置 可以模拟类似不倒翁的效果
		 * 注意这里的重心偏离了实际上计算得出的重心
		 * @param v 本地坐标
		 * @return 
		 * 
		 */		
		public function set localMassCenter(v:Vector2):void
		{
			
			v=v.divide(valueScale);
			_localMassCenter=v;
			
		
			SynchronizeDataTo();
			
		}
		
		/**
		 *返回重心的全局坐标(和x,y是不同的 重心可能不在本地坐标0,0点处)
		 * @return 
		 * 
		 */		
		public function get worldMassCenter():Vector2
		{
			return _worldMassCenter.clone().multiply(valueScale);
		}
		
		public function localToGlobal(local:Vector2):Vector2
		{
			if(body!=null)
			{
				var v:b2Vec2=body.GetWorldPoint(CastTool.castVector2ToB2Vec2(local));;
				return CastTool.castB2Vec2ToVector2(v);
			}
			throw new UnSupportMethodError();
		}
		
		
		public function globalToLocal(global:Vector2):Vector2
		{
			if(body!=null)
			{
				var v:b2Vec2=body.GetLocalPoint(CastTool.castVector2ToB2Vec2(global));
				return CastTool.castB2Vec2ToVector2(v);
			}
			throw new UnSupportMethodError();
		}
			
		
		/**
		 *根据子fixture的密度重新计算质量 以及恢复重心
		 * 其实我知道为什么他这里要有这么一个方法而不是强制同步
		 * 虽然强制同步才是真实的物理效果，毕竟都是计算出来的
		 * 但是可能需要一些特殊效果，比如偏离真实的重心来快速模拟一个不倒翁效果
		 * 如果不能直接设置的话 可能就要由两部分组成一个不倒翁下面重上面轻来进行一个真实模拟了
		 * 这样的话就麻烦了许多 
		 */		
		public function resetMassData():void
		{
			
			if(body!=null)
			{
				body.ResetMassData();
			}
			
		}
		
		
		public function getAABB():Rect
		{
			var resultAabb:b2AABB=new b2AABB();
			
			//组合所有子fixture的aabb
			for(var i:int=0;i<realPart.size;i++)
			{
				
				var r:Rect=(realPart.get(i) as RigidPart).getAABB();
				var aabb:b2AABB=CastTool.castRectToAABB(r);
			
				resultAabb=b2AABB.Combine(resultAabb,aabb);
			}
			
			return CastTool.castAABBToRect(resultAabb);
		}
		
		
	
		public function onCollisionEnter(c:Collision):void
		{
			// TODO Auto Generated method stub
			
		}
	}
	
	
	
	
}
import XGameEngine.Plugins.Box2DPlus.Rigidbody.RigidPart;

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