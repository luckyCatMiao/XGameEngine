package XGameEngine.UI.Special
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import XGameEngine.Collections.Map;
	
	/**
	 * ...
	 * @author o
	 */
	public class XTextField extends TextField
	{
		private var _extraValue:Map = new Map();
		private var _size:Number=20;
		
		public function getExtraValue():Map 
		{
			return _extraValue;
		}
		
		public function set size(s:int)
		{
			var mytf:TextFormat=new TextFormat();
			mytf.size = s;
			this.setTextFormat(mytf);
			_size = s;
		}
	
		public function get size():int
		{
			
			return this.getTextFormat().size as int;
		}
		
		
		public function setText(s:String)
		{
			//这个文本框居然要每次设定文字的时候重新设定一遍格式?什么鬼控件,看来自己重写还是有好处
			text = s;
			size=_size
		
		}
		
	}
	
}