package XGameEngine.GameObject.Component
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import XGameEngine.GameObject.Component.Collider.RectCollider;
	import XGameEngine.UI.Draw.Color;
	import flash.geom.Rectangle;
	import XGameEngine.GameEngine;
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.Util.MathTool;
	import XGameEngine.GameObject.BaseGameObject;
	
	/**
	 * ...
	 * @author o
	 */
	public class TransformComponent extends BaseComponent
	{
		
		private var oldWidth:Number;
		private var oldHeight:Number;
		private var oldScaleX:Number;
		private var oldScaleY:Number;
		
		private var aabbDebugShape:Shape;
		
		private var _oldaabb:Rect;
		public function TransformComponent(o:BaseGameObject)
		{
			super(o);
			oldWidth = host.width;
			oldHeight = host.height;
			oldScaleX = host.scaleX;
			oldScaleY = host.scaleY;
			
			_oldaabb = aabb;
			
		}
		
		
		/**
		 * 设置X轴方向(不影响当前的缩放参数)
		 * @param	o
		 */
		public function setXAxis(d:Boolean)
		{
			var value:Number=MathTool.getPVMSG(oldScaleX);
			if (d)
			{
				//设置为正方向(即原始方向)
				host.scaleX=MathTool.setNPNumber(host.scaleX,value)
				
			}
			else
			{
				//设置为逆方向
				host.scaleX=MathTool.setNPNumber(host.scaleX,-value)
			}
		}
		
		
		/**
		 * 计算出当前的包围框随着人物的动作占用空间可能会一直变化(特别是使用遮罩)
		 */
		public function get aabb():Rect 
		{
			
			var r:Rectangle=host.getRect(host);
			return new Rect(r.x, r.y, host.width, host.height);
		}
		
		
		/**
		 * 使用初始长宽计算的包围框
		 */
		public function get oldaabb():Rect
		{
			return _oldaabb;
		}
		
		public function loop()
		{
			if (GameEngine.getInstance().debug == true)
			{
				DrawAABB();
			}
		}
		
		public function DrawAABB()
		{
			
			if (aabbDebugShape == null)
			{
				aabbDebugShape = new Shape();
				
				//设置为最高深度
				host.getGameObjectComponent().addChildToHighestDepth(aabbDebugShape);

			}
			
			aabbDebugShape.graphics.clear();
			aabbDebugShape.graphics.lineStyle(2, Color.YELLOW, 0.7);
			aabbDebugShape.graphics.moveTo(aabb.getLeftTopPoint().x+3, aabb.getLeftTopPoint().y+3);
			aabbDebugShape.graphics.lineTo(aabb.getRightTopPoint().x-3, aabb.getRightTopPoint().y+3);
			aabbDebugShape.graphics.lineTo(aabb.getRightBottomPoint().x-3, aabb.getRightBottomPoint().y-3);
			aabbDebugShape.graphics.lineTo(aabb.getLeftBottomPoint().x+3, aabb.getLeftBottomPoint().y-3);
			aabbDebugShape.graphics.lineTo(aabb.getLeftTopPoint().x+3, aabb.getLeftTopPoint().y+3);
		
		}
		
	}
	
}