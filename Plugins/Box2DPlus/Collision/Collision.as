package XGameEngine.Plugins.Box2DPlus.Collision
{
	import Box2D.Common.Math.b2Vec2;
	
	import XGameEngine.Plugins.Box2DPlus.Rigidbody.Rigidbody;
	import XGameEngine.Collections.List;
	import XGameEngine.Math.Vector2;
	import XGameEngine.Collections.Vector2List;

	/**
	 *对box2D的碰撞信息进行重新包装 
	 * @author Administrator
	 * 
	 */	
	public class Collision
	{
		/**
		 *碰撞对象 
		 */		
		public var hitObject:Rigidbody;
		/**
		 *发生碰撞点的垂直向量 
		 */		
		public var normal:Vector2;
		/**
		 *碰撞点组 
		 */		
		public var points:Vector2List;
		/**
		 *是否接触 
		 */		
		public var isTouch:Boolean;
		public function Collision()
		{
		}
	}
}