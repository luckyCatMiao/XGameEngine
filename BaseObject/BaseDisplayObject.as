package XGameEngine.BaseObject
{
	import XGameEngine.BaseObject.BaseComponent.CommonlyComponent;
	import XGameEngine.BaseObject.BaseComponent.EventComponent;
	import XGameEngine.BaseObject.BaseComponent.FunComponent;
	import XGameEngine.BaseObject.BaseComponent.GameObjectComponent;
	import XGameEngine.BaseObject.BaseComponent.Render.RenderComponent;
	import XGameEngine.BaseObject.BaseComponent.TransformComponent;
	import XGameEngine.BaseObject.BaseComponent.TweenComponent;
	import XGameEngine.BaseObject.BaseDisplayObject;
	import XGameEngine.GameEngine;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.GameObjectComponent.*;
	import XGameEngine.GameObject.GameObjectComponent.Anime.AnimeComponent;
	import XGameEngine.GameObject.GameObjectComponent.Collider.CollideComponent;
	import XGameEngine.GameObject.GameObjectComponent.Collider.Collider.RectCollider;
	import XGameEngine.GameObject.GameObjectComponent.StateMachine.AbstractState;
	import XGameEngine.GameObject.GameObjectComponent.StateMachine.StateComponent;
	import XGameEngine.Manager.*;
	import XGameEngine.Manager.Hit.Collision;
	import XGameEngine.Manager.TagManager;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Math.Vector2;
	import XGameEngine.Util.*;
	
	import fl.motion.Animator3D;
	import fl.motion.Motion;
	import fl.motion.MotionBase;
	import fl.transitions.Fade;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
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
		protected var tween_com:TweenComponent;
		protected var render_com:RenderComponent;
		protected var event_com:EventComponent;
		protected var transform_com:TransformComponent;
		
		protected var engine:GameEngine;
		protected var gamePlane:BaseDisplayObject;			
		protected var UIPlane:BaseDisplayObject;	
		protected var UIPlane2:BaseDisplayObject;	
		protected var debugPlane:BaseDisplayObject;
		protected var cameraPlane:BaseDisplayObject;
		
		
	
	
	
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
			cameraPlane=engine.cameraPlane;
			
			
		}
		
		
		/**
		 *本地坐标 
		 * @return 
		 * 
		 */		
		public function get localPosition():Vector2
		{
			return new Vector2(x,y);
		}

		public function get globalPosition():Vector2
		{
			return new Vector2(globalX,globalY);
		}
		
		public function get globalY():Number
		{
			var point:Point=this.localToGlobal(Vector2.VEC2_ZERO.toPoint());
			
			
			return point.y;
		}
		
		
		
		public function get globalX():Number
		{
			var point:Point=this.localToGlobal(Vector2.VEC2_ZERO.toPoint());
			
			
			return point.x;
		}

		
		protected function InitComponent():void
		{
			obj_com = new GameObjectComponent(this);
			fun_com = new FunComponent();
			common_com=new CommonlyComponent();
			tween_com=new TweenComponent(this);
			render_com=new RenderComponent(this);
			event_com=new EventComponent(this);
			transform_com = new TransformComponent(this);
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
			fun_com.loop();
			transform_com.loop();
			loop();
			
		}
		
		protected function loop():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		protected function addTo(event:Event):void
		{
			//即使多次添加舞台移除 只有在第一次的时候会调用初始化 
			this.removeEventListener(Event.ADDED_TO_STAGE, addTo);
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
		 * 返回变换组件(便捷的旋转,缩放..)
		 * @return
		 */
		public function getTransformComponent():TransformComponent 
		{
			return transform_com;
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
		/**
		 * 返回插值动画组件
		 * @return
		 */
		public function getTweenComponent():TweenComponent 
		{
			return tween_com;
		}
		/**
		 * 
		 * @return
		 */
		public function getRenderComponent():RenderComponent 
		{
			return render_com;
		}
		/**
		 * 
		 * @return
		 */
		public function getEventComponent():EventComponent 
		{
			return event_com;
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
		
		public function getTweenManager():TweenManager
		{
			return engine.getTweenManager();	
		}
		
		
		public function destroy()
		{
			this.parent.removeChild(this);
			//回收所有子级
			getGameObjectComponent().destroyAllChilds();
			this.removeEventListener(Event.ENTER_FRAME, _loop);
			
		}
		
		
		
		/**
		 * 转换当前坐标系内某点到另一个对象坐标系的中 
		 * @param point 当前坐标系中的某点
		 * @param other 另一个对象
		 * @return 
		 * 
		 */		
		public function localToOtherLocal(point:Point,other:DisplayObject):Vector2
		{
			return GameUtil.localToOtherLocal(point,this,other);
			
		}
		
		
		/**
		 * 转换另一个坐标系内某点到当前坐标系的中 
		 * @param point 另一个坐标系中的某点
		 * @param other 另一个对象
		 * @return 
		 * 
		 */		
		public function otherLocalToMyLocal(point:Point,other:DisplayObject):Vector2
		{
			return GameUtil.localToOtherLocal(point,other,this);
		}
		
		
		/**
		 *只销毁所有子级(递归) ,不销毁本身
		 * @return 
		 * 
		 */		
		public function destroyAllChild()
		{
			getGameObjectComponent().destroyAllChilds();
		}
		
	}
}