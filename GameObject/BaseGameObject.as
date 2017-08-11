package XGameEngine.GameObject
{
	import XGameEngine.BaseObject.BaseDisplayObject;
	import XGameEngine.GameEngine;
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
	
	/**
	 * ...
	 * the fundamental gameobject,provide a sets of useful features.
	 */
	public class BaseGameObject extends BaseDisplayObject
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

		
		protected var _xname:String;
		protected var _tag:String;
		protected var _layerName:String;
		
		private var _globalX:Number;
		private var _globalY:Number;
	

		public function BaseGameObject(_name:String=null)
		{
			this.xname = _name;
			//注册到游戏各个管理器中
			registerToGame();
			
			
			
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

	

		/**
		 * 注册该对象到游戏对象管理器中
		 */
		private function registerToGame()
		{
			
			//如果创建对象时没有传入名字，则创建默认名字
			if (_xname == null)
			{this._xname = "object" + GameEngine.getInstance().getGameObjectManager().size; }	
			
			//注册到对象管理器中
			GameEngine.getInstance().getGameObjectManager().register(this);
			
			//添加默认标签
			tag = TagManager.TAG_DEFAULT;
			//添加到默认层中
			layerName = LayerManager.LAYER_DEFAULT;	
			
		}
		
		
		
		
		/**
		 * 初始化组件
		 */
		override protected function InitComponent():void
		{

			super.InitComponent();			
			anime_com = new AnimeComponent(this);
			collide_com = new CollideComponent(this);
			physics_com = new PhysicsComponent(this);
			state_com = new StateComponent(this);
			transform_com = new TransformComponent(this);
			
		}
		
		/**
		 * 内部循环
		 * @param	e
		 */
		override protected function _loop(e:Event):void
		{
			
			
			
			if(valid==false)
			{
				return;
			}
			
			if (physics_com.enable == true)
			{
				physics_com.calulate();
			}
			
			
			transform_com.loop();
			collide_com.loop();
			fun_com.loop();
			state_com.loop();
		
			loop();
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
		
		public function get state():AbstractState 
		{
			return getStateComponent().state;
		}
		
		public function set state(value:AbstractState):void 
		{
			
			getStateComponent().state = value;
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
		
		
		
		/**
		 * 如果当前处在第二个状态就把当前状态变换到当前状态
		 * 如果有多个状态,把状态填在数组中
		 * @param	state
		 */
		public function tryChangeState(newstate:AbstractState, conditionState:AbstractState,otherState:Array=null)
		{
			//trace(state+" "+conditionState);
			
			getStateComponent().tryChangeState(newstate,conditionState,otherState);
		}
		
		
		
		
		
		/**
		 * 销毁物体 必须把所有与之有关的引用都断开 否则该物体不会回收 会造成游戏越来越卡
		 */
		override public function destroy()
		{
				
			super.destroy();
			

			//其实我感觉组件应该是自动回收的..不过不太放心
			//还是手动清空一下 其实就是我不太清楚 如果组件被该对象以外的其他对象引用了 那这个对象还会不会被回收?
			//还是说回收该对象 但是保留组件?(想了想应该是这样 不过组件也没有保留的必要 也清除)
			obj_com.destroyComponent();
			//obj_com = null;
			anime_com.destroyComponent();
			//anime_com =  null;
			collide_com.destroyComponent();
			//collide_com =  null;
			physics_com.destroyComponent();
			//physics_com =  null;
			transform_com.destroyComponent();
			//transform_com =  null;
			state_com.destroyComponent();
			//state_com = null;
			//fun_com =  null;
			
			
			valid = false;
			
				
				this.parent.removeChild(this);
				GameObjectManager.getInstance().remove(this);
				LayerManager.getInstance().removeFromLayer(this);
				
				
				//回收所有子级
				getGameObjectComponent().destroyAllChilds();
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