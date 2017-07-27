package XGameEngine.Structure.Math
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author o
	 */
	public class Vector2 
	{
		static public var VEC2_DOWN:Vector2 = new Vector2(0, 1);
		static public var VEC2_UP:Vector2 = new Vector2(0, -1);
		static public var VEC2_LEFT:Vector2 = new Vector2(-1, 0);
		static public var VEC2_RIGHT:Vector2=new Vector2(1,0);
		public static var VEC2_ZERO:Vector2=new Vector2(0,0);
		
		public var x:Number;
		public var y:Number;
		
		public function Vector2(x:Number, y:Number)
		{
			this.x = x;
			this.y = y;
		}
		
		public function multiply(i:Number):Vector2
		{
			
			
			return new Vector2(x *= i, y *= i);
		}
		
		
		public function toPoint():Point
		{
			
			
			return new Point(x,y);
		}
		
		
		public function clone()
		{
			return new Vector2(x, y);
		}
		
		public function toString():String 
		{
			return "[x=" + x + " y=" + y + "]";
		}
	}
	
}