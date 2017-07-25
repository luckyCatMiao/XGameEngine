package XGameEngine.UI
{
	import XGameEngine.UI.Draw.Color;
	
	import flash.text.TextFieldAutoSize;

	/**
	 *debug使用的 
	 * @author Administrator
	 * 
	 */	
	public class XDebugText extends XTextField
	{
		public function XDebugText()
		{
			this.size = 20;
			this.textColor = Color.BLACK;
			
			this.autoSize = TextFieldAutoSize.CENTER;	
		}
	}
}