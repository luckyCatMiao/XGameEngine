package XGameEngine.GameObject.Component.Collider
{
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.UI.Draw.Color;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import XGameEngine.GameEngine;
	import XGameEngine.Structure.List;
	
	/**
	 * ...
	 * @author o
	 */
	//代表一个方形的碰撞体
	public class RectCollider extends Collider
	{
		static public var POINT_LEFT:String = "left";
		static public var POINT_RIGHT:String = "right";
		static public var POINT_UP:String = "up";
		static public var POINT_DOWN:String = "down";
		

		private var boxWidth:Number;
		private var boxHeight:Number;
		
		private var aabb:Rect;
		
		
	public function RectCollider(width:uint,height:uint,color:uint)
	{
		
	
		
		var al:Number = GameEngine.getInstance().debug == true?0.4:0;
				
			this.graphics.beginFill(color,al);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
			
			boxWidth = width;
			boxHeight = height;

			
			//aabb = new Rect(0, 0, width, height);
			
			if (GameEngine.getInstance().debug == true)
			{
				//画出碰撞点
				DrawCheckPoint();
			}
			
			
			
	}
		
	
	public function DrawCheckPoint() 
	{
			this.graphics.beginFill(Color.GREEN);
			for each(var p:Point in getCheckPoint().Raw)
			{
				//点往中间靠一点 防止在调试模式中突出平面。。
				var drawX:Number = p.x > getCenterPoint().x?p.x - 3.5:p.x + 3.5;
				var drawY:Number = p.y > getCenterPoint().y?p.y - 3.5:p.y + 3.5;
				
				
				this.graphics.drawCircle(drawX, drawY, 3.5);
			}
			this.graphics.endFill();
		
	}
	
	override public function getCheckPoint():List
	{
		var list:List = new List();
		list.add(getTopPoint());
		list.add(getDownPoint());
		list.add(getLeftPoint());
		list.add(getRightPoint());
		
		return list;
	}
		
//返回中上的点
	public function getTopPoint():Point
	{
			return new Point((x+boxWidth)/2,y);
	}
	//返回中下的点
	public function getDownPoint():Point
	{
			return new Point((x+boxWidth)/2,y+boxHeight);
	}
	//返回中左的点
	public function getLeftPoint():Point
	{
			return new Point(x,(y+boxHeight)/2);
	}
	//返回中右的点
	public function getRightPoint():Point
	{
			return new Point((x+boxWidth),(y+boxHeight)/2);
	}
	
	//返回中间点
	public function getCenterPoint():Point
	{
			return new Point((x+boxWidth)/2,(y+boxHeight)/2);
	}
	
	
	
	//返回左上角的点
	public function getLeftTopPoint():Point
	{
			return new Point(x,y);
	}
	//返回左下角的点
	public function getLeftBottomPoint():Point
	{
	
			return new Point(x,y+boxHeight);
	}
	//返回右上角的点
	public function getRightTopPoint():Point
	{
			return new Point(x+boxWidth,y);
	}
	//返回右下角的点
	public function getRightBottomPoint():Point
	{
			return new Point(x + boxWidth, y + boxHeight);
	}
		
	}
	
}