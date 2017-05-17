package XGameEngine.Util
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author o
	 */
	public class  MathTool
	{
		static public function rectToPointArray(rect:Rectangle):Vector.<Point>
		{
		var array:Vector.<Point> = new Vector.<Point>;
		array[0] = new Point(rect.x,rect.y);
		array[1] = new Point(rect.x+rect.width,rect.y);
		array[2] = new Point(rect.x,rect.y+rect.height);
		array[3] = new Point(rect.x+rect.width,rect.y+rect.height);
			
			return array;
		}
	}
	
}