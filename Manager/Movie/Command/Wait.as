package XGameEngine.Manager.Movie.Command
{
	import XGameEngine.Manager.Movie.BaseMovie;
	import XGameEngine.GameObject.BaseDisplayObject;
	
	/**
	 *等待 
	 * @author Administrator
	 * 
	 */	
	public class Wait extends BaseCommond
	{
		private var time:int;
		/**
		 * 
		 * @param m
		 * @param time 等待时间
		 * 
		 */		
		public function Wait(m:BaseMovie,time:int)
		{
			super(m, null);
			this.time=time;
		}
		
		override public function enter():void
		{
			// TODO Auto Generated method stub
			super.enter();
		}
		
		override public function exit():void
		{
			// TODO Auto Generated method stub
			super.exit();
		}
		
		override public function update():void
		{
			time--;
			if(time==0)
			{
				nextCommond();
			}
		}
		
		
		
	}
}