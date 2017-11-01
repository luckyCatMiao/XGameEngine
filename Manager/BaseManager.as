package XGameEngine.Manager
{
	import XGameEngine.*;
	import XGameEngine.BaseObject.BaseComponent.CommonlyComponent;
	import XGameEngine.BaseObject.BaseComponent.FunComponent;
	
	import flash.display.Stage;
	
	/**
	 * 游戏管理器基类
	 * @author o
	 */
	public class BaseManager 
	{
		protected var stage:Stage;
		
		protected var com_common:CommonlyComponent;
		protected var fun_common:FunComponent;
		public function BaseManager()
		{
			stage = GameEngine.getInstance().getStage();
			
			com_common=new CommonlyComponent();
			fun_common=new FunComponent();
			
						
		}
		
		public function getCommonlyComponent():CommonlyComponent
		{
			return com_common;
		}

		public function getFunComponent():FunComponent
		{
			return fun_common;
		}
		protected function checkNull(o:Object,msg:String="paramter")
		{
			if (o == null)
			{
				throw new Error(msg + " can't null!");
			}
		}

		protected  function getEngine():GameEngine
		{
			return GameEngine.getInstance();
		}
	}
	
}