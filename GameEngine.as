package XGameEngine
{
	import XGameEngine.Manager.GameObjectManager;
	import XGameEngine.Manager.TagManager;
	import XGameEngine.Manager.TimeManager;
	import XGameEngine.Advanced.Debug.*;
	import flash.display.Stage;
	import flash.events.Event;
	import XGameEngine.Advanced.Interface.LoopAble;
	import XGameEngine.Structure.*;
	/**
	 * ...
	 * a class that control the overall gameengine
	 */
	public class GameEngine 
	{
		static private var _instance:GameEngine;
		
		
		static public function getInstance():GameEngine
		{
				if (_instance == null)
				{
					_instance = new GameEngine();
				}
				return _instance;
		}
		
		
		private var s:Stage;
		private var list:List = new List();
		public var debug:Boolean=false;
		
		/**
		 * this should be called when game inited,generally from the entry class
		 * @param	s
		 */
		public function Init(s:Stage)
		{
			
			this.s = s;
			s.addEventListener(Event.ENTER_FRAME, loop);
			InitManager();
			
		}
		
		
		//初始化
		public function InitManager()
		{
			
			TimeManager.getInstance();
		}
		
		public function getTimeManager():TimeManager
		{
			return TimeManager.getInstance();
		}
		
		public function getTagManager():TagManager
		{
			return TagManager.getInstance();
		}
		
		public function getGameObjectManager():GameObjectManager
		{
			return GameObjectManager.getInstance();
		}
		
		
		private function loop(e:Event)
		{
			for (var i = 0; i < list.size; i++)
			{
				(list.get(i) as LoopAble).loop();
			}
		}
		
		public function addLoopAble(l:LoopAble)
		{
			list.add(l);
			
		}
		
		public function getStage():Stage 
		{
			return s;
		}
		
	}
	
}