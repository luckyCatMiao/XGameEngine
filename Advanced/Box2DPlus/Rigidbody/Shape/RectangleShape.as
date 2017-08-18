package XGameEngine.Advanced.Box2DPlus.Rigidbody.Shape
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;

	public class RectangleShape extends AbstractShape
	{
		private var shape:b2PolygonShape;
		
		public function RectangleShape(width:Number,height:Number)
		{
			this.shape=b2PolygonShape.AsBox(width/2/valueScale,height/2/valueScale);
			
		}
		
		override public function getShape():b2Shape
		{
			// TODO Auto Generated method stub
			return shape;
		}
		
		override public function set x(value:Number):void
		{
			// TODO Auto Generated method stub
			super.x = value;
		}
		
		override public function set y(value:Number):void
		{
			// TODO Auto Generated method stub
			super.y = value;
		}
		
		
		
		
	}
}