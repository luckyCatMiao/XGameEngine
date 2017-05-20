package XGameEngine.GameObject.Component.Collider
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import XGameEngine.GameObject.CommonComponent.CommonlyComponent;
	import XGameEngine.Structure.List;

	/**
	 * ...
	 * @author o
	 */
	public class Collider extends Sprite
	{
	
		
		public var debug:Boolean = false;
		public var shape:Shape = new Shape();
		
		private var common_com:CommonlyComponent;
		public function Collider()
		{
			common_com = new CommonlyComponent();
		}
		
		
		//返回需要检测的点组,由子类覆盖
		public function getCheckPoint():List
		{
			throw new Error("调用基类该方法无意义!");
		
		}
	
		
		/**
		 * debug绘制出碰撞器的范围以及碰撞点
		 */
		public function debugShape()
		{
			throw new Error("调用基类该方法无意义!");
		}
		
		
			public function getCommonlyComponent():CommonlyComponent
			{
				return common_com;
			}
		
		
	}
	
}