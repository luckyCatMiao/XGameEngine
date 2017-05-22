﻿package XGameEngine.Manager
{
	import flash.display.Stage;
	import XGameEngine.GameObject.*;
	import XGameEngine.Structure.*;
	import XGameEngine.Structure.List.DifferentList;
	import XGameEngine.Structure.Math.*;
	/**
	 * ...
	 * @author o
	 */
	//保存所有游戏对象
	public class GameObjectManager extends BaseManager
	{
		
		
		
		static private var _instance:GameObjectManager;
		
		
		static public function getInstance():GameObjectManager
		{
				if (_instance == null)
				{
					_instance = new GameObjectManager();
				}
				return _instance;
		}
		
		
		private var gobjects:DifferentList = new DifferentList();
		
		public function GameObjectManager()
		{
			//设置比较方法为名字
			var fun:Function = function(o1:Object, o2:Object):Boolean
			{
				return o1.xname == o2.xname;
			}
			gobjects.setEqual(fun);
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
		
		/**
		 * 注册一个游戏对象
		 * @param	a
		 */
		public function register(a:BaseGameObject)
		{
			
			gobjects.add(a);
		}
		

	    public function debug()
		{
			trace(gobjects.toString());
		}
		
		
		public function remove(a:BaseGameObject)
		{
			gobjects.remove(a);
		}
		
			
		/**
		 * 根据名称查找gameobject
		 * @param	name
		 * @return
		 */
		public function findGameObjectByName(name:String):BaseGameObject
		{
			return gobjects.find(name, "xname")as BaseGameObject;

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