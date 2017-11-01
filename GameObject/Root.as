package XGameEngine.GameObject
{
	import XGameEngine.GameEngine;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;

	/**
	 *helper class to init engine
	 * @author Administrator
	 * 
	 */	
	public class Root extends MovieClip
	{
		/**
		 *引擎对象 
		 */		
		public var engine:GameEngine;
		
		
		public function Root()
		{
			
			//默认写法
			if(stage!=null)
				_addToStage(null);
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,_addToStage);
			}
			
		}
		
		private function _addToStage(event:Event=null):void
		{
			this.engine=GameEngine.getInstance();
			
			
			addToStage();
		}
		
		protected function addToStage():void
		{
			
			
			throw new Error("抽象方法");
			
		}
		

		/**
		 *初始化引擎 
		 * @param dataPath
		 * 
		 */		
		protected function InitEngine(dataPath:String):void
		{
			engine.Init(stage,dataPath,_loadAchieve,_loadProgress);
			
		}	
		
		private function _loadProgress(e:ProgressEvent):void
		{
			var percent:int=e.bytesLoaded*100/e.bytesTotal;
			
			loadProgress(percent);
		}
		
		private function _loadAchieve(e:Event):void
		{
			loadAchieve();
			
		}		
		
		
		/**
		 *加载数据中回调 
		 * @param percent 加载百分比 1-100之间的数
		 * 
		 */		
		protected function loadProgress(percent:Number):void
		{
			
		}
		
		
		/**
		 *加载数据完成后回调 
		 * @param e
		 * @return 
		 * 
		 */		
		protected function loadAchieve():void
		{
		
		}
			
	}
}