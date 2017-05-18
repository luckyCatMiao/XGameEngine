package XGameEngine.GameObject.Component
{
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
	 * @author o
	 */
	public class CollideComponent extends BaseComponent
	{
		
		
		public function CollideComponent(o:BaseGameObject)
		{
			super(o);
		}
		
		
		
		private var c:Collider;
		
		public function generateRectCollider(width:uint,height:uint,color:uint,x:Number,y:Number)
		{

			
			if (c != null)
			{
				throw new Error("one gameobject only can have one collider!please reset collider before generet another");
			}
			var collider:RectCollider = new RectCollider(width,height,color);

			
			host.getGameObjectComponent().addChildToHighestDepth(collider);
			c = collider;
			
			collider.x = x;
			collider.y = y;
		}
		
		
		public function generateRectColliderDefault()
		{
			var rect:Rectangle = host.getRect(host);
			generateRectCollider(host.width, host.height, Color.RED, rect.x, rect.y);
			
		}
		
		public function setCollider(a:Sprite)
		{
			a.alpha = 0;
			generateRectCollider(a.width, a.height, Color.RED, a.x, a.y);
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
		
		
	}
	
}