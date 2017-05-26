package XGameEngine.GameObject.Component
{
	import flash.text.TextFieldAutoSize;
	import flash.geom.Point;
	import XGameEngine.UI.Draw.*;
	import XGameEngine.UI.*;
	import XGameEngine.GameEngine;
	import XGameEngine.GameObject.BaseGameObject;
	
	/**
	 * ...
	 * @author o
	 */
	public class StateComponent extends BaseComponent
	{
		
		public var lastState:String;
		
		
		private var debug_stateTF:XTextField;
		
		public var debugState:Boolean = false;
		private var _state:String;
		
		public function StateComponent(o:BaseGameObject)
		{
			super(o);
			
			
		}
		
		
		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			changeState(value);
			_state = value;
		}

		public function changeState(newState:String)
		{
			//如果两个状态相同的话 直接返回 也不报错 
			if(_state==newState)
			{
				return;
			}
			
			//如果上一个状态存在的话
			if (_state != null)
			{
				host.onStateExit(_state);
			}
		
			host.onStateEnter(newState, _state)
			

			lastState = newState;
			
		}
		
		public function loop()
		{
			DebugState();
			
			
			if (_state != null)
			{
			host.onStateDuring(_state);	
			}
			
			
			
			
		}
		
		
		/**
		 * 绘制当前状态
		 */
		public function DebugState()
		{
			
			if (GameEngine.getInstance().debug&&debugState==true)
			{
				
				if (_state != null)
				{
					if (debug_stateTF == null)
					{
						debug_stateTF = new XTextField();
						host.stage.addChild(debug_stateTF);
						debug_stateTF.size = 20;
						debug_stateTF.textColor = Color.BLACK;

						debug_stateTF.autoSize = TextFieldAutoSize.CENTER;
						
						
					}
					
					if (debug_stateTF.parent == null)
					{
						host.stage.addChild(debug_stateTF);
					}
					
					 var point:Point = host.getTransformComponent().oldaabb.getLeftTopPoint();
					 var point2:Point=host.localToGlobal(point);
					debug_stateTF.x = point2.x;
					debug_stateTF.y = point2.y-20;
					
					debug_stateTF.setText(_state);
				}
			}
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
		
		
		
		public function tryChangeState(newstate:String, conditionState:String, otherState:Array):void
		{
			
		
			
			if (state == conditionState)
			{	
				changeState(newstate);
				_state = newstate;
			}
			if (otherState != null)
			{
				for each(var s:String in otherState)
				{
					if (s == state)
					{
						changeState(newstate);
						_state = newstate;
					}
				}
			}
			
		}
	}
	
}