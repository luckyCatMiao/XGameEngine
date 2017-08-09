package XGameEngine.UI.Composed.Window
{
	import XGameEngine.UI.Base.BaseUI;
	import XGameEngine.UI.Widget.DragBox;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 基础的窗口 可以设置拖动 关闭 
	 * @author Administrator
	 * 
	 */	
	public class BaseWindow extends BaseUI
	{
		private var element_dragBox:DragBox;
		private var element_exitButton:DisplayObject;
		
		
		public function BaseWindow()
		{
			this.element_dragBox=searchChild("dragBox",false) as DragBox;
			this.element_exitButton=searchChild("exitButton",false);
			
			
			if(element_dragBox!=null)
			{
				initDragBox();
			}
			
			if(element_exitButton!=null)
			{
				initExitButton();
				
			}
		}
		
		private function initExitButton():void
		{
			element_exitButton.addEventListener(MouseEvent.CLICK,clickExit);
			
		}
		
		protected function clickExit(event:Event):void
		{
			close();
			
		}
		
		private function initDragBox():void
		{
			//设置拖动对象为窗口
			element_dragBox.setTarget(this);
			
		}		
		
		
	
		
		/**
		 *使窗口再次显示 
		 * @return 
		 * 
		 */		
		public function open()
		{
			this.visible=true;
		}
		
		
		/**
		 *这里的close其实只是使窗口不可见 
		 * @return 
		 * 
		 */		
		public function close()
		{
			
			this.visible=false;
		}
	}
}