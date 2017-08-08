package XGameEngine.UI.Widget.Button
{
	import flash.events.MouseEvent;

	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	public class ToggleButton extends BaseButton
	{
		
		/**
		 *开启状态 初始为关闭 
		 */		
		private var isOpen:Boolean=false;
		private var listener:Function;
		public function ToggleButton()
		{
			
			this.stop();
			//检查是不是有两帧 代表两种状态
			getCommonlyComponent().throwWhileNotTrue(this.totalFrames==2,"ToggleButton需要有两帧");
			
		}
		
		override protected function clickHandler(event:MouseEvent):void
		{
			isOpen=isOpen?false:true;
			this.gotoAndStop(isOpen?1:2);
			
			
			if(listener!=null)
			{
				listener(isOpen);
			}
		
		}
		
		/**
		 *添加监听器 
		 * @param fun
		 * 
		 */		
		protected function addToggleListener(fun:Function):void
		{
			this.listener=fun;
		}
		
		
		
		
		
	}
}