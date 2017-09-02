package XGameEngine.BaseObject.BaseComponent
{
	import XGameEngine.BaseObject.BaseDisplayObject;
	import XGameEngine.Constant.Error.ParamaterError;
	import XGameEngine.GameEngine;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.GameObjectComponent.Collider.Collider.RectCollider;
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.Structure.Math.Vector2;
	import XGameEngine.UI.Draw.Color;
	import XGameEngine.UI.Special.XDebugText;
	import XGameEngine.UI.Special.XTextField;
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
		
		/**
		 *最初被赋值的值(除(0,0)点之外) 
		 */		
		private var _oldWidth:Number=0;
		private var _oldHeight:Number=0;
		private var _oldScaleX:Number=0;
		private var _oldScaleY:Number=0;
		private var _oldaabb:Rect;
		private var _oldX:Number=0;
		private var _oldY:Number=0;
		
		
		
		
		private var aabbDebugShape:Shape;
		public var debugAABB:Boolean = false;

		
		private var posTextfield:XTextField;
		public var debugPosition:Boolean=false;
		private var host:BaseDisplayObject;
		
		
		
		public function TransformComponent(o:BaseDisplayObject)
		{
			this.host=o;
			
			
		}
		
		private function getOldValue():void
		{
			//这里是这样的 一个对象使用代码实例化之后 所有值全是零
			//这样这些old值就没有意义了 所以则不断循环 当对象实际具有值之后才赋值
			//如果是拖动到舞台上则一开始就有值
			if(host.height!=0&&host.width!=0&&_oldWidth==0&&_oldHeight==0)
			{
				
				_oldWidth = host.width;
				_oldHeight = host.height;
				_oldScaleX = host.scaleX;
				_oldScaleY = host.scaleY;
				_oldX=host.x;
				_oldY=host.y;
				_oldaabb=aabb;
			
			}
			
			
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
			
//			var r:Rectangle=host.getRect(host);
//			var point:Point=host.localToGlobal(new Point(r.x,r.y));
			
			var r:Rectangle=host.getRect(host.stage);
			
			return new Rect(r.x, r.y, r.width, r.height);
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
		 *全局aabb顶上y值
		 * @return 
		 * 
		 */		
		public function get globalTopY():Number
		{
			return globalAABB.y;
		}
		
		
		/**
		 *全局aabb底下y值
		 * @return 
		 * 
		 */		
		public function get globalBottomY():Number
		{
			return globalAABB.y+globalAABB.height;
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
			
			getOldValue();
			
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
				posTextfield.text = "X:" + host.globalPosition.x + "Y:" + host.globalPosition.y;
				posTextfield.x = host.globalPosition.x-posTextfield.textWidth/2;
				posTextfield.y = host.globalPosition.y - 30;
				
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
			
			
			
			return Vector2.getDistance(Vector2.pointToV2(point1),Vector2.pointToV2(point2));
		}
		
		/**
		 *设置在父级的中心位置 
		 * @param rectDecide 可以使用该对象求rect而不是用整个该对象
		 * (例如 对话框可能右侧有一个大大的人物头像 此时用对话框的背景框体用来居中而不是整个居中)
		 * 
		 */		
		public function setInParentCenter(rectDecide:DisplayObject=null,offest:Vector2=null):void
		{
			if(host.parent==null)
			{
				throw new ParamaterError();
			}
			
		
			
			var rect:Rectangle;
			if(rectDecide!=null)
			{
				rect=rectDecide.getRect(host.parent);
			}
			else
			{
				rect=host.getRect(host.parent);
			}
			
			var p:Vector2=new Vector2((host.parent.width-rect.width)/2,(host.parent.height-rect.height)/2);
			if(offest!=null)
			{
				p=p.add(offest);
			}
			
			host.x=p.x;
			host.y=p.y;
			
			
		}
	}
	
}