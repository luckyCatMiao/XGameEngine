package XGameEngine.UI.Widget.Button
{
	import XGameEngine.UI.Base.BaseUI;
	
	import flash.events.MouseEvent;

	public class BaseButton extends BaseUI
	{
		public function BaseButton()
		{
			
			
			this.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
	}
}