package XGameEngine.Structure.Math
{
	
	/**
	 * ...
	 * @author o
	 */
	public class Vector2 
	{
		static public var VEC2_DOWN = new Vector2(0, -1);
		static public var VEC2_UP = new Vector2(0, 1);
		static public var VEC2_LEFT = new Vector2(-1, 0);
		static public var VEC2_RIGHT=new Vector2(1,0);
		
		
		public var x:Number;
		public var y:Number;
		public function Vector2(x:Number, y:Number)
		{
			this.x = x;
			this.y = y;
		}
		
		public function multiply(i:Number):Vector2
		{
			x *= i;
			y *= i;
			
			return this.clone();
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