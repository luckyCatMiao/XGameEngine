package XGameEngine.Util
{
	import XGameEngine.Collections.Map;
	
	/**
	 * ...
	 * @author o
	 */
	public class StringUtil 
	{
		/**
		 * 格式化键值对
		 * @param	o
		 * @param	link
		 * @param	prefix
		 * @param	suffix
		 * @return
		 */
		public static function formatMap(o:Object,link:String="=",prefix:String="[",suffix:String="]"):String
		{
			var v:String = "";
			for (var key:String in o)
			{
				var line:String = key + link + o[key];
				v += line;
			}
			
			return formatString(v,prefix,suffix);
		}
		
		/**
		 * 格式化值
		 * @param	o
		 * @param	link
		 * @param	"
		 * @param	prefix
		 * @param	suffix
		 * @return
		 */
		public static function formatValue(o:Map,link:String=",",prefix:String="[",suffix:String="]"):String
		{
			var v:String = "";
			
			var nowSize:int = 0;
			for (var key:String in o.rawData)
			{
				nowSize++;
				var line:String = o.get(key).toString();
				if (nowSize != o.size)
				{
					line+= link;
				}
				v += line;
			}
			
			return formatString(v,prefix,suffix);
		}
		
		/**
		 * 格式化值
		 * @param	o
		 * @param	link
		 * @param	"
		 * @param	prefix
		 * @param	suffix
		 * @return
		 */
		public static function formatKey(o:Map,link:String=",",prefix:String="[",suffix:String="]"):String
		{
			var v:String = "";
			
			var nowSize:int = 0;
			for (var key:String in o.rawData)
			{
				var line:String = key ;
				if (nowSize != o.size)
				{
					line+= link;
				}
				v += line;
			}
			
			return formatString(v,prefix,suffix);
		}
		
		
		/**
		 * 格式化字符串
		 * @param	string
		 * @param	prefix
		 * @param	suffix
		 */
		public static function formatString(string:String,prefix:String = "[", suffix:String = "]") 
		{
			return prefix + string + suffix;
		}
	}
	
}