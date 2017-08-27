package XGameEngine.GameObject.GameObjectComponent.Collider.Collider
{
	import XGameEngine.BaseObject.BaseComponent.CommonlyComponent;
	import XGameEngine.BaseObject.BaseDisplayObject;
	import XGameEngine.GameEngine;
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
		public var shape:BaseDisplayObject;
		/**
		 *绘制颜色 
		 */		
		public var debugColor:uint;
		
		private var common_com:CommonlyComponent;
		public function Collider()
		{
			common_com = new CommonlyComponent();
			
			shape=new BaseDisplayObject();
			addChild(this.shape);
		}
		
		
		/**
		 *返回需要检测的点组,由子类覆盖 
		 * @return 这里的点是host坐标系里的 而不是collider坐标系里的
		 * 
		 */		
		public function getCheckPoint():List
		{
			throw new Error("调用基类该方法无意义!");
		
		}
	
		
		/**
		 * debug绘制出碰撞器的范围以及碰撞点
		 */
		public function debugShape()
		{
			//throw new Error("调用基类该方法无意义!");
			//如果需要debug 
			if (GameEngine.getInstance().debug&&debug==true)
			{
				
				shape.alpha=0.75;
			}
				//不需要debug
			else if (GameEngine.getInstance().debug==false||debug==false)
			{
				shape.alpha=0;
			}
		}
		
		
		public function getCommonlyComponent():CommonlyComponent
		{
			return common_com;
		}
		
		
	}
	
}