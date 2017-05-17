package XGameEngine.GameObject.Component.Collider
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import XGameEngine.GameEngine;
	
	/**
	 * ...
	 * @author o
	 */
	//代表一个方形的碰撞体
	public class RectCollider extends Collider
	{
		
	public function RectCollider(width:uint,height:uint,color:uint)
	{
		var al:Number = GameEngine.getInstance().debug == true?0.3:0;
				
			this.graphics.beginFill(color,al);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
	}
		
	
	override public function getCheckPoint():Vector.<Point> 
	{
		var points:Vector.<Point> = new Vector.<Point>;
		points[0] = getLeftTopPoint();
		points[1] = getLeftBottomPoint();
		points[2] = getRightTopPoint();
		points[3] = getRightBottomPoint();
		
		
		return points;
	}
		
	
	//返回左上角的点
	public function getLeftTopPoint():Point
	{
			return new Point(x,y);
	}
	//返回左下角的点
	public function getLeftBottomPoint():Point
	{
	
			return new Point(x,y+height);
	}
	//返回右上角的点
	public function getRightTopPoint():Point
	{
			return new Point(x+width,y);
	}
	//返回右下角的点
	public function getRightBottomPoint():Point
	{
			return new Point(x + width, y + height);
	}
		
	}
	
}