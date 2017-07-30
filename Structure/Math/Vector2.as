package XGameEngine.Structure.Math
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author o
	 */
	public class Vector2 
	{
		static private var _VEC2_DOWN:Vector2 = new Vector2(0, 1);
		static private var _VEC2_UP:Vector2 = new Vector2(0, -1);
		static private var _VEC2_LEFT:Vector2 = new Vector2(-1, 0);
		static private var _VEC2_RIGHT:Vector2=new Vector2(1,0);
		private static var _VEC2_ZERO:Vector2=new Vector2(0,0);
		
		public var x:Number;
		public var y:Number;
		
		public function Vector2(x:Number, y:Number)
		{
			this.x = x;
			this.y = y;
		}
		
		public static function get VEC2_ZERO():Vector2
		{
			return _VEC2_ZERO.clone();
		}

		public static function get VEC2_RIGHT():Vector2
		{
			return _VEC2_RIGHT.clone();
		}

		public static function get VEC2_LEFT():Vector2
		{
			return _VEC2_LEFT.clone();
		}

		public static function get VEC2_UP():Vector2
		{
			return _VEC2_UP.clone();
		}

		public static function get VEC2_DOWN():Vector2
		{
			return _VEC2_DOWN.clone();
		}

		public function multiply(i:Number):Vector2
		{
			
			
			return new Vector2(x *i, y *i);
		}
		
		
		public function toPoint():Point
		{
			
			
			return new Point(x,y);
		}
		
		
		public function clone():Vector2
		{
			return new Vector2(x, y);
		}
		
		public function toString():String 
		{
			return "[x=" + x + " y=" + y + "]";
		}
	}
	
}