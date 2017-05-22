package XGameEngine.GameObject
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import XGameEngine.GameObject.CommonComponent.*
	import XGameEngine.GameObject.Component.Collider.RectCollider;
	import XGameEngine.Manager.*;
	import XGameEngine.GameEngine;
	import XGameEngine.Manager.Hit.Collision;
	import XGameEngine.Structure.List;
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
		
		/**
		 * 该物体是否还有效 有时候可能存在被销毁后其他地方还引用该物体的情况 所以设置一个标识
		 */
		public var valid:Boolean=true;
		
		protected var anime_com:AnimeComponent;
		protected var collide_com:CollideComponent;
		protected var physics_com:PhysicsComponent;
		protected var transform_com:TransformComponent;
		protected var state_com:StateComponent;
		protected var obj_com:GameObjectComponent;
		protected var fun_com:FunComponent;
		
		protected var _xname:String;
		protected var _tag:String;
		protected var _layerName:String;
		
		protected var _state:String;
		
		private var needLoopComponents:List = new List();
		public function BaseGameObject(_name:String=null)
		{
			
			registerToGame();
			if (_name != null)
			{
				this.xname = _name;
			}
			tag = TagManager.TAG_DEFAULT;
			layerName = LayerManager.LAYER_DEFAULT;
			
			
			
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
		protected function InitComponent()
		{
			
			obj_com = new GameObjectComponent(this);
			anime_com = new AnimeComponent(this);
			collide_com = new CollideComponent(this);
			physics_com = new PhysicsComponent(this);
			transform_com = new TransformComponent(this);
			state_com = new StateComponent(this);
			fun_com = new FunComponent();
			
		}

		
		/**
		 * 初始化事件监听器
		 */
		protected function InitEvent()
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
			
			state_com.loop();
			transform_com.loop();
		
			

			//循环调用需要循环的子组件的循环方法
			var fun:Function = function(obj:Object):void {
			(obj as Function)();
			};
			needLoopComponents.forEach(fun);
			
			
			//调用外部循环 子类覆盖
			loop();
		}
		
		
		/**
		 * 引擎内部调用 组件使用该方法注册自己的循环方法
		 */
		public function addLoopFun(c:Function)
		{
			needLoopComponents.add(c);
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
		
		
		//重新设置名字的时候先进行检查 防止重复
		public function set xname(value:String):void 
		{
			if (GameEngine.getInstance().getGameObjectManager().findGameObjectByName(value) != null)
			{
				throw new Error("the GameObject named " + value+" exists");
			}
			this._xname = value;
		}
		
		public function get xname()
		{
			return _xname;
		}

		public function get gameEngine():GameEngine
		{
			return GameEngine.getInstance();
		}
		
		public function get tag():String 
		{
			return _tag;
		}
		
	
		/**
		 * 返回动画组件
		 * @return
		 */
		public function getAnimeComponent():AnimeComponent 
		{
			return anime_com;
		}
		/**
		 * 返回碰撞组件
		 * @return
		 */
		public function getCollideComponent():CollideComponent 
		{
			return collide_com;
		}
		/**
		 * 返回物理组件
		 * @return
		 */
		public function getPhysicsComponent():PhysicsComponent 
		{
			return physics_com;
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
		 * 返回状态机组件
		 * @return
		 */
		public function getStateComponent():StateComponent 
		{
			return state_com;
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
		
		
		public function set tag(value:String):void 
		{	
			//检查一下tag管理器中是不是注册了这个tag
			if (getTagManager().findTag(value) == false)
			{
				throw new Error("tag " + value+" not registered!");
			}
			_tag = value;
		}
		
		public function get layerName():String 
		{	
			return _layerName;
		}
		
		public function set layerName(value:String):void 
		{
			//检查一下tag管理器中是不是注册了这个tag
			//同时删除原来的层 再添加进新层
			if (getLayerManager().checkLayer(value) == false)
			{
				throw new Error("tag " + value+" not registered!");
			}
			getLayerManager().addToLayer(this, value);
			_layerName = value;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			getStateComponent().changeState(value);
			_state = value;
		}

		public function getTagManager():TagManager 
		{
			return gameEngine.getTagManager();
		}
		public function getLayerManager():LayerManager 
		{
			return gameEngine.getLayerManager();
		}
		public function getHitManager():HitManager 
		{
			return gameEngine.getHitManager();
		}
		public function getGameObjectManager():GameObjectManager 
		{
			return gameEngine.getGameObjectManager();
		}
		public function getTimeManager():TimeManager 
		{
			return gameEngine.getTimeManager();
		}
		
		public function onHitEnter(c:Collision) 
		{
			
		}
		
		public function onHitStay(c:Collision) 
		{
			
		}
		public function onHitExit(c:Collision) 
		{
			
		}
		
		//状态机
		public function onStateEnter(newstate:String,lastState:String)
		{
			
		}
		public function onStateDuring(state:String)
		{
			
		}
		public function onStateExit(state:String)
		{
			
		}
		
		/**
		 * 如果当前处在第二个状态就把当前状态变换到当前状态
		 * 如果有多个状态,把状态填在数组中
		 * @param	state
		 */
		public function tryChangeState(newstate:String,conditionState:String,otherState:Array=null)
		{
			//trace(state+" "+conditionState);
			
			if (state == conditionState)
			{	
				getStateComponent().changeState(newstate);
				_state = newstate;
			}
			if (otherState != null)
			{
				for each(var s:String in otherState)
				{
					if (s == state)
					{
						getStateComponent().changeState(newstate);
						_state = newstate;
					}
				}
			}
		}
		
		
		
		/**
		 * 销毁物体 必须把所有与之有关的引用都断开 否则该物体不会回收 会造成游戏越来越卡
		 */
		public function destroy()
		{
					
			//其实我感觉组件应该是自动回收的..不过不太放心
			//还是手动清空一下 其实就是我不太清楚 如果组件被该对象以外的其他对象引用了 那这个对象还会不会被回收?
			//还是说回收该对象 但是保留组件?(想了想应该是这样 不过组件也没有保留的必要 也清除)
			obj_com = null;
			anime_com =  null;
			collide_com =  null;
			physics_com =  null;
			transform_com =  null;
			state_com = null;
			fun_com =  null;
			
			
			valid = false;
			
				this.removeEventListener(Event.ENTER_FRAME, _loop);
				this.removeEventListener(Event.ADDED_TO_STAGE, addTo);

				this.parent.removeChild(this);
				GameObjectManager.getInstance().remove(this);
					LayerManager.getInstance().removeFromLayer(this);
		}
		
		
		/**
		 * 左下角的碰撞器点转换到全局坐标(这里不用aabb取点是因为aabb设定为实时变化)
		 */
		public function get leftBottomGlobalPoint()
		{
			var r:RectCollider = this.getCollideComponent().rectCollider 
			var point:Point = this.localToGlobal(r.getLeftBottomPoint());
			
			return point;
		}
		/**
		 * 左上角的碰撞器点转换到全局坐标(这里不用aabb取点是因为aabb设定为实时变化)
		 */
		public function get leftTopGlobalPoint()
		{
			var r:RectCollider = this.getCollideComponent().rectCollider 
			var point:Point = this.localToGlobal(r.getLeftTopPoint());
			
			return point;
		}
		/**
		 * 右下角的碰撞器点转换到全局坐标(这里不用aabb取点是因为aabb设定为实时变化)
		 */
		public function get rightBottomGlobalPoint()
		{
			var r:RectCollider = this.getCollideComponent().rectCollider 
			var point:Point = this.localToGlobal(r.getRightBottomPoint());
			
			return point;
		}
		/**
		 * 右上角的碰撞器点转换到全局坐标(这里不用aabb取点是因为aabb设定为实时变化)
		 */
		public function get rightTopGlobalPoint()
		{
			var r:RectCollider = this.getCollideComponent().rectCollider 
			var point:Point = this.localToGlobal(r.getRightTopPoint());
			
			return point;
		}
		
		/**
		 * 中心位置碰撞器点转换到全局坐标(这里不用aabb取点是因为aabb设定为实时变化)
		 */
		public function get centerGlobalPoint()
		{
			var r:RectCollider = this.getCollideComponent().rectCollider 
			var point:Point = this.localToGlobal(r.getCenterPoint());
			
			return point;
		}
		
		
		public function get xparent():BaseGameObject
		{
			if (this.parent == null)
			{
				throw new Error("don't have parent!");
			}
			if (this.parent as BaseGameObject == null)
			{
				throw new Error("parent are not a basegameobject!");
			}
			
			return this.parent as BaseGameObject;
		}
		
	}
	
}