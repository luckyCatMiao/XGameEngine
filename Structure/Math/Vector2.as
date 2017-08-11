package XGameEngine.Structure.Math
{
	import Script.GameObject.Bullet.AbstractBullet;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
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
		
		/**
		 *根据角度返回 单位向量 
		 * @param param0
		 * 
		 */		
		public static function getDirectionVector2(angle:Number):Vector2
		{
			
			//先转换为弧度
			var h:Number=angle/180*Math.PI;
			
			var v:Vector2=new Vector2(Math.cos(h),Math.sin(h));
		
			return v;
		}
		
		
		/**
		 *返回距离 
		 * @param point1
		 * @param point2
		 * @return 
		 * 
		 */		
		public static function getDistance(v1:Vector2, v2:Vector2):Number
		{
			var point1:Point=v1.toPoint();
			var point2:Point=v2.toPoint();
			
			var xx:Number=point1.x-point2.x;
			var yy:Number=point1.y-point2.y;
			
			return Math.sqrt(Math.pow(xx,2)+Math.pow(yy,2));
		}
		
		
		/**
		 *point转化成v2 
		 * @param point
		 * @return 
		 * 
		 */		
		public static function pointToV2(point:Point):XGameEngine.Structure.Math.Vector2
		{
			
			var v:Vector2=new Vector2(point.x,point.y);
			
			return v;
		}
		
		
		public function divide(param0:Number):void
		{
			
			this.x/=param0;
			this.y/=param0;
		}
		
		
		/**
		 *获取指定对象鼠标的局部坐标
		 * @param stage
		 * @return 
		 * 
		 */		
		public static function getMouseV2(o:DisplayObject):Vector2
		{
		
			return new Vector2(o.mouseX,o.mouseY);
		}
	}
	
}