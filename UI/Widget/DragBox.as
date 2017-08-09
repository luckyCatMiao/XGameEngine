package XGameEngine.UI.Widget
{
	import XGameEngine.UI.Base.BaseUI;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 *一个可以触发拖动的对象  默认是拖动自己
	 * @author Administrator
	 * 
	 */	
	public class DragBox extends BaseUI
	{
		/**
		 *触发拖动的box 
		 */		
		private var element_dragBox:DisplayObject;
		
		
		/**
		 *拖动目标 默认为自身 也可以设置为其他对象
		 */		
		private var dragTarget:Sprite;
		
		public function DragBox()
		{
			this.element_dragBox=searchChild("dragBox");

			element_dragBox.alpha = 0;
			
			//添加拖拽侦听
			this.element_dragBox.addEventListener(MouseEvent.MOUSE_DOWN, dragStop, false, 0, true);
			this.element_dragBox.addEventListener(MouseEvent.MOUSE_UP, dragStart, false, 0, true);
		
			dragTarget=this;
		
		}
		
		
		protected function dragStop(event:Event):void
		{
			dragTarget.startDrag();
			
		}
		
		protected function dragStart(event:Event):void
		{
			dragTarget.stopDrag();
			
		}
		
		public function setTarget(o:Sprite)
		{
			dragTarget=o;
		}
		
		
	}
}