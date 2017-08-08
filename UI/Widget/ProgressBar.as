package XGameEngine.UI.Widget
{
	import XGameEngine.UI.Base.BaseUI;
	import XGameEngine.UI.Draw.Color;
	import XGameEngine.Util.MathTool;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;

	public class ProgressBar extends BaseUI
	{
		
		/**
		 *进度条类型 
		 */		
		static public var TYPE_HORIZONTAL:String="horizontal";
		static public var TYPE_VERTICAL:String="vertical";
		
		
		/**
		 *子元素 
		 */		
		protected var element_bar:DisplayObject;
		protected var element_back:DisplayObject;
		protected var element_mask:DisplayObject;
		
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
		 *进度条 需要条和底盘 
		 */		
		public function ProgressBar()
		{
			
			
		}
		
		override protected function Init():void
		{
			this.element_back=searchChild("back");
			this.element_bar=searchChild("bar");
			
			//创建遮罩
			setMask();
			
			//根据宽高判断类型
			checkType();
			
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
		
			if(element_bar.width>element_bar.height)
			{
				type=TYPE_HORIZONTAL;
			}
			else
			{
				type=TYPE_VERTICAL;
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
			this.value = value;
			
			MathTool.checkRange(value,0,100);
			
			
			switch (this.type)
			{
				case TYPE_HORIZONTAL:
					this.element_mask.width = maskStartWidth * value / 100;
					break;
				case TYPE_VERTICAL:
					this.element_mask.height = maskStartHeight * value / 100;
					break;
				
			}
		}
		
		
		
		
		
		
	
	}
}