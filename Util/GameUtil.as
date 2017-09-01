package XGameEngine.Util
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.GameObjectComponent.Anime.MovieClipAnimeGroup;
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.Structure.Math.Vector2;
	import XGameEngine.UI.Draw.Color;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.FileReference;
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
		
		
		
	
		
		/**
		 *创建一个简单的bitmap 
		 * @param param0
		 * @param param1
		 * @return 
		 * 
		 */		
		public static function createSimpleBitmap(width:int, height:int,color:Number=-1):Bitmap
		{
			if(color==-1)
			{
				color=Color.RED;
			}
			var data:BitmapData=new BitmapData(width,height,true,color);
			var bitmap:Bitmap=new Bitmap(data);
			
			
			return bitmap;
		}
		
		
		/**
		 *弹出保存文件对话框 
		 * @param data
		 * @param fileName
		 * 
		 */		
		public static function popUpSaveDialog(data:*, fileName:String):void
		{
			var file:FileReference = new FileReference();
			file.save(data, fileName);
			
		}
	}
	
}