package XGameEngine.UI.Composed
{
	import XGameEngine.UI.Base.BaseUI;
	import XGameEngine.UI.Widget.Button.ToggleButton;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	/**
	 * 切换是否显示的组合控件 例如音量按钮加上音量条 
	 * 单击按钮会反复切换控件显示和不显示
	 * 同时单击除了按钮外的舞台任何地方都会使控件消失
	 * @author Administrator
	 * 
	 */	
	public class ToggleObject extends BaseUI
	{
		private var element_object:DisplayObject;
		private var element_button:ToggleButton;
		public function ToggleObject()
		{
			
			this.element_object=searchChild("object");
			this.element_button=searchChild("toggleButton") as ToggleButton;
			getCommonlyComponent().checkNull(element_button);

			
			element_button.addToggleListener(toggleChange);
			
			setObject(element_button.isOpen);
			
			
			//点击舞台上除该区域之外的所有区域都会隐藏掉控件
			//实现是这样的  先给舞台添加点击事件 隐藏掉该控件
			//然后再给按钮添加点击事件 取消掉事件冒泡
			stage.addEventListener(MouseEvent.CLICK,clickStage,false,0,true);
			element_button.addEventListener(MouseEvent.CLICK,clickButton,false,0,true);
		}
		
		protected function clickButton(event:MouseEvent):void
		{
			event.stopPropagation();
			
		}
		
		protected function clickStage(event:MouseEvent):void
		{
			
			element_object.visible=false;
			
		}
		
		private function toggleChange(b:Boolean):void
		{
			setObject(b);
		}			
		
		private function setObject(b:Boolean):void
		{
			if(b)
			{
				element_object.visible=true;
				
			}
			else
			{
				element_object.visible=false
			}
			
			
		}		
		
	}
}