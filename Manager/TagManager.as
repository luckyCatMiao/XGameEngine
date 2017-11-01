package XGameEngine.Manager
{
	import XGameEngine.Util.*;
	import flash.display.Stage;
	import XGameEngine.Collections.List;
	import XGameEngine.Collections.Map;
	
	/**
	 * 标签管理器
	 * @author o
	 */
	public class TagManager extends BaseManager
	{
		
		static private var _instance:TagManager;
		
		
		static public function getInstance():TagManager
		{
				if (_instance == null)
				{
					_instance = new TagManager();
				}
				return _instance;
		}
		
		
		static public var TAG_DEFAULT = "defaultTag";
		static public var TAG_PLAYER = "player";
		
		
		private var tags:Map = new Map();
		
		
		public function TagManager()
		{
			
			//注册默认的标签
			registerTag(TagManager.TAG_DEFAULT);
			registerTag(TagManager.TAG_PLAYER);
			
		}
		
		
		/**
		 *注册标签 
		 * @param name 标签名
		 * @return 
		 * 
		 */		
		public function registerTag(name:String)
		{
			tags.put(name, name);
		}
		
		
		
		/**
		 *查找指定的标签是否已经注册 
		 * @param name 标签名
		 * @return 
		 * 
		 */		
		public function findTag(name:String):Boolean
		{
			if (tags.get(name) == null)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		
		/**
		 * 输出当前所有的标签 
		 * @return 
		 * 
		 */		
		public function debug()
		{
			trace(StringUtil.formatValue(tags));
		}
		
	}
	
}