package XGameEngine.GameObject.Component.Collider
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import XGameEngine.Structure.List;

	/**
	 * ...
	 * @author o
	 */
	public class Collider extends Sprite
	{
	
		public function Collider()
		{
			
		}
		
		
		//返回需要检测的点组,由子类覆盖
		public function getCheckPoint():List
		{
			throw new Error("调用基类该方法无意义!");
		
		}
	
		
		
	}
	
}