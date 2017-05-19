package XGameEngine.Manager
{
	import flash.display.Stage;
	import XGameEngine.GameObject.*;
	import XGameEngine.Structure.*;
	import XGameEngine.Structure.Math.*;
	
	/**
	 * ...
	 * @author o
	 */
	//保存所有游戏对象
	public class GameObjectManager extends BaseManager
	{
		private var gobjects:List = new List();
		
		
		static private var _instance:GameObjectManager;
		
		
		static public function getInstance():GameObjectManager
		{
				if (_instance == null)
				{
					_instance = new GameObjectManager();
				}
				return _instance;
		}
		
		
		/**
		 * 返回所有游戏对象的一个拷贝副本
		 */
		public function get objects():List
		{
			return gobjects.clone()
		}
		
		public function get size()
		{
			return gobjects.size;
		}
		
		public function register(a:BaseGameObject)
		{
			gobjects.add(a);
		}
		
	    public function debug()
		{
			trace(gobjects.toString());
		}
		
		public function remove(a:BaseGameObject):Boolean
		{
				return false;
		}
		
			
		/**
		 * 根据名称查找gameobject
		 * @param	name
		 * @return
		 */
		public function findGameObjectByName(name:String):BaseGameObject
		{
			var fun:Function= function(element:*, index:int, arr:Array):Boolean {
			return (element as BaseGameObject).xname == name;
			 };

			 var result:List = gobjects.filter(fun);
			 
			return result.size==1?result.get(0) as BaseGameObject:null;
		}
		
		/**
		 * 根据标签返回第一个找到的gameobject
		 * @return
		 */
		public function findGameObjectWithTag():BaseGameObject
		{
			return null;
		}
		
		/**
		 * 根据标签返回所有找到的gameobejct
		 * @return
		 */
		public function findGameObjectsWithTag():List
		{
			return null;	
		}
		
		
		
		
	
		
	}
	
}