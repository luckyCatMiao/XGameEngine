package XGameEngine.UI.Widget.Button
{
	import XGameEngine.Structure.List;

	/**
	 *按钮组 几个单选按钮想起到效果必须分在同一个组中 
	 * 或者添加别的按钮 方便一起操作
	 * @author Administrator
	 * 
	 */	
	public class RadioButtonGroup
	{
		private var list:List;
		private var listener:Function;
		public function RadioButtonGroup()
		{
			this.list=new List();
		}
		
		/**
		 *设置某个按钮为选中 其他按钮全都未选中 
		 * @param param0
		 * 
		 */		
		public function setSelected(button:RadioButton):void
		{
			if(!list.contains(button))
			{
				throw new Error("按钮组中不包括此按钮");
			}
			
			for each(var b:RadioButton in list.Raw)
			{
				if(b!=button)
				{
					b.setSelected(false);
				}
			}
			
			
			if(listener!=null)
			{
				listener(button);
			}
		
		}
		
		public function setOnSelectedListener(l:Function)
		{
			this.listener=l;
		}
		
		public function addButton(r:RadioButton)
		{
			list.add(r);
			r.group=this;
		}
	}
}