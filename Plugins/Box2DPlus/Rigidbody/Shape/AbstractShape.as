package XGameEngine.Plugins.Box2DPlus.Rigidbody.Shape
{
	import Box2D.Collision.Shapes.b2Shape;
	
	import XGameEngine.Plugins.Box2DPlus.PhysicsWorld;
	import XGameEngine.Util.Error.AbstractMethodError;

	public class AbstractShape
	{
		protected var valueScale:Number;
		
		
		/**
		 *相对于刚体的本地坐标 因为一个刚体可以有多个子fixture 
		 */		
		protected var _x:Number=0;
		protected var _y:Number=0;
		protected var _rotation:Number=0;
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
			_y = value/valueScale;
			
			
		}
		
		public function get x():Number
		{
			return _x*valueScale;
		}
		
		public function set x(value:Number):void
		{
			_x = value/valueScale;
			
		}
		
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		public function set rotation(value:Number):void
		{
			_rotation = value;	
		}
		
		public function copy():AbstractShape
		{
			throw new AbstractMethodError();
		}

	
	}
}