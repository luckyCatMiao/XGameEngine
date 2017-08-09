package XGameEngine.Manager
{
	import XGameEngine.*;
	import XGameEngine.BaseObject.BaseComponent.CommonlyComponent;
	
	import flash.display.Stage;
	
	/**
	 * 游戏管理器基类
	 * @author o
	 */
	public class BaseManager 
	{
		protected var stage:Stage;
		
		protected var _com_common:CommonlyComponent;
		public function BaseManager()
		{
			stage = GameEngine.getInstance().getStage();
			
			_com_common=new CommonlyComponent();
		}
		
		public function getCommonlyComponent():CommonlyComponent
		{
			return _com_common;
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