package XGameEngine.Advanced.Box2DPlus.Rigidbody.Shape
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	
	import XGameEngine.Advanced.Box2DPlus.PhysicsWorld;

	public class CircleShape extends AbstractShape
	{
		private var shape:b2CircleShape;
	
		private var _radius:Number;
		
		public function CircleShape(radius:Number)
		{
			this.shape=new b2CircleShape(radius/valueScale);
			this._radius=radius;
			
		}
		
		
		public function get radius():Number
		{
			return _radius*valueScale;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
			shape.SetRadius(_radius/valueScale);
		}

		
		
		override public function getShape():b2Shape
		{
			// TODO Auto Generated method stub
			return shape;
		}
		
		override public function set x(value:Number):void
		{
		
			super.x = value;
			shape.SetLocalPosition(new b2Vec2(_x/valueScale,_y/valueScale))
		}
		
		override public function set y(value:Number):void
		{
			// TODO Auto Generated method stub
			super.y = value;
			shape.SetLocalPosition(new b2Vec2(_x/valueScale,_y/valueScale))
		}
		
	
		

	}
}