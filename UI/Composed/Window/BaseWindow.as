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
		private var openListener:Function;
		private var closeListener:Function;
		
		
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
		
		
		public function addOpenListener(f:Function)
		{
			this.openListener=f;
		}
	
		public function addCloseListener(f:Function)
		{
			this.closeListener=f;
		}
		
		/**
		 *使窗口再次显示 
		 * @return 
		 * 
		 */		
		public function open()
		{
			
			if(openListener!=null)
			{
				openListener();
			}
			this.visible=true;
		}
		
		
		/**
		 *这里的close其实只是使窗口不可见 
		 * @return 
		 * 
		 */		
		public function close()
		{
			if(closeListener!=null)
			{
				closeListener();
			}
			this.visible=false;
		}
		
		
		public function isOpen():Boolean
		{
			return this.visible==true
		}
		
	}
}