package XGameEngine.Structure.Math
{
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
		static public function getStageRect(s:Stage):Rect
		{
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
	public function getTopX():Number
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
	}
}