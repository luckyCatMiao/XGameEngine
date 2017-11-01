package XGameEngine.Plugins.Box2DPlus.Rigidbody.Shape
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	
	import XGameEngine.Constant.Error.UnSupportMethodError;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Math.Vector2;
	
	import flash.geom.Point;

	public class PolygonShape extends AbstractShape
	{
		private var shape:b2PolygonShape;
		
	
		public function PolygonShape(list:List)
		{
			
		var realArr:Array=new Array();	
			
		for(var i:int=0;i<list.size;i++)
		{
			if(!(list.get(i) is Vector2))
			{
				throw new Error("list元素必须是Vector2类型");
			}
			var a:Vector2=list.get(i) as Vector2;
			
			var v:b2Vec2=new b2Vec2(a.x/valueScale,a.y/valueScale);
			realArr.push(v);
		}
			
	
			
		this.shape=b2PolygonShape.AsArray(realArr,realArr.length);	
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