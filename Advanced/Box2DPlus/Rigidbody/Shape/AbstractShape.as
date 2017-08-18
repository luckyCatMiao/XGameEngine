package XGameEngine.Advanced.Box2DPlus.Rigidbody.Shape
{
	import Box2D.Collision.Shapes.b2Shape;
	
	import XGameEngine.Advanced.Box2DPlus.PhysicsWorld;
	import XGameEngine.Constant.Error.AbstractMethodError;

	public class AbstractShape
	{
		protected var valueScale:Number;
		
		
		/**
		 *相对于刚体的本地坐标 因为一个刚体可以有多个子fixture 
		 */		
		protected var _x:Number=0;
		protected var _y:Number=0;
		public function AbstractShape()
		{
			this.valueScale=PhysicsWorld.valueScale;
		}
		
		
		public function getShape():b2Shape
		{
			throw new AbstractMethodError();
		}
		
		
		public function get y():Number
		{
			return _y*valueScale;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
			
			
		}
		
		public function get x():Number
		{
			return _x*valueScale;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
			
		}
	}
}