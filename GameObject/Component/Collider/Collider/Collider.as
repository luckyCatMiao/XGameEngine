package XGameEngine.GameObject.Component.Collider.Collider
{
	import XGameEngine.GameObject.CommonComponent.CommonlyComponent;
	import XGameEngine.Structure.List;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author o
	 */
	public class Collider extends Sprite
	{
	
		/**
		 * 是否debug
		 */
		public var debug:Boolean = false;
		/**
		 *debug的面板 
		 */		
		public var shape:Shape;
		/**
		 *绘制颜色 
		 */		
		public var debugColor:uint;
		
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