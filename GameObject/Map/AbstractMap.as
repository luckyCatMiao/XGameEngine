package XGameEngine.GameObject.Map
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.Math.Vector2;

	
	/**
	 *	地图接口 
	 * @author Administrator
	 * 
	 */	
	public class AbstractMap extends BaseGameObject
	{
		
		
		public function move(x:Number,y:Number):Vector2
		{
			throw new Error("abstract Method");
		}
		
		public function canMove(x:Number,y:Number):Boolean
		{
			throw new Error("abstract Method");
		}
		
	}
}