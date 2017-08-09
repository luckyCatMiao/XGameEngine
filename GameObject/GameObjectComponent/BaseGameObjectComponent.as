package XGameEngine.GameObject.GameObjectComponent
{
	import XGameEngine.BaseObject.BaseComponent.BaseComponent;
	import XGameEngine.BaseObject.BaseDisplayObject;
	import XGameEngine.GameObject.BaseGameObject;

	public class BaseGameObjectComponent extends BaseComponent
	{
		
		protected var _host:BaseGameObject;
		/**
		 *对应 BaseGameObject的组件基类
		 * 
		 */		
		public function BaseGameObjectComponent(o:BaseGameObject)
		{
			_host = o;
			
		}
		
		 public function get host():BaseGameObject
		{
			// TODO Auto Generated method stub
			return _host;
		}
		
		
		
	}
}