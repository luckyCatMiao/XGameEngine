package XGameEngine.GameObject.Component
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.CommonComponent.CommonlyComponent;
	
	/**
	 * ...
	 * @author o
	 */
	public class BaseComponent 
	{
		protected var host:BaseGameObject;
		public var enable:Boolean = true;
		
		private var common_com:CommonlyComponent;
		
		public function BaseComponent(o:BaseGameObject)
		{
			host = o;
			common_com = new CommonlyComponent();
		}
		
		
		public function getCommonlyComponent():CommonlyComponent
		{
			return common_com;
		}
		
		
	
		
		
	}
	
}