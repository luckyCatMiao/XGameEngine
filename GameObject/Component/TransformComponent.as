package XGameEngine.GameObject.Component
{
	import XGameEngine.GameEngine;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.Component.Collider.RectCollider;
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.UI.Draw.Color;
	import XGameEngine.UI.XTextField;
	import XGameEngine.Util.MathTool;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	/**
	 * 变换组件
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
		
		private var _debugPosition:Boolean=false;
		public var debugAABB:Boolean = false;
		
		private var posTextfield:XTextField = new XTextField();
		public function TransformComponent(o:BaseGameObject)
		{
			super(o);
			
			//保存了一些原始数据
			oldWidth = host.width;
			oldHeight = host.height;
			oldScaleX = host.scaleX;
			oldScaleY = host.scaleY;
			
		
			
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
			return new Rect(r.x, r.y, r.width, r.height);
		}
		
		
		/**
		 * 使用初始长宽计算的包围框
		 */
		public function get oldaabb():Rect
		{
			//oldAABB即第一次确定的值 因为有些对象运动时会改变aabb的大小
			if(_oldaabb==null)
			{
				_oldaabb = aabb;
			}
			
			return _oldaabb;
		}
		
		public function get debugPosition():Boolean 
		{
			return _debugPosition;
		}
		
		public function set debugPosition(value:Boolean):void 
		{
			if (value == true)
			{
				host.stage.addChild(posTextfield);
			}
			else if (value == false)
			{
				host.stage.removeChild(posTextfield);
			}
			
			_debugPosition = value;
		}
		
		
		public function loop()
		{
			if (GameEngine.getInstance().debug == true)
			{
				if (debugAABB == true)
				{
					DrawAABB();
				}
				if (_debugPosition == true)
				{
					DebugPosition();
				}	
			}
			else if (GameEngine.getInstance().debug == false)
			{
				if (aabbDebugShape != null)
				{
				aabbDebugShape.graphics.clear();
				}
				
				
				if (posTextfield.parent != null)
				{
					posTextfield.parent.removeChild(posTextfield);
				}
				
			}
			
		}
		
		private function DebugPosition():void 
		{
			if (posTextfield.parent == null)
			{
				host.stage.addChild(posTextfield);
			}
			
			posTextfield.text = "X:" + host.centerGlobalPoint.x + "Y:" + host.centerGlobalPoint.y;
			posTextfield.size = 15;
			posTextfield.x = host.centerGlobalPoint.x-posTextfield.textWidth/2;
			posTextfield.y = host.leftTopGlobalPoint.y - 30;
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
		
		
		override public function destroyComponent():void
		{
			if(aabbDebugShape!=null)
			{
				aabbDebugShape.alpha=0;
			}
			
		}
		
		
	
		
	}
	
}