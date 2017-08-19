package XGameEngine.Advanced.Box2DPlus.Rigidbody
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2Fixture;
	
	import XGameEngine.Advanced.Box2DPlus.PhysicsWorld;
	import XGameEngine.Advanced.Box2DPlus.Rigidbody.Shape.AbstractShape;
	import XGameEngine.Advanced.Box2DPlus.Util.CastTool;
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.Util.MathTool;

	/**
	 *一个Rigidbody由多个 RigidPart 组成
	 * 例子 一个锤子由头和柄组成 整个锤子具有的公共属性，如线速度角速度坐标等，都放在rigidbody中
	 * 但是头和柄各自具有不同的形状，密度，摩擦等属性 这些放在各自的rigidPart中
	 * @author Administrator
	 * 
	 */	
	public class RigidPart
	{
		public var shape:AbstractShape;

		/**
		 *实际包装的 fixture
		 */		
		internal var fixture:b2Fixture;
		
		/**
		 *密度 
		 * 默认的fixturedef初始化后密度是0不知道怎么搞的 然后运行结果看上去就很奇怪
		 * 搞得我以为box2d有什么bug 这里设置为1 就可以了
		 */		
		private var _density:Number=1;
		/**
		 *接触摩擦力 (0~1)
		 */		
		private var _friction:Number=0;
		/**
		 *弹性系数(0~1) 
		 */		
		private var _restitution:Number=0;
		/**
		 *碰撞层 
		 */		
		private var _hitLayer:int=1;
		/**
		 * 是否仅仅作为trigger使用 (有点奇怪为什么这个属性不是b2body的)
		 */
		private var _isSensor:Boolean=false;
		internal var rigidbody:Rigidbody;
		private var valueScale:Number;

		public function RigidPart()
		{
			
		this.valueScale=PhysicsWorld.valueScale;
		}
		
		/**
		 *是否仅仅作为trigger使用 (有点奇怪为什么这个属性不是b2body的)
		 */
		public function get isSensor():Boolean
		{
			return _isSensor;
		}

		/**
		 * @private
		 */
		public function set isSensor(value:Boolean):void
		{
			_isSensor = value;
			SynchronizeDataTo();
		}

		/**
		 *因为默认的碰撞有两种方式来决定是否需要检测两个物体之间的碰撞
		 * 第一种是层与层之间 第二种可以单个物体之间
		 * 不过第二种太麻烦我们这里只使用第一种 足够用了
		 * 因为默认的第一种是不会被激活的
		 * 除非设置层级大于0  所以我们设置层级为1 
		 */
		public function get hitLayer():int
		{
			return _hitLayer;
		}

		/**
		 * @private
		 */
		public function set hitLayer(value:int):void
		{
			if(value<1)
			{
				throw new Error("碰撞层必须大于1");
			}
			_hitLayer = value;
			SynchronizeDataTo();
		}

		/**
		 *同步属性到fixture 
		 * 
		 */		
		private function SynchronizeDataTo():void
		{
			if(fixture!=null)
			{
				fixture.SetDensity(_density);
				fixture.SetFriction(_friction);
				fixture.SetRestitution(_restitution);
				var d:b2FilterData=new b2FilterData();
				d.groupIndex=_hitLayer;
				fixture.SetFilterData(d);
				fixture.SetSensor(_isSensor);
				
				
				
			}
		}
		
		public function get restitution():Number
		{
			return _restitution;
		}

		public function set restitution(value:Number):void
		{
			MathTool.checkRange(value,0,1);
			_restitution = value;
			SynchronizeDataTo();
		}

		public function get friction():Number
		{
			return _friction;
		}

		public function set friction(value:Number):void
		{
			MathTool.checkRange(value,0,1);
			_friction = value;
			SynchronizeDataTo();
		
		}

		public function get density():Number
		{
			return _density;
		}

		public function set density(value:Number):void
		{
			_density = value;
			SynchronizeDataTo();
			
			//因为子fixture的密度可能变化 所以改变要重新计算body的质量及其他属性
			//那本书居然没讲 真的坑死人了
			//否则子fixture的密度改变是没用的
			if(rigidbody!=null)
			{
				rigidbody.resetMassData();
			}
		
			
		}

		public function setPackedFixture(fixture:b2Fixture)
		{
			
			this.fixture=fixture;
			SynchronizeDataTo();
		}
		
		
		
		/**
		 *返回包围框 
		 * @return 
		 * 
		 */		
		public function getAABB():Rect
		{
			if(fixture!=null)
			{
				var aabb:b2AABB=fixture.GetAABB();
				var rect:Rect=CastTool.castAABBToRect(aabb);
				rect.x*=valueScale;
				rect.y*=valueScale;
				rect.width*=valueScale;
				rect.height*=valueScale;
				
				return rect;
			}
			else
			{
				return null;
			}
			
		}
		
		
		
		public function loop()
		{

			SynchronizeDataFrom();
		}
		
		
		/**
		 *从fixture里同步数据到本类
		 * 
		 */		
		private function SynchronizeDataFrom():void
		{
			if(fixture!=null)
			{
				
				_density=fixture.GetDensity();
				_friction=fixture.GetFriction();
				_restitution=fixture.GetRestitution();
				
			}
		}
	}
}