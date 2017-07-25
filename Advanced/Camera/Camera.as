package XGameEngine.Advanced.Camera
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.Structure.Math.Rect;

	public class Camera extends BaseGameObject
	{
		
		
		private var showObj:DisplayObject;
		private var showRect:Rect;
		private var pos:Rect;
		
		private var b:Bitmap;
		
		/**
		 * 需要显示的对象   显示的舞台范围    摄像机本身的范围
		 */
		public function Camera(o:DisplayObject,r:Rect,r2:Rect)
		{
			this.showObj=o;
			this.showRect=r;
			this.pos=r2;
			
			b=new Bitmap();
			addChild(b);
			
			
			
		}
		
		protected override function loop()
		{
			
			var data:BitmapData=new BitmapData(showRect.width,showRect.height);
			
			var m:Matrix=new Matrix();
			m.translate(-showRect.x,-showRect.y);
			data.draw(showObj,m);
			
			b.bitmapData=data;
			b.x=pos.x;
			b.y=pos.y;
			b.width=pos.width;
			b.height=pos.height;
			
			
			
			
		}
	}
}