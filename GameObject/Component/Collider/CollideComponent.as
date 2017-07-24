package XGameEngine.GameObject.Component.Collider
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.Manager.Hit.Collision;
	import XGameEngine.Manager.HitManager;
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.UI.Draw.Color;
	import XGameEngine.Util.MathTool;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import XGameEngine.GameObject.Component.BaseComponent;

	/**
	 * ...
	 * 碰撞器组件
	 */
	public class CollideComponent extends BaseComponent
	{
		
		
		//碰撞器类型
		//多边形碰撞器
		 static  public const  COLLIDER_TYPE_MESH:String = "mesh";
		//方形碰撞器
		  static  public const  COLLIDER_TYPE_RECT:String = "rect";
		//点碰撞器
		 static  public const  COLLIDER_TYPE_CIRCLE:String = "circle";
		
		
		
		
		
		/**
		 * 是否debug碰撞器
		 */
		public var debugCollider:Boolean = false;
		
		public function CollideComponent(o:BaseGameObject)
		{
			super(o);
			host.addLoopFun(this.loop);
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
		 *根据自动计算的aabb包围盒生成一个方形碰撞器  
		 * @param scale 缩放 默认大小是刚好包裹
		 * @return 
		 * 
		 */
		public function generateRectColliderDefault(scaleX:Number=1,scaleY:Number=1)
		{
			var rect:Rectangle = host.getRect(host);
			var x:Number=rect.x+(1-scaleX)*rect.width/2;
			var y:Number=rect.y+(1-scaleY)*rect.height/2;
			var width:Number=rect.width*scaleX;
			var height:Number=rect.height*scaleY;
			
			generateRectCollider(width, height, Color.RED,x , y);
			
		}

		
		/**
		 * 生成一个空的网格碰撞器
		 */
		public function generateMeshCollider()
		{
			//如果当前碰撞器不为空
			if (c != null)
			{
				throw new Error("one gameobject only can have one collider!please reset collider before generet another");
			}
			
			var rect:Rectangle = host.getRect(host);
			
			c = new MeshCollider();
			host.getGameObjectComponent().addChildToHighestDepth(c);
			c.x = rect.x;
			c.y = rect.y;
		
		}	
			

		
		/**
		 * 直接设置一个子级为碰撞器
		 * @param	a
		 * @param   type 碰撞器类型
		 */
		public function setCollider(a:Sprite,type:String=COLLIDER_TYPE_RECT)
		{
			//如果已经有碰撞器就报错
			getCommonlyComponent().throwWhileTrue(c != null, "the collider has existed,please call the reset before set the new collider.");
			
			
			//如果a不是子物体则报错
			getCommonlyComponent().throwWhileTrue(host.getGameObjectComponent().hasChild(a) == false, "the params is not a child Object of the gameobject");
			
			
			
			//转换a里面唯一子物体从a坐标系到host坐标系
			//其中a的唯一子物体必须是shape类型 即代表碰撞区的只能是一些色块
			if (a.getChildAt(0) as Shape == null)
			{
				throw new Error("the hitbox can only be Shape type!");
			}
	
			
			//生成方碰撞
			if (type==COLLIDER_TYPE_RECT)
			{
				//方形碰撞是根据给定的形状重新绘制的,所以把原sprite透明度设置为0
				a.alpha = 0;
				//变换坐标系
			var s:Shape = a.getChildAt(0) as Shape;
			var r:Rectangle = s.getRect(s);
			
			var p1:Point = new Point(r.x, r.y);
		
			p1 = s.localToGlobal(p1);
			p1 = host.globalToLocal(p1);
			
			//trace(p1);
			generateRectCollider(a.width, a.height, Color.RED,p1.x, p1.y);
			}
			else if(type==COLLIDER_TYPE_MESH)
			{
				//生成不规则碰撞器
			var mesh:MeshCollider = new MeshCollider(a);
			c = mesh;
			host.getGameObjectComponent().addChildToHighestDepth(mesh);
			
			}
			
			
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
		 * 试图返回网格碰撞器
		 */
		public function get meshCollider():MeshCollider 
		{
			getCommonlyComponent().throwWhileNotTrue(c is MeshCollider, "the collider is not a meshCollider");
			
			return c as MeshCollider;
					
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
		 * 根据碰撞点返回名字 这样可以知道碰撞的是哪个点,只适用于碰撞器是方形碰撞器
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
		
		
		/**
		 * 由host调用
		 */
		private function loop():void 
		{
			if (collider != null)
			{
				collider.debug = this.debugCollider;
				collider.debugShape();
			}
		}
		
		
	}
	
}