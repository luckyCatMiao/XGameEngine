package XGameEngine.GameObject
{
	import XGameEngine.GameEngine;
	import XGameEngine.Util.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import XGameEngine.GameObject.Component.*;
	
	/**
	 * ...
	 * the fundamental gameobject,provide a sets of useful features.
	 */
	public class BaseGameObject extends Sprite
	{
		
		protected var anime_com:AnimeComponent;
		protected var collide_com:CollideComponent;
		protected var physics_com:PhysicsComponent;
		
		protected var _xname:String;
		public function BaseGameObject(_name:String=null)
		{
			
			registerToGame();
			
			
			InitComponent();
			InitEvent();
		}
		
		/**
		 * 注册该对象到游戏对象管理器中
		 */
		private function registerToGame()
		{
			
			//创建默认名字
			if (_xname != null)
			{this._xname = _xname }
			else
			{this._xname = "object" + GameEngine.getInstance().getGameObjectManager().size; }	
			
			//注册
			GameEngine.getInstance().getGameObjectManager().register(this);
		}
		
		
		
		/**
		 * 初始化组件
		 */
		private function InitComponent()
		{
			
			anime_com = new AnimeComponent(this);
			collide_com = new CollideComponent(this);
			physics_com = new PhysicsComponent(this);
			
		}

		
		/**
		 * 初始化事件监听器
		 */
		private function InitEvent()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addTo, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, _loop, false, 0, true);
		}
		private function addTo(a:Event)
		{
			Init();
		}
		
		/**
		 * 内部循环
		 * @param	e
		 */
		protected function _loop(e:Event)
		{
			if (physics_com.enable == true)
			{
				physics_com.calulate();
			}
			
			loop();
		}
		
		protected function Init()
		{
			
		}
		
		/**
		 * set the position
		 * @param	x
		 * @param	y
		 */
		public function setPosition(x:Number, y:Number)
		{
			this.x = x;
			this.y = y;
		}
		
		
		/**
		 * 子类进行覆盖的循环
		 */
		protected function loop()
		{
			
		}
		
		
		
		override public function toString():String 
		{
			return "[BaseGameObject name="+_xname+"]";
		}
		
		public function set xname(value:String):void 
		{
			if (GameEngine.getInstance().getGameObjectManager().findGameObjectByName(value) != null)
			{
				throw new Error("the GameObject named " + value+" exists");
			}
		}
		
		public function get xname()
		{
			return _xname;
		}

		public function get gameEngine():GameEngine
		{
			return GameEngine.getInstance();
		}

		
		
	}
	
}