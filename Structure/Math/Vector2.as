package XGameEngine.Structure.Math
{
	
	import XGameEngine.Util.MathTool;
	
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
			
			return new Vector2(x*i,y*i);
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
		public static function getRotationVector2(angle:Number):Vector2
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
		
		
		public function divide(i:Number):Vector2
		{
		
			return new Vector2(x/i,y/i);
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
		
		/**
		 *减去一个向量 
		 * @param v
		 * @return 
		 * 
		 */		
		public function reduce(v:Vector2):Vector2
		{
			
			return new Vector2(x-v.x,y-v.y);

		}
		
		/**
		 *加上一个向量 
		 * @param v
		 * @return 
		 * 
		 */		
		public function add(v:Vector2):Vector2
		{
		
			
			return new Vector2(x+v.x,y+v.y);

		}
		
		/**
		 *向量标准化(转化为单位向量) 
		 * 
		 */		
		public function normalize():Vector2
		{
			var s:Number=size;
			
			var newX:Number=0;
			var newY:Number=0;
			
			if(s==0)
			{
				//避免除0错
				newX=0;
				newY=0;
			}
			else
			{
				newX=x/s;
				newY=y/s;
				
			}
			
			return new Vector2(newX,newY);
		}
		
		
		/**
		 *返回向量的大小 
		 * @return 
		 * 
		 */		
		public function get size():Number
		{
			return Math.sqrt(x*x+y*y);
		}
		
		/**
		 *返回向量是否相等 
		 * @param v
		 * @return 
		 * 
		 */		
		public function equal(v:Vector2):Boolean
		{
			return x==v.x&&y==v.y;
		}
		
		public function toRotation():Number
		{
			var v:Vector2=this.normalize();
		
			return Math.atan2(v.y,v.x)*180/Math.PI;
		}
		
		/**
		 *翻转向量 
		 * @return 
		 * 
		 */		
		public function reverse():Vector2
		{
			return new Vector2(-x,-y);
		}
		
		/**
		 *返回一个随机朝向的单位向量 
		 * @return 
		 * 
		 */		
		public static function getRandomNormalizeVector2():Vector2
		{
			
			return Vector2.getRotationVector2(MathTool.random(0,180));
		}
		
		/**
		 *返回两个向量的夹角(角度) 
		 * @param distance
		 * @param param1
		 * @return 
		 * 
		 */		
		public static function getTwoVector2Rotation(v1:Vector2, v2:Vector2):Number
		{
			
			var v1N:Vector2=v1.normalize();
			var v2N:Vector2=v2.normalize();
			
			
		
			return Math.acos(v1N.dot(v2N))*180/Math.PI;
		}
		
		/**
		 *求向量点积 
		 * @param v2N
		 * @return 
		 * 
		 */		
		public function dot(v:Vector2):Number
		{
		
			return x*v.x+y*v.y;
		}
		
		public function getDistance(target2:Vector2):Number
		{
			// TODO Auto Generated method stub
			return Vector2.getDistance(this,target2);
		}
		
		
		/**
		 *返回当前向量的垂直标准化向量 
		 * @param referencePoint
		 * @return 
		 * 
		 */		
		public function getVerticalNormalizeVector2(direction:Number=0):Vector2
		{
			var r:Number;
			
			//计算过程是返回当前角度 随机加减90度 再转化为向量
			if(direction==0)
			{
				r=this.toRotation()+MathTool.randomZF()*90;	
			}
			else
			{
				//固定角度
				r=this.toRotation()+direction*90;
			}
			
			
			return Vector2.getRotationVector2(r);;
		}
		
		/**
		 *返回和另一向量的夹角 
		 * @param param0
		 * @return 
		 * 
		 */		
		public function getAngleBetween(param0:Vector2):Number
		{
			
			return Vector2.getTwoVector2Rotation(this,param0);
		}
	}
	
}