package XGameEngine.GameObject.Component
{
	import XGameEngine.GameEngine;
	import XGameEngine.GameObject.BaseGameObject;
	
	/**
	 * ...
	 * @author o
	 */
	public class StateComponent extends BaseComponent
	{
		
		public var lastState:String;
		
		public function StateComponent(o:BaseGameObject)
		{
			super(o);
			
			
		}
		
		
		public function changeState(newState:String)
		{
			//如果上一个状态存在的话
			if (lastState != null)
			{
				host.onStateExit(lastState);
			}
			host.onStateEnter(newState, lastState)
			
			lastState = newState;
		}
		
		public function loop()
		{
			if (host.state != null)
			{
			host.onStateDuring(host.state);	
			}
			
		}
		
		
		/**
		 * 绘制当前状态
		 */
		public function DebugState()
		{
			if (GameEngine.getInstance().debug)
			{
				if (host.state != null)
				{
					
				}
			}
		}
		
	}
	
}