package XGameEngine.UI.Base
{
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.UI.Draw.Color;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class BaseUI extends Sprite
	{
		public function BaseUI()
		{
			//初始化组件
			InitComponent();
			InitEvent();
			
		}
		
		private function InitEvent():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addTo, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME,loop);
			
		}
		
		protected function addTo(event:Event):void
		{
			Init();
			
		}
		
		protected function Init():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function InitComponent():void
		{
			// TODO Auto Generated method stub
			
		}
		
		protected function loop(event:Event):void
		{
			_loop();
			
		}		
		
		protected function _loop():void
		{
			// TODO Auto Generated method stub
			
		}		
		
		/**
		 *根据名字查找子级 查找失败的话报错 
		 * @param name
		 * @return 
		 * 
		 */		
		protected function searchChild(name:String):DisplayObject
		{
			
			var o:DisplayObject=this.getChildByName(name);
			if(o==null)
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