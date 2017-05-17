package XGameEngine.Manager
{
	
	/**
	 * ...
	 * @author o
	 */
	public class TimeManager extends BaseManager
	{
		
		static private var _instance:TimeManager;
		
		
		static public function getInstance():TimeManager
		{
				if (_instance == null)
				{
					_instance = new TimeManager();
				}
				return _instance;
		}
		
		
		
		private var oldFrameRate:Number;
		public function TimeManager()
		{
			oldFrameRate = stage.frameRate;
		}
		public function scaleFrameRate(scale:Number)
		{
			stage.frameRate *= scale;
		}
		
		
		public function setFrameRate(r:Number)
		{
			stage.frameRate = r;
		}
		
		public function stop()
		{
			stage.frameRate = 0;
		}
		
		public function reset()
		{
			stage.frameRate = oldFrameRate;
		}
		
		
		public function drawControlPanel()
		{
			
		}
		
	}
	
}