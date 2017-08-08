package XGameEngine
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.CommonComponent.CommonlyComponent;
	
	/**
	 * ...
	 * @author o
	 */
	public class BaseComponent 
	{
	
		public var enable:Boolean = true;
		
		private var common_com:CommonlyComponent;
		
		public function BaseComponent()
		{
		
			common_com = new CommonlyComponent();
		}
		
		
	

		public function getCommonlyComponent():CommonlyComponent
		{
			return common_com;
		}
		
		
		
		/**
		 *销毁组件 在对象销毁的时候自动调用 
		 * 
		 */
		public function destroyComponent():void
		{
			
		}
		
		
		
		
	}
	
}