package XGameEngine.Util
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.GameObjectComponent.Anime.Animation;
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.Structure.Math.Vector2;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;

	/**
	 * ...
	 * @author o
	 */
	public class GameUtil 
	{
		/**
		 * 转换当前坐标系内某点到另一个对象坐标系的中  
		 * @param o1Point 对象o1内的点
		 * @param o1 对象o1
		 * @param o2 对象o2
		 * @return 
		 * 
		 */		
		static public function localToOtherLocal(o1Point:Point,o1:DisplayObject,o2:DisplayObject):Vector2
		{
			//先转转到全局
			var globalPoint:Point=o1.localToGlobal(o1Point);
			//全局再转换到局部
			var localPoint:Point=o2.globalToLocal(globalPoint);
			
			
			return new Vector2(localPoint.x,localPoint.y);
		}
		
		
		
	
	}
	
}