package XGameEngine.Manager
{
	import XGameEngine.GameEngine;
	
	import flash.media.Sound;

	/**
	 * 管理外部资源的类
	 */
	public class ResourceManager extends BaseManager
	{
		
		static private var _instance:ResourceManager;
		
		
		static public function getInstance():ResourceManager
		{
			if (_instance == null)
			{
				_instance = new ResourceManager();
			}
			return _instance;
		}
		
		
		
		public function LoadSoundByName(name:String):Sound
		{
			var cls:Class=getClassByName(name);
			
			return new cls() as Sound;
		}
		
		private function getClassByName(name:String):Class
		{
			var cls:Class=GameEngine.getInstance().dataDomain.getDefinition(name) as Class;
			
			
			return cls;
		}
	}
}