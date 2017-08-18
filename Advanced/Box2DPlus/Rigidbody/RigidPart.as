package XGameEngine.Advanced.Box2DPlus.Rigidbody
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2Fixture;
	
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
		public var shape:b2Shape;

		/**
		 *实际包装的 fixture
		 */		
		private var fixture:b2Fixture;
		
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
		
		

		public function RigidPart()
		{
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
			
				
				
				
			}
		}
		
		public function get restitution():Number
		{
			return _restitution;
		}

		public function set restitution(value:Number):void
		{
			MathTool.restrictRange(value,0,1);
			_restitution = value;
		}

		public function get friction():Number
		{
			return _friction;
		}

		public function set friction(value:Number):void
		{
			MathTool.restrictRange(value,0,1);
			_friction = value;
		}

		public function get density():Number
		{
			return _density;
		}

		public function set density(value:Number):void
		{
			_density = value;
		}

		public function setPackedFixture(fixture:b2Fixture)
		{
			
			this.fixture=fixture;
			SynchronizeDataTo();
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