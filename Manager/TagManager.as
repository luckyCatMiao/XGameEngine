package XGameEngine.Manager
{
	import XGameEngine.Util.*;
	import flash.display.Stage;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;
	
	/**
	 * ...
	 * @author o
	 */
	public class TagManager extends BaseManager
	{
		static public var TAG_DEFAULT = "defaultTag";
		static public var TAG_PLAYER = "player";
		
		
		private var tags:Map = new Map();
		
		static private var _instance:TagManager;
		
		
		static public function getInstance():TagManager
		{
				if (_instance == null)
				{
					_instance = new TagManager();
				}
				return _instance;
		}
		
		
		public function TagManager()
		{
			
			//注册默认的标签
			registerTag(TagManager.TAG_DEFAULT);
			
		}
		
		
		//注册标签
		public function registerTag(name:String)
		{
			tags.put(name, name);
		}
		
		//查找指定的标签是否已经注册
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
		
		
		public function debug()
		{
			trace(StringUtil.formatValue(tags));
		}
		
	}
	
}