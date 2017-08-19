package XGameEngine.Advanced.Box2DPlus.Util
{
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.Structure.Math.Vector2;

	public class CastTool
	{
		public function CastTool()
		{
		}
		
		/**
		 *转换 
		 * @param v2
		 * @return 
		 * 
		 */		
		public static function castVector2ToB2Vec2(v2:Vector2):b2Vec2
		{
			
			return new b2Vec2(v2.x,v2.y);
		}
		
		
		/**
		 *转换 
		 * @param v2
		 * @return 
		 * 
		 */		
		public static function castB2Vec2ToVector2(v2:b2Vec2):Vector2
		{
			
			return new Vector2(v2.x,v2.y);
		}
		
		
		public static function castAABBToRect(aabb:b2AABB):Rect
		{
			var x:Number=aabb.lowerBound.x;
			var y:Number=aabb.lowerBound.y;
			
			var width:Number=aabb.upperBound.x-x;
			var height:Number=aabb.upperBound.y-y;
			
			return new Rect(x,y,width,height);
		}
	}
}