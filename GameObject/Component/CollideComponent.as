package XGameEngine.GameObject.Component
{
	import flash.display.Shape;
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.Util.MathTool;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import XGameEngine.Manager.Hit.Collision;
	import XGameEngine.UI.Draw.Color;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.Component.Collider.*;
	import XGameEngine.Manager.HitManager;
	/**
	 * ...
	 * 碰撞器组件
	 */
	public class CollideComponent extends BaseComponent
	{
		
		
		/**
		 * 是否debug碰撞器
		 */
		public var debugCollider:Boolean = false;
		
		public function CollideComponent(o:BaseGameObject)
		{
			super(o);
		}
		
		
		
		private var c:Collider;
		
		/**
		 * 生成方形的碰撞器
		 * @param	width
		 * @param	height
		 * @param	color
		 * @param	x
		 * @param	y
		 */
		public function generateRectCollider(width:uint,height:uint,color:uint,x:Number,y:Number)
		{

			//如果当前碰撞器不为空
			if (c != null)
			{
				throw new Error("one gameobject only can have one collider!please reset collider before generet another");
			}
			//根据rect创建一个方形碰撞器
			var collider:RectCollider = new RectCollider(width,height,color);

			//添加到最高层
			host.getGameObjectComponent().addChildToHighestDepth(collider);
			c = collider;
			
			collider.x = x;
			collider.y = y;
		}
		
		
		/**
		 * 根据自动计算的aabb包围盒生成一个方形碰撞器
		 */
		public function generateRectColliderDefault()
		{
			var rect:Rectangle = host.getRect(host);
			generateRectCollider(host.width, host.height, Color.RED, rect.x, rect.y);
			
		}

		
		/**
		 * 直接设置一个子级为碰撞器
		 * @param	a
		 */
		public function setCollider(a:Sprite)
		{
			//如果a不是子物体则报错
			getCommonlyComponent().throwWhileTrue(host.getGameObjectComponent().hasChild(a) == false, "the params is not a child Object of the gameobject");
			
			a.alpha = 0;
			
			//转换a里面唯一子物体从a坐标系到host坐标系
			//其中a的唯一子物体必须是shape类型 即代表碰撞区的只能是一些色块
			if (a.getChildAt(0) as Shape == null)
			{
				throw new Error("the hitbox can only be Shape type!");
			}
	
			//变换坐标系
			var s:Shape = a.getChildAt(0) as Shape;
			var r:Rectangle = s.getRect(s);
			
			var p1:Point = new Point(r.x, r.y);
		
			p1 = s.localToGlobal(p1);
			p1 = host.globalToLocal(p1);
			
			//trace(p1);
			generateRectCollider(a.width, a.height, Color.RED,p1.x, p1.y);
		}
		
	
		public function hasCollider()
		{
			return c != null;
		}
		
		public function reset()
		{
			host.removeChild(c);
			c = null;
		}
		
		public function get collider():Collider 
		{
			return c;
		}
		
		/**
		 * 试图返回方形碰撞器 因为方形有许多额外特性 所以这里单独列出来(按经验来说99%的人物都使用方形碰撞器)
		 */
		public function get rectCollider():RectCollider 
		{
			var q:RectCollider = c as RectCollider;
			if (q != null)
			{
				return q;
			}
			else
			{
				throw new Error("the collider is not a rectCollider or even the collider don't exist")
			}
			
		}
		
	
		
		/**
		 * 施加一个碰撞
		 * @param	hit
		 */
		public function applyCollision(hit:Collision)
		{
			
			if (hit.state ==HitManager.COLLISION_ENTER)
			{
				host.onHitEnter(hit);
			}
			else if (hit.state == HitManager.COLLISION_ING)
			{
				host.onHitStay(hit);
			}
			else if (hit.state == HitManager.COLLISION_EXIT)
			{
				host.onHitExit(hit);
			}
		}
		
		
		/**
		 * 根据碰撞点返回名字 这样可以知道碰撞的是哪个点
		 * @param	hit
		 */
		public function getRectColliderHitPoint(hit:Point):String
		{
			var co:RectCollider = collider as RectCollider;
			if (co == null)
			{
				throw new Error("the function only apply to rectCollider");
			}
			
			
			if (hit.equals(co.getLeftPoint()))
			{
				return RectCollider.POINT_LEFT;
			}
			else if (hit.equals(co.getRightPoint()))
			{
				return RectCollider.POINT_RIGHT;
			}
			else if (hit.equals(co.getDownPoint()))
			{
				return RectCollider.POINT_DOWN;
			}
			else if (hit.equals(co.getTopPoint()))
			{
				return RectCollider.POINT_UP;
			}
			else
			{
				throw new Error("no point find!");
			}
		}
		
		public function loop():void 
		{
			if (collider != null)
			{
				collider.debug = this.debugCollider;
				collider.debugShape();
			}
		}
		
		
	}
	
}