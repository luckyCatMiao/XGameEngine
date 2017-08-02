package XGameEngine.Util.WebsiteAPI
{
	
	
	public class API4399
	{
		/**
		 *以下键值估计是4399在加载的时候根据反射验证对应键值是否存在 然后在后台进行功能开放 
		 */	
		/**
		 *排行榜api的验证值 
		 */	
		public static var _4399_function_gameList_id:String = "944c23f5e64a80647f8d0f3435f5c7a8";
		/**
		 *上传分数api的验证值 
		 */	
		public static var _4399_function_score_id:String = "d8c8d4731a33a0a581edc746e73eadc7200";
		
		
		/**
		 *和后台通信的对象 在加载时被注入 
		 */		
		private static var serviceHolder:*=null;
		

		
		public function API4399()
		{
		}
		
		
		/**
		 *注入通信对象  需要在主类调用
		 * @param hold
		 * 
		 */		
		public static function setHolder(hold:*):void
		{
			serviceHolder=hold;
			
		}
		
		
		
		/**
		 *显示更多游戏 
		 * 
		 */		
		public static function showGameList():void
		{
		
			if(serviceHolder){
				serviceHolder.showGameList();
			}
			
		}
		
		/**
		 *提交分数 
		 * @param score
		 * 
		 */		
		public static function updateScore(score:int):void
		{
			if(serviceHolder){
				serviceHolder.showRefer(score); //socre为你的分数变量，类型为int   
			}
			
		}
		
		/**
		 *显示分数排行榜 
		 * 
		 */		
		public static function showRanking():void
		{
			
			
			if(serviceHolder){
				serviceHolder.showSort();
			}
			
		}
	}
}