package XGameEngine.Manager
{
	import XGameEngine.*;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author o
	 */
	public class BaseManager 
	{
		protected var stage:Stage;
		public function BaseManager()
		{
			stage = GameEngine.getInstance().getStage();
			
		}
	}
	
}