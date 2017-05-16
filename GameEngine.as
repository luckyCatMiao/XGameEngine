package XGameEngine
{
	import XGameEngine.Debug.DebugManager;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author o
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
		
		
		public function Init(s:Stage)
		{
			this.s = s;
			s.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		
		private function loop(e:Event)
		{
			DebugManager.getInstance().loop();
		}
		
		public function getStage():Stage 
		{
			return s;
		}
		
	}
	
}