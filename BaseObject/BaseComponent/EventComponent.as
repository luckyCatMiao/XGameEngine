package XGameEngine.BaseObject.BaseComponent
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.Collections.Map;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	

	public class EventComponent
	{
		private var host:EventDispatcher;
		private var f:FunComponent;
		public function EventComponent(e:EventDispatcher)
		{
			super();
			this.host=e;
			this.f=new FunComponent();
			
		}
		
		
		
		
		
		/**
		 *发送一个消息 
		 * @param param0
		 * 
		 */		
		public function dispatchEvent(event:Event):void
		{
			host.dispatchEvent(event);
			
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
		
			host.addEventListener(type,listener,useCapture,priority,useCapture);
		}
		
		/**
		 *默认的事件处理器 事件会被直接传递给当前状态
		 * @param e
		 * 
		 */		
		public function defaultReceiveFunction(e:Event):void
		{
		
			
			//消息同时会被传递给当前的状态
			if(host is BaseGameObject)
			{
				
				var o:BaseGameObject=host as BaseGameObject;
				if(o.state!=null)
				{
					o.state.receiveEvent(e);
				}
				if(o.getStateComponent().globalState!=null)
				{
					o.getStateComponent().globalState.receiveEvent(e);
				}
			}
			
		
			
		}
		
		/**
		 *单对单发送信息
		 * @param e
		 * 
		 */		
		public function sendEventTo(e:BaseGameObject):void
		{
			

		}
		
		
		/**
		 *发送一个延时消息 
		 * @param event
		 * @param delay 毫秒
		 * @return 
		 * 
		 */		
		public function dispatchEventDelay(event:Event,delay:int=0)
		{
			
			f.addDelayRecall(_dispatchEventDelay,delay,[event]);
		}
		
		private function _dispatchEventDelay(arr:Array):void
		{
			dispatchEvent(arr[0] as Event);
		}		
			
	}
}