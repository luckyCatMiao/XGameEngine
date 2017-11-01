package XGameEngine.GameObject.GameObjectComponent.StateMachine
{
	import XGameEngine.BaseObject.BaseComponent.BaseComponent;
	import XGameEngine.GameEngine;
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.GameObjectComponent.BaseGameObjectComponent;
	import XGameEngine.Collections.Stack;
	import XGameEngine.UI.*;
	import XGameEngine.UI.Draw.*;
	import XGameEngine.UI.Special.XDebugText;
	import XGameEngine.UI.Special.XTextField;
	
	import fl.transitions.Fade;
	
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author o
	 */
	public class StateComponent extends BaseGameObjectComponent
	{
		
		/**
		 * 全局状态
		 */
		private var _globalState:AbstractState ;
		/**
		 * 当前状态
		 */
		private var currentState:AbstractState;
		/**
		 * 之前的状态栈
		 */
		private var previousStates:Stack=new Stack();
		
		
		
		private var debug_stateTF:XTextField;
		
		public var debugState:Boolean = false;
		
		
		public function StateComponent(o:BaseGameObject)
		{
			super(o);
			
			
		}
		
		
		public function get state():AbstractState
		{
			return currentState;
		}

		public function set state(state:AbstractState):void
		{
			enterNewState(state);
		
		}
		
	
		public function get globalState():AbstractState
		{
			return this._globalState;
		}
		
		public function set globalState(state:AbstractState):void
		{
			this._globalState=state
			
		}

		public function enterNewState(newState:AbstractState)
		{
			//重复进入相同状态直接返回
			if(currentState!=null)
			{
				if(newState.equals(currentState))
				{
					return;
				}
				
				
				currentState.exit();
				//把之前的状态压入栈中
				previousStates.push(currentState);
			}
			newState.enter();
			this.currentState=newState;
			
		}
		
		public function loop()
		{
			
			DebugState();
			
			
			if(currentState!=null){currentState.during()};
			if(globalState!=null){globalState.during();}
			

		}
		
		
		
		/**
		 * debug 绘制当前状态
		 */
		public function DebugState()
		{
			//如果需要debug 
			if (GameEngine.getInstance().debug&&debugState==true)
			{
				//如果当前没有初始化
					if (debug_stateTF == null)
					{
						debug_stateTF = new XDebugText();
					
					}
					
					//添加到父级中
					if (debug_stateTF.parent == null)
					{
						host.gameEngine.gamePlane.addChild(debug_stateTF);
					}
					
					
					
					//设置位置
					 var point:Point = host.getTransformComponent().oldaabb.getLeftTopPoint();
					 var point2:Point=host.localToGlobal(point);
					debug_stateTF.x = point2.x;
					debug_stateTF.y = point2.y-20;
					
					debug_stateTF.setText(currentState.getName());
				
			}
			//不需要debug
			else if (GameEngine.getInstance().debug==false||debugState==false)
			{
				if (debug_stateTF!=null&&debug_stateTF.parent != null)
				{
						debug_stateTF.parent.removeChild(debug_stateTF);
				}
			}
		}
		
		
		
		override public function destroyComponent():void
		{

			if(debug_stateTF!=null)
			{
				debug_stateTF.alpha=0;
			}
			
		}
		
		
		/**
		 * 尝试切换状态 如果 当前所处在 conditionState状态或者otherState包含的某个状态 ,则进入newstate 
		 * @param newstate
		 * @param conditionState
		 * @param otherState
		 * 
		 */		
		public function tryChangeState(newstate:AbstractState, conditionState:AbstractState,otherState:Array=null):void
		{
			
		
			
			if (state.equals(conditionState))
			{	
				enterNewState(newstate);
			}
			if (otherState != null)
			{
				for each(var s:AbstractState in otherState)
				{
					if (s .equals( state))
					{
						enterNewState(newstate);
					}
				}
			}
			
		}
		
		
		/**
		 * 返回到上一个状态
		 * @param globalState
		 */
		public function returnPreviousState() {
			
			//System.out.println(previousStates);
			
			if(previousStates.isEmpty())
			{
				throw new Error("状态栈为空");
			}
			else 
			{
				currentState.exit();
				var state:AbstractState=previousStates.pop();
				
				state.flip();
				this.currentState=state;
				
			}
			
		}
		
		
	}
	
}