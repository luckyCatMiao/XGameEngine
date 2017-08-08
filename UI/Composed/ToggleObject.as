package XGameEngine.UI.Composed
{
	import XGameEngine.UI.Base.BaseUI;
	import XGameEngine.UI.Widget.Button.ToggleButton;
	
	import flash.display.DisplayObject;

	/**
	 * 切换是否显示的组合控件 例如音量按钮加上音量条 
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