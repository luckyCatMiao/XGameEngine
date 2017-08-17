package XGameEngine.Advanced.Box2DPlus.Rigidbody
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2Fixture;

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

		public function RigidPart()
		{
		}
		
		
		public function setPackedFixture(fixture:b2Fixture)
		{
			
			this.fixture=fixture;
		}
		
		
		
		public function loop()
		{
			
			SynchronizeData();
		}
		
		
		/**
		 *从实际的fixture里同步数据 
		 * 
		 */		
		private function SynchronizeData():void
		{
			if(fixture!=null)
			{
				
				
			}
		}
	}
}