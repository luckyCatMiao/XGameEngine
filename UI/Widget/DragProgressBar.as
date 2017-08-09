package XGameEngine.UI.Widget
{
	import XGameEngine.Structure.Math.Rect;
	import XGameEngine.UI.Base.BaseUI;
	import XGameEngine.UI.Config.UIConfig;
	import XGameEngine.Util.GameUtil;
	import XGameEngine.Util.MathTool;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 可以拖动的进度条
	 */	
	public class DragProgressBar extends ProgressBar
	{
		private var listener:Function;
		
		
		private var element_dragBox:DisplayObject;
		
		
		/**
		 *是否在拖动中 
		 */		
		private var isDrag:Boolean = false;
	
		
		public function DragProgressBar()
		{

				
		}
		
		override protected function Init():void
		{
			
			super.Init();
			
			
			//初始化滑块
			initDragBox();
			
			
			
			//这里注意一下 添加的点击侦听并不是在滑块而是在整个条上,这样点击条上的任意一个位置 滑块都会自动设置到那个位置
			//否则只能先选中滑块才拖动 交互不太好 
			this.addEventListener(MouseEvent.MOUSE_DOWN,startMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,endMove);
			
			SetValue(100);
			
			
		}
		
		private function initDragBox():void
		{
			this.element_dragBox=searchChild("drag");
		
			
			
		}		
		
		
		
		protected function endMove(event:MouseEvent):void
		{
			isDrag=false;
			
		}
		
		protected function startMove(event:Event):void
		{
			isDrag=true;

		
		}		
		
		override protected function loop():void
		{
			var percent:Number;
			
			var rect:Rect=Rect.RectangleToRect(element_bar.getRect(this));
			if(isDrag)
			{
				//计算鼠标位置的百分比
				if (type == UIConfig.ORIENTATION_HORIZONTAL)
				{
					
					var leftX:Number=rect.x;
					percent=MathTool.restrictRange((mouseX - leftX) / rect.width * 100,0,100)
				
				
				}
				else if(type==UIConfig.ORIENTATION_VERTICAL)
				{
					var bottomY:Number=rect.getBottomY();
					percent=MathTool.restrictRange(-(mouseY - bottomY) / rect.height * 100,0,100)
				}
				
				
				SetValue(percent);
				if(this.listener!=null)
				{
					listener(percent);
				}
			}
				
		}
		
		override public function SetValue(percent:Number)
		{
			// TODO Auto Generated method stub
			 super.SetValue(percent);
			 setDragBoxPosition(percent);
		}
		
		/**
		 *根据百分比设置滑块的位置 
		 * @param percent
		 * 
		 */		
		private function setDragBoxPosition(percent:Number):void
		{
			
			var barRect:Rect=Rect.RectangleToRect(element_bar.getRect(this));
			var dragboxRect:Rect=Rect.RectangleToRect(element_dragBox.getRect(this));
			
			
			if(type==UIConfig.ORIENTATION_HORIZONTAL)
			{
				//计算bar百分比位置和dragbox中间x的差值 然后设置
				element_dragBox.x-=(dragboxRect.getCenterX()-(barRect.x+barRect.width*percent/100));
				//计算bar和dragbox中间y的差值 然后设置
				element_dragBox.y-=(dragboxRect.getCenterY()-barRect.getCenterY());
			}
			else if(type==UIConfig.ORIENTATION_VERTICAL)
			{
				//计算bar百分比位置和dragbox中间x的差值 然后设置
				element_dragBox.x-=(dragboxRect.getCenterX()-barRect.getCenterX());
				//计算bar和dragbox中间y的差值 然后设置
				element_dragBox.y-=(dragboxRect.getCenterY()-(barRect.y+barRect.height-barRect.height*percent/100));
			}
		
			
		}		
		
		
		
		
		/**
		 *添加回调监听 
		 * @param fun
		 * @return 
		 * 
		 */		
		public function addProgressListener(fun:Function)
		{
			this.listener=fun;
			
		}
	}
}