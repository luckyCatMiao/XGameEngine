package XGameEngine.Manager
{
	import XGameEngine.*;
	import flash.display.Stage;
	
	/**
	 * 游戏管理器基类
	 * @author o
	 */
	public class BaseManager 
	{
		protected var stage:Stage;
		public function BaseManager()
		{
			stage = GameEngine.getInstance().getStage();
			
		}
		
		protected function checkNull(o:Object,msg:String="paramter")
		{
			if (o == null)
			{
				throw new Error(msg + " can't null!");
			}
		}
	}
	
}