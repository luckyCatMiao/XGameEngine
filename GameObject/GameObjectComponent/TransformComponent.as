package XGameEngine.GameObject.GameObjectComponent
{
	import XGameEngine.GameEngine;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.GameObjectComponent.Collider.Collider.RectCollider;
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.Structure.Math.Vector2;
	import XGameEngine.UI.Draw.Color;
	import XGameEngine.UI.XDebugText;
	import XGameEngine.UI.XTextField;
	import XGameEngine.Util.MathTool;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 变换组件
	 * @author o
	 */
	public class TransformComponent extends BaseComponent
	{
		
		private var _oldWidth:Number;
		private var _oldHeight:Number;
		private var _oldScaleX:Number;
		private var _oldScaleY:Number;
		private var _oldaabb:Rect;
		private var _oldX:Number;
		private var _oldY:Number;
		
		
		
		
		private var aabbDebugShape:Shape;
		public var debugAABB:Boolean = false;

		
		private var posTextfield:XTextField;
		public var debugPosition:Boolean=false;
		
		
		
		public function TransformComponent(o:BaseGameObject)
		{
			super(o);
			
			//保存了一些原始数据
			_oldWidth = host.width;
			_oldHeight = host.height;
			_oldScaleX = host.scaleX;
			_oldScaleY = host.scaleY;
			_oldX=host.x;
			_oldY=host.y;
			_oldaabb=aabb;
		}
		
		
		public function get oldY():Number
		{
			return _oldY;
		}

		public function get oldX():Number
		{
			return _oldX;
		}

		public function get oldScaleY():Number
		{
			return _oldScaleY;
		}

		public function get oldScaleX():Number
		{
			return _oldScaleX;
		}

		public function get oldHeight():Number
		{
			return _oldHeight;
		}

		public function get oldWidth():Number
		{
			return _oldWidth;
		}

		/**
		 * 设置X轴朝向(不影响当前的缩放参数)
		 * @param	o
		 */
		public function setXDirection(d:Boolean)
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
		 * 计算出当前的包围框随着人物的动作占用空间可能会一直变化(特别是使用遮罩)
		 */
		public function get globalAABB():Rect 
		{
			
			var r:Rectangle=host.getRect(host);
			var point:Point=host.localToGlobal(new Point(r.x,r.y));
			
			return new Rect(point.x, point.y, r.width, r.height);
		}
		

		/**
		 *全局aabb左侧x值 
		 * @return 
		 * 
		 */		
		public function get globalLeftX():Number
		{
			return globalAABB.x;
		}
		
		
		/**
		 *全局aabb右侧x值 
		 * @return 
		 * 
		 */		
		public function get globalRightX():Number
		{
			return globalAABB.x+globalAABB.width;
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
			
			debug();
			
			
		}
		
		private function debug():void
		{
			DebugAABB();
			DebugPosition();
			
			
			
		}
		
		private function DebugPosition():void 
		{
			//如果需要debug 
			if (GameEngine.getInstance().debug&&debugPosition==true)
			{
				//如果当前没有初始化
				if (posTextfield == null)
				{
					posTextfield = new XDebugText();
				}
				
				//添加到host中
				if (posTextfield.parent == null)
				{
					//设置为最高深度
					host.stage.addChild(posTextfield);
				}
				
				//设置位置
				posTextfield.text = "X:" + host.centerGlobalPoint.x + "Y:" + host.centerGlobalPoint.y;
				posTextfield.x = host.centerGlobalPoint.x-posTextfield.textWidth/2;
				posTextfield.y = host.leftTopGlobalPoint.y - 30;
				
			}
				//不需要debug
			else if (GameEngine.getInstance().debug==false||debugPosition==false)
			{
				if (posTextfield!=null&&posTextfield.parent != null)
				{
					//设置为最高深度
					posTextfield.parent.removeChild(posTextfield);
				}
			}
			
			
			
		}
		
		
		
		/**
		 *debug包围框 
		 * @return 
		 * 
		 */		
		private function DebugAABB()
		{
			//如果需要debug 
			if (GameEngine.getInstance().debug&&debugAABB==true)
			{
				//如果当前没有初始化
				if (aabbDebugShape == null)
				{
					aabbDebugShape = new Shape();

				}

				//添加到host中
				if (aabbDebugShape.parent == null)
				{
					//设置为最高深度
					host.getGameObjectComponent().addChildToHighestDepth(aabbDebugShape);
				}
				
				//设置位置
				aabbDebugShape.graphics.clear();
				aabbDebugShape.graphics.lineStyle(2, Color.YELLOW, 0.7);
				aabbDebugShape.graphics.moveTo(aabb.getLeftTopPoint().x+3, aabb.getLeftTopPoint().y+3);
				aabbDebugShape.graphics.lineTo(aabb.getRightTopPoint().x-3, aabb.getRightTopPoint().y+3);
				aabbDebugShape.graphics.lineTo(aabb.getRightBottomPoint().x-3, aabb.getRightBottomPoint().y-3);
				aabbDebugShape.graphics.lineTo(aabb.getLeftBottomPoint().x+3, aabb.getLeftBottomPoint().y-3);
				aabbDebugShape.graphics.lineTo(aabb.getLeftTopPoint().x+3, aabb.getLeftTopPoint().y+3);
				
			}
				//不需要debug
			else if (GameEngine.getInstance().debug==false||debugAABB==false)
			{
				if (aabbDebugShape!=null&&aabbDebugShape.parent != null)
				{
					//设置为最高深度
					aabbDebugShape.parent.removeChild(aabbDebugShape);
				}
			}
				
		
		}
		
		
		
		override public function destroyComponent():void
		{
			if(aabbDebugShape!=null)
			{
				aabbDebugShape.alpha=0;
			}
			
		}
		
		
	
		/**
		 * 获取x轴朝向的正负(是原始方向的正方向还是负方向)
		 * @return 
		 * 
		 */		
		public  function getXDirection():Number
		{
			
			var value:Number=MathTool.getPVMSG(oldScaleX);
			
			return MathTool.isSameZF(value,host.scaleX);
		}
		
		
		/**
		 * 获取和其他物体全局坐标距离(距离使用零点来计算) 
		 * @param other
		 * @return 
		 * 
		 */		
		public function getGlobalDistance(other:DisplayObject):Number
		{
			var point1:Point=host.localToGlobal(Vector2.VEC2_ZERO.clone().toPoint());
			var point2:Point=other.localToGlobal(Vector2.VEC2_ZERO.clone().toPoint());
			
			
			
			return MathTool.getDistance(point1,point2);
		}
	}
	
}