package XGameEngine.UI.Base
{
	import XGameEngine.GameObject.BaseDisplayObject;
	import XGameEngine.GameObject.BaseComponent.CommonlyComponent;
	import XGameEngine.GameObject.BaseComponent.FunComponent;
	import XGameEngine.GameObject.BaseComponent.GameObjectComponent;
	import XGameEngine.Math.Rect;
	import XGameEngine.UI.Draw.Color;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class BaseUI extends BaseDisplayObject
	{

		public function BaseUI()
		{
			
		}
		

		
		
		/**
		 *根据名字查找子级 
		 * @param name
		 * @param mustExist 是否必须存在 如果为true则查找失败的话报错  
		 * @return 
		 * 
		 */		
		protected function searchChild(name:String,mustExist:Boolean=true):DisplayObject
		{
			
			var o:DisplayObject=this.getChildByName(name);
			if(o==null&&mustExist)
			{
				throw new Error(name+"子级不存在")
			}
			else
			{
				return o;
			}
			
		}
		
		
		/**
		 *为指定对象创建一个简单的长方形遮罩对象 
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */		
		protected function createMask(target:DisplayObject):DisplayObject
		{
			
			var data:BitmapData=new BitmapData(target.width,target.height,true,Color.BLACK);
			var bitmap:Bitmap=new Bitmap(data);
			
			//需要将该bitmap再放入一个sprite中 应该需要让bitmap在本地坐标系中左下角对齐0,0点
			//默认是左上角对齐0,0点
			
			var sprite:Sprite=new Sprite();
			sprite.addChild(bitmap);
			addChild(sprite);
			bitmap.y=-bitmap.height;
			
			//对齐到左上角
			var rect:Rect=Rect.RectangleToRect(target.getRect(this));
			sprite.x=rect.x
			sprite.y=rect.y+target.height;

			
		
			return sprite;
		}		
	}
}