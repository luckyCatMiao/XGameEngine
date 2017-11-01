package XGameEngine.UI.Widget
{
	import XGameEngine.Math.Rect;
	import XGameEngine.UI.Base.BaseUI;
	import XGameEngine.UI.Config.UIConfig;
	import XGameEngine.UI.Draw.Color;
	import XGameEngine.Math.MathTool;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	/**
	 *进度条 除底板必须存在外 滑块和条都可以没有 
	 * @author Administrator
	 * 
	 */	
	public class ProgressBar extends BaseUI
	{
		
		
		
		/**
		 *子元素 
		 */		
		protected var element_bar:DisplayObject;
		protected var element_back:DisplayObject;
		protected var element_mask:DisplayObject;
		private var element_dragBox:DisplayObject;
		
		/**
		 *横着还是竖着 
		 */		
		public var type:String;
		
		/**
		 *遮罩的初始长宽 
		 */		
		protected var maskStartHeight:Number;
		protected var maskStartWidth:Number;
		/**
		 *进度值 (0-100)
		 */		
		protected var value:Number;
		
		
		/**
		 *回调监听 
		 */		
		private var listener:Function;
		
		/**
		 *是否在拖动中 
		 */		
		private var isDrag:Boolean = false;
		
		
		/**
		 *进度条 需要条和底盘 
		 */		
		public function ProgressBar()
		{
			
			
		}
		
		override protected function Init():void
		{
			this.element_back=searchChild("back");
			this.element_bar=searchChild("bar",false);
			this.element_dragBox=searchChild("drag",false);
			
			
			//创建遮罩
			if(element_bar!=null)
			{
				setMask();
			}
			
			
			//根据宽高判断类型
			checkType();
			
			
			if(element_dragBox!=null)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN,startMoveDragBox);
				stage.addEventListener(MouseEvent.MOUSE_UP,endMoveDragBox);
			}
			
			
			SetValue(100);
		}
		
		
		override protected function loop():void
		{
			var percent:Number;
			
			var rect:Rect=getBarRect();
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
		
		
		protected function endMoveDragBox(event:MouseEvent):void
		{
			isDrag=false;
			
		}
		
		protected function startMoveDragBox(event:MouseEvent):void
		{
			isDrag=true;
			
			
		}		
		
	
		
		
		private function setMask():void
		{
			this.element_mask=createMask(element_bar);
			element_bar.mask=element_mask;
			
			maskStartHeight=element_mask.height;
			maskStartWidth=element_mask.width;
			
		}
		
		private function checkType():void
		{
		
			if(element_back.width>element_back.height)
			{
				type=UIConfig.ORIENTATION_HORIZONTAL;
			}
			else
			{
				type=UIConfig.ORIENTATION_VERTICAL;
			}
			
		}		
		
		
		/**
		 *设置进度条的值 是一个0-100之间的数 
		 * @param value
		 * @return 
		 * 
		 */		
		public function SetValue(value:Number)
		{
			if(element_bar!=null)
			{
				setBarValue(value);
			}
			if(element_dragBox!=null)
			{
				setDragBoxValue(value);
			}
			
		}
		
		
		/**
		 *根据百分比设置滑块的位置 
		 * @param percent
		 * 
		 */		
		private function setDragBoxValue(percent:Number):void
		{
			var barRect:Rect=getBarRect();
		
			
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
		 *获取作为计算参照的条 因为进度条可能不存在 所以在这种情况下rect根据底板计算 
		 * @return 
		 * 
		 */		
		private function getBarRect():Rect
		{
			
			var barRect:Rect;
			//因为有可能没有条只有底板 所以没有条的情况下rect为底板
			if(element_bar!=null)
			{
				barRect=Rect.RectangleToRect(element_bar.getRect(this));
			}
			else
			{
				barRect=Rect.RectangleToRect(element_back.getRect(this));	
			}
			return barRect;
		}		
		
		
		private function setBarValue(value:Number):void
		{
			
			this.value = value;
			
			MathTool.checkRange(value,0,100);
			
			
			switch (this.type)
			{
				case UIConfig.ORIENTATION_HORIZONTAL:
					this.element_mask.width = maskStartWidth * value / 100;
					break;
				case UIConfig.ORIENTATION_VERTICAL:
					this.element_mask.height = maskStartHeight * value / 100;
					break;
				
			}
			
		}		
		
		
		/**
		 *添加回调监听 
		 * @param fun
		 * @return 
		 * 
		 */		
		public function setOnProgressListener(fun:Function)
		{
			this.listener=fun;
			
		}
		
		
	
	}
}