package XGameEngine
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.CommonComponent.CommonlyComponent;
	import XGameEngine.GameObject.CommonComponent.FunComponent;
	import XGameEngine.GameObject.GameObjectComponent.GameObjectComponent;
	import XGameEngine.Manager.TagManager;
	
	import XGameEngine.BaseDisplayObject;
	import XGameEngine.GameEngine;
	import XGameEngine.GameObject.CommonComponent.*;
	import XGameEngine.GameObject.GameObjectComponent.*;
	import XGameEngine.GameObject.GameObjectComponent.Anime.AnimeComponent;
	import XGameEngine.GameObject.GameObjectComponent.Collider.CollideComponent;
	import XGameEngine.GameObject.GameObjectComponent.Collider.Collider.RectCollider;
	import XGameEngine.GameObject.GameObjectComponent.StateMachine.AbstractState;
	import XGameEngine.GameObject.GameObjectComponent.StateMachine.StateComponent;
	import XGameEngine.Manager.*;
	import XGameEngine.Manager.Hit.Collision;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Math.Vector2;
	import XGameEngine.Util.*;
	
	import fl.transitions.Fade;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.events.Event;

	
	/**
	 *可以渲染的基础对象 分别子类拓展出游戏对象基类和ui基类 
	 * @author Administrator
	 * 
	 */	
	public class BaseDisplayObject extends MovieClip
	{
		
		/**
		 *组件 
		 */		
		protected var obj_com:GameObjectComponent;
		protected var fun_com:FunComponent;
		protected var common_com:CommonlyComponent;
		
		
		protected var engine:GameEngine;
		protected var gamePlane:BaseGameObject;			
		protected var UIPlane:BaseGameObject;	
		protected var UIPlane2:BaseGameObject;	
		protected var debugPlane:BaseGameObject;
		public function BaseDisplayObject()
		{
			
			
			//初始化组件
			InitComponent();
			//初始化事件监听器
			InitEvent();
			
			
			
			//将一些engine经常需要访问的内部值设置引用 方便使用
			engine=GameEngine.getInstance();
			gamePlane=engine.gamePlane;
			UIPlane=engine.UIPlane;
			UIPlane2=engine.UIPlane2;
			debugPlane=engine.debugPlane;
		}
		
	
		
		protected function InitComponent():void
		{
			obj_com = new GameObjectComponent(this);
			fun_com = new FunComponent();
			common_com=new CommonlyComponent();
			
		}
		
		
		/**
		 * 初始化事件监听器
		 */
		protected function InitEvent():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addTo, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, _loop, false, 0, true);
		}
		
		protected function _loop(event:Event):void
		{
			loop();
			
		}
		
		protected function loop():void
		{
			// TODO Auto Generated method stub
			
		}
		
		protected function addTo(event:Event):void
		{
			Init();
			
		}
		
		protected function Init():void
		{
			// TODO Auto Generated method stub
			
		}		
		
		
		/**
		 * 返回通用组件
		 * @return
		 */
		public function getCommonlyComponent():CommonlyComponent 
		{
			return common_com;
		}
		
		/**
		 * 返回对象管理器组件
		 * @return
		 */
		public function getGameObjectComponent():GameObjectComponent 
		{
			return obj_com;
		}
		
		/**
		 * 返回方法管理组件(支持例如延迟的方法调用)
		 * @return
		 */
		public function getFunComponent():FunComponent 
		{
			return fun_com;
		}
		
		
		public function getTagManager():TagManager 
		{
			return engine.getTagManager();
		}
		public function getLayerManager():LayerManager 
		{
			return engine.getLayerManager();
		}
		public function getHitManager():HitManager 
		{
			return engine.getHitManager();
		}
		public function getGameObjectManager():GameObjectManager 
		{
			return engine.getGameObjectManager();
		}
		public function getTimeManager():TimeManager 
		{
			return engine.getTimeManager();
		}
		public function getResourceManager():ResourceManager 
		{
			return engine.getResourceManager();
		}
		public function getSoundManager():SoundManager
		{
			return engine.getSoundManager();
			
		}
		
		public function destroy()
		{
			this.removeEventListener(Event.ENTER_FRAME, _loop);
			this.removeEventListener(Event.ADDED_TO_STAGE, addTo);
		}
		
	}
}