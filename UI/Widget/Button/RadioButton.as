package XGameEngine.UI.Widget.Button
{
	import flash.events.MouseEvent;

	/**
	 *单选按钮 
	 * @author Administrator
	 * 
	 */	
	public class RadioButton extends BaseButton
	{
		/**
		 *所属的按钮组 
		 */		
		public var group:RadioButtonGroup;
		
		public var isSelected:Boolean=false
		
		public function RadioButton()
		{
			
			this.stop();
			//检查是不是有两帧 代表两种状态
			getCommonlyComponent().throwWhileNotTrue(this.totalFrames==2,"RadioButton需要有两帧");
		}
		
		override protected function clickHandler(event:MouseEvent):void
		{
			setSelected(true);
		
		
		}
		
		public function setSelected(b:Boolean):void
		{
			if(b)
			{
				isSelected=true;
				this.gotoAndStop(2);
				if(group!=null)
				{
					group.setSelected(this);
				}
			}
			else
			{
				isSelected=false;
				this.gotoAndStop(1);
			}
			
		}		
		
		
		
		
	}
}