package XGameEngine.Plugins.Box2DPlus.Rigidbody.Shape
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;

	public class RectangleShape extends AbstractShape
	{
		private var shape:b2PolygonShape;
		
		private var _height:Number;
		private var _width:Number;
		
		
		public function RectangleShape(w:Number,h:Number)
		{
			_width=w/valueScale;
			_height=h/valueScale;
			
	
			resetBox();
			
		}
		
		public function get width():Number
		{
			return _width*valueScale;
		}

		public function set width(value:Number):void
		{
			_width = value/valueScale;
			resetBox();
		}

		public function get height():Number
		{
			return _height*valueScale;
		}

		public function set height(value:Number):void
		{
			_height = value/valueScale;
			resetBox();
		}

		
		
		private function resetBox():void
		{
			var w:Number=_width/2;
			var h:Number=_height/2;
			var center:b2Vec2=new b2Vec2(_x,_y);
			
			this.shape=b2PolygonShape.AsOrientedBox(w,h,center,_rotation/180*Math.PI);
			
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
			resetBox();
		}
		
		override public function set y(value:Number):void
		{
			// TODO Auto Generated method stub
			super.y = value;
			resetBox();
		}
		
		override public function set rotation(value:Number):void
		{
			// TODO Auto Generated method stub
			super.rotation = value;
			resetBox();
		}
		
		
		
		
	}
}