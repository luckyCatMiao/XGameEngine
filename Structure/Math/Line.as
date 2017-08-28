package XGameEngine.Structure.Math
{
	import flash.display.DisplayObject;
	import flash.security.X500DistinguishedName;
	
	import script.GameObject.SoccerBall;
	import script.GameObject.FieldPlayer;

	/**
	 *线段 由两个点组成 无方向
	 * @author Administrator
	 * 
	 */	
	public class Line
	{
		public var start:Vector2;
		public var end:Vector2;
		public function Line(start:Vector2,end:Vector2)
		{
			this.start=start;
			this.end=end;
		}
		
		/**
		 *根据两个显示对象创建一条连接线(两个对象不在同一个坐标系中可能会返回奇怪的结果) 
		 * @param o1
		 * @param o2
		 * @return 
		 * 
		 */		
		public static function createLineByTwoObject(o1:DisplayObject, o2:DisplayObject):Line
		{
			var v1:Vector2=new Vector2(o1.x,o1.y);
			var v2:Vector2=new Vector2(o2.x,o2.y);
			
			return new Line(v1,v2);
		}
		
		
		/**
		 *转化为vector2，将失去位置属性 
		 * @return 
		 * 
		 */		
		public function toVector2():Vector2
		{
			
			return new Vector2(end.x-start.x,end.y-start.y);
		}
	}
}