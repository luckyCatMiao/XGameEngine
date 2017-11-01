package XGameEngine.Plugins.Box2DPlus.Rigidbody.Shape
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	
	import XGameEngine.Plugins.Box2DPlus.Util.CastTool;
	import XGameEngine.Constant.Error.UnSupportMethodError;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Math.Vector2;

	/**
	 *一条线段 
	 * @author Administrator
	 * 
	 */	
	public class LineShape extends AbstractShape
	{
		private var shape:b2PolygonShape;
		
		public function LineShape(v1:Vector2,v2:Vector2)
		{
			var vv1:b2Vec2=CastTool.castVector2ToB2Vec2(v1);
			vv1.x/=valueScale;
			vv1.y/=valueScale;
			
			var vv2:b2Vec2=CastTool.castVector2ToB2Vec2(v2);
			vv2.x/=valueScale;
			vv2.y/=valueScale;
			
			this.shape=b2PolygonShape.AsEdge(vv1,vv2);
			
			
		}
		
		override public function set rotation(value:Number):void
		{
			throw new UnSupportMethodError()
		}
		
		override public function set x(value:Number):void
		{
			throw new UnSupportMethodError()
			
		}
		
		override public function set y(value:Number):void
		{
			throw new UnSupportMethodError()
		}
		
		override public function getShape():b2Shape
		{
			// TODO Auto Generated method stub
			return shape;
		}
		
	
		
		
	}
}