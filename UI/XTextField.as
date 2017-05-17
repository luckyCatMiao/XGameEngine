package XGameEngine.UI
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import XGameEngine.Structure.Map;
	
	/**
	 * ...
	 * @author o
	 */
	public class XTextField extends TextField
	{
		private var _extraValue:Map = new Map();
		
		public function getExtraValue():Map 
		{
			return _extraValue;
		}
		
		public function set size(s:int)
		{
			var mytf:TextFormat=new TextFormat();
			mytf.size = s;
			this.setTextFormat(mytf);
		}
	
		public function get size():int
		{
			
			return this.getTextFormat().size as int;
		}
		
		
	}
	
}