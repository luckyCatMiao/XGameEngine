package XGameEngine.Plugins.Movie
{
	import XGameEngine.Plugins.Movie.Command.BaseCommond;
	import XGameEngine.GameEngine;
	import XGameEngine.Collections.List;
	
	import flash.events.Event;
	
	/**
	 *一个movie由一系列命令组成 
	 * @author Administrator
	 * 
	 */	
	public class BaseMovie
	{
		/**
		 *影片名字 
		 */		
		public var name:String;
		private var listener:Function;
		private var commonds:List=new List();
		private var nowIndex:int=-1;
		private var currentCommond:BaseCommond;
		
		public function BaseMovie()
		{
			
			
		}
		
		public function play():void
		{
			//按顺序执行指令
			GameEngine.getInstance().stage.addEventListener(Event.ENTER_FRAME,loop);
			
			
			beforeMovieStart();
			//执行第一条命令 因为初始索引是-1
			nextCommond();
		}
		
		public function beforeMovieStart():void
		{
			// TODO Auto Generated method stub
			
		}
		
		/**
		 *跳转到下一条命令 
		 * 
		 */		
		public function nextCommond():void
		{
			//退出上一条命令
			if(currentCommond!=null)
			{
				currentCommond.exit();
			}
			
			nowIndex++;
			//如果播放完毕则退出
			if(nowIndex==commonds.size)
			{
				over();
			}
			//切换到下一条命令
			else
			{
				
				currentCommond=commonds.get(nowIndex);
				currentCommond.enter();
			}
			
			
			
		}
		
		private function over():void
		{
			GameEngine.getInstance().stage.removeEventListener(Event.ENTER_FRAME,loop);
			if(listener!=null)
			{
				listener();
			}
			movieEnd();
			
		}
		
		public function movieEnd():void
		{
			// TODO Auto Generated method stub
			
		}
		
		protected function loop(event:Event):void
		{
			
			var c:BaseCommond=commonds.get(nowIndex);
			c.update();
			
			
		}
		
		public function setAchieveListener(fun:Function)
		{
			this.listener=fun;
		}
		
		public function addCommond(c:BaseCommond):void
		{
			
			this.commonds.add(c);
			
		}
	}
}
