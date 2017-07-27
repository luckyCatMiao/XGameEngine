package XGameEngine.GameObject.GameObjectComponent.Collider.Collider
{
	import XGameEngine.GameEngine;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.UI.Draw.Color;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 代表一个方形的碰撞体
	 * @author o
	 */
	
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
			boxWidth = width;
			boxHeight = height;
			
			debugColor=color;
			
			//这里一开始就要初始化 而且和其他的debug不同 不能remove掉 只能调节透明度
			//因为碰撞检测时需要提供形状 只提供点不行
			
			this.shape.graphics.beginFill(debugColor,0.4);
			this.shape.graphics.drawRect(0, 0, width, height);
			this.shape.graphics.endFill();
			//画出碰撞点
			DrawCheckPoint();
			
	}
		
	
	private function DrawCheckPoint() 
	{
			this.shape.graphics.beginFill(Color.GREEN);
			for each(var p:Point in getCheckPoint().Raw)
			{
				//点往中间靠一点 防止在调试模式中突出平面。。
				var drawX:Number = p.x ;
				if (p.x != getCenterPoint().x)
				{
					p.x=p.x> getCenterPoint().x?p.x - 3.5:p.x + 3.5;
				}
				var drawY:Number = p.y;
				if (p.x != getCenterPoint().x)
				{
					p.y = p.y > getCenterPoint().y?p.y - 3.5:p.y + 3.5;;
				}
				
				
				this.shape.graphics.drawCircle(drawX, drawY, 3.5);
			}
			this.shape.graphics.endFill();
		
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
	
	/**
	 * 根据碰撞点返回名字 这样可以知道碰撞的是哪个点,只适用于碰撞器是方形碰撞器
	 * @param	hit
	 */
	public function getHitPointName(hit:Point):String
	{

		if (hit.equals(getLeftPoint()))
		{
			return RectCollider.POINT_LEFT;
		}
		else if (hit.equals(getRightPoint()))
		{
			return RectCollider.POINT_RIGHT;
		}
		else if (hit.equals(getDownPoint()))
		{
			return RectCollider.POINT_DOWN;
		}
		else if (hit.equals(getTopPoint()))
		{
			return RectCollider.POINT_UP;
		}
		else
		{
			throw new Error("no point find!");
		}
	}
	
	
	/**
	 * 根据碰撞点组 可以知道有哪几个位置的点碰撞了
	 * @param	hit
	 */
	public function getHitPointNames(pointArray:List):List
	{
		
		var arr:List=new List();
		for each(var p:Point in pointArray.Raw)
		{
			arr.add(getHitPointName(p));
		}
		
		
		return arr;
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