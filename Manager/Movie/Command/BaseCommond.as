package XGameEngine.Manager.Movie.Command
{
	import XGameEngine.Manager.Movie.BaseMovie;
	import XGameEngine.GameObject.BaseDisplayObject;
	import XGameEngine.Collections.List;

	/**
	 *影片指令 由演员和实际行为组成 
	 * @author Administrator
	 * 
	 */	
	public class BaseCommond
	{
		//protected var actors:List=new List();
		protected var movie:BaseMovie;
		/**
		 *演员 
		 */		
		protected var actor:BaseDisplayObject;
		public function BaseCommond(m:BaseMovie,actor:BaseDisplayObject)
		{
			this.movie=m;
			this.actor=actor;
		}
		
//		/**
//		 *添加演员 
//		 * @param actor
//		 * 
//		 */		
//		public function addActor(actor:BaseDisplayObject):void
//		{
//			this.actors.add(actor);
//			
//		}
		
		
		
		/**
		 *进入命令时回调
		 * 
		 */		
		public function enter():void
		{
			// TODO Auto Generated method stub
			
		}
		
		/**
		 *命令完成时回调 
		 * 
		 */		
		public function exit():void
		{
			// TODO Auto Generated method stub
			
		}
		
		/**
		 *命令更新时回调 
		 * 
		 */		
		public function update():void
		{
			
		}
		
		/**
		 *进入下一条命令 
		 * 
		 */		
		public function nextCommond():void
		{
			
			movie.nextCommond();
		}
	}
}