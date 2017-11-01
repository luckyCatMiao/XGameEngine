package XGameEngine.Plugins.Movie.Command
{
	import XGameEngine.Plugins.Movie.BaseMovie;
	import XGameEngine.BaseObject.BaseDisplayObject;
	
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