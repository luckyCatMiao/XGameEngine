package XGameEngine.UI.Composed
{
	import XGameEngine.UI.Base.BaseUI;
	import XGameEngine.UI.Config.UIConfig;
	import XGameEngine.UI.Widget.ProgressBar;
	
	import flash.display.DisplayObject;

	/**
	 * ScorllPlane的升级版 有一个滑动条来进行滚动
	 * 
	 */	
	public class BarScorllPlane extends BaseUI
	{
		private var element_scrollPlane:ScorllPlane;
		private var element_scrollBar:ProgressBar;
		public function BarScorllPlane()
		{
			
			this.element_scrollPlane=searchChild("scrollPlane") as ScorllPlane;
			this.element_scrollBar=searchChild("scrollBar") as ProgressBar;
			
			
			element_scrollBar.setOnProgressListener(onProgressChange);
		}
		
		public function get plane():ScorllPlane
		{
			return element_scrollPlane;
		}

		private function onProgressChange(percent:Number):void
		{
			//如果是竖着的 这里percent要反转一下 因为竖着的最上面是100,底下是0
			//然后竖的拖动条一般顶上才是最开始的位置
			if(element_scrollBar.type==UIConfig.ORIENTATION_VERTICAL)
			{
				percent=100-percent;
			}
			
			
			element_scrollPlane.ScrollPercent(percent);
			
		}
	}
}