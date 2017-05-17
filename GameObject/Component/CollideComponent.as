package XGameEngine.GameObject.Component
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import XGameEngine.UI.Draw.Color;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.Component.Collider.*;
	
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

			
			host.addChild(collider);
			c = collider;
			
			collider.x = x;
			collider.y = y;
		}
		
		
		public function generateRectColliderDefault()
		{
			var rect:Rectangle = host.getRect(host);
			generateRectCollider(host.width,host.height,Color.RED,rect.x,rect.y);
		}
		
		public function setCollider(a:Sprite)
		{
			a.alpha = 0;
			generateRectCollider(a.width, a.height, Color.RED, a.x, a.y);
		}
		
		
		public function reset()
		{
			host.removeChild(c);
			c = null;
		}
		
	}
	
}