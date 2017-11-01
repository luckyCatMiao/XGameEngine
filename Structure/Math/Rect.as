package XGameEngine.Structure.Math
{
	import XGameEngine.GameEngine;
	
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author o
	 */
	public class Rect 
	{
		
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		
		/**
		 *返回舞台大小的rect 
		 * @param s
		 * @return 
		 * 
		 */		
		static public function getStageRect():Rect
		{
			var s:Stage=GameEngine.getInstance().stage;
			
			var r:Rect=new Rect(0,0,s.stageWidth,s.stageHeight);
				
			return r;
		}
		
		
		
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	inputPoint 如果为true 则输入的后两个按照x y坐标而不是宽高来解释
		 */
		public function Rect(x:Number, y:Number, width:Number, height:Number,inputPoint:Boolean=false)
		{
				this.x = x;
				this.y = y;
				
				if (!inputPoint)
				{
				this.width = width;
				this.height = height;
				}
				else
				{
				this.width = width - x;
				this.height = height - y;
				}
				

		}
		
		
		public function scale(a:Number):Rect
		{
			
			return new Rect(x,y,width*a,height*a);
		}
		
		
	/**
	 *返回中上的点 
	 * @return 
	 * 
	 */	
	public function getTopPoint():Point
	{
			return new Point((x+width)/2,y);
	}
	/**
	 *返回中下的点 
	 * @return 
	 * 
	 */	
	public function getBottomPoint():Point
	{
			return new Point((x+width)/2,y+height);
	}
	/**
	 *返回中左的点 
	 * @return 
	 * 
	 */	
	public function getLeftPoint():Point
	{
			return new Point(x,(y+height)/2);
	}
	/**
	 *返回中右的点 
	 * @return 
	 * 
	 */	
	public function getRightPoint():Point
	{
			return new Point((x+width),(y+height)/2);
	}
	
	/**
	 *返回中间点 
	 * @return 
	 * 
	 */	
	public function getCenterPoint():Point
	{
			return new Point((getLeftPoint().x+getRightPoint().x)/2,(getTopPoint().y+getBottomPoint().y)/2);
	}
	
	
	
	/**
	 *返回左上角的点 
	 * @return 
	 * 
	 */	
	public function getLeftTopPoint():Point
	{
			return new Point(x,y);
	}
	/**
	 *返回左下角的点 
	 * @return 
	 * 
	 */	
	public function getLeftBottomPoint():Point
	{
	
			return new Point(x,y+height);
	}
	/**
	 *返回右上角的点 
	 * @return 
	 * 
	 */	
	public function getRightTopPoint():Point
	{
			return new Point(x+width,y);
	}
	/**
	 *返回右下角的点 
	 * @return 
	 * 
	 */	
	public function getRightBottomPoint():Point
	{
			return new Point(x + width, y + height);
	}
	
	
	/**
	 *返回右边的x 
	 * @return 
	 * 
	 */	
	public function getRightX():Number
	{
		return getRightBottomPoint().x;
	}
	/**
	 *返回左边的x (等同于直接的x)
	 * @return 
	 * 
	 */	
	public function getLeftX():Number
	{
		return getLeftBottomPoint().x;
	}
	/**
	 *返回中间的x 
	 * @return 
	 * 
	 */	
	public function getCenterX():Number
	{
		return getCenterPoint().x;
	}
	
	
	/**
	 *返回上面的Y (等同于直接的y)
	 * @return 
	 * 
	 */	
	public function getTopY():Number
	{
		return getTopPoint().y;
	}
	/**
	 *返回下面的y 
	 * @return 
	 * 
	 */	
	public function getBottomY():Number
	{
		return getLeftBottomPoint().y;
	}
	/**
	 *返回中间y
	 * @return 
	 * 
	 */	
	public function getCenterY():Number
	{
		return getCenterPoint().y;
	}
	
	
	public function toRectangle():Rectangle
	{
		return new Rectangle(x, y, width, height);
	
	}
	
	
	public function toString():String 
	{
		return "[Rect x=" + x + " y=" + y + " width=" + width + " height=" + height + "]";
	}
	
	public static function RectangleToRect(r:Rectangle):Rect
	{
		var rect:Rect=new Rect(r.x,r.y,r.width,r.height);
		
		return rect;
	}
	
	
	/**
	 *移动rect的位置 
	 * @param x
	 * @param y
	 * 
	 */	
	public function move(xValue:Number, yValue:Number):void
	{
		x+=xValue;
		y+=yValue;
		
	}
	
	
	/**
	 *移动rect x坐标 
	 * @param value
	 * 
	 */	
	public function moveX(value:Number):void
	{
		move(value,0);
		
	}
	
	
	/**
	 *移动rect y坐标 
	 * @param value
	 * 
	 */	
	public function moveY(value:Number):void
	{
		move(0,value);
		
	}
	
	
	/**
	 *朝rect中心收缩rect  width 和height为原来的 (1/scale)倍
	 * @param scale 比例
	 * @return 
	 * 
	 */	
	public function shrink(scale:Number):Rect
	{
	
		
		shrinkX(scale);
		shrinkY(scale);
		
	
		
		
		return this;
	}
	
	
	public function shrinkX(scale:Number)
	{
		//目标宽度
		var targetWidth:Number=width*scale;
		//和现在宽度的差值
		var a:Number=width-targetWidth;
		x+=a/2;
		width=targetWidth;
	}
	
	public function shrinkY(scale:Number)
	{
		//目标高度
		var targetHeight:Number=height*scale;
		//和现在高度的差值
		var a:Number=height-targetHeight;
		y+=a/2;
		height=targetHeight;
	}
	
	public function clone():Rect
	{
		// TODO Auto Generated method stub
		return new Rect(x,y,width,height);
	}
	
	/**
	 *移动当前rect使得与传入rect的中心点相同 
	 * @param rect
	 * @return 
	 * 
	 */	
	public function moveToSameCenter(rect:Rect):Rect
	{
		//计算出目标的中心点
		var center:Vector2=Vector2.pointToV2(rect.getCenterPoint());
		//中心点往左上角扩展1/2长宽的位置就是目标xy
		var targetX:Number=center.x-width/2;
		var targetY:Number=center.y-height/2;
		
		
		return new Rect(targetX,targetY,width,height);
	}
	
	
	}
}