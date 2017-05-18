package XGameEngine.GameObject
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author o
	 */
	public class Animation extends MovieClip 
	{
		public function playAnime(labelName:String)
		{
			try
			{
				this.gotoAndStop(labelName);
			}
			catch(e:ArgumentError)
			{
				throw new Error("the target label "+labelName+" doesn't exist in the movieclip")
			}
		}
		
		
		/**
		 * 返回当前动画的影片剪辑
		 * 因为一般人物动画都是两层 需要用该方法获取到子影片剪辑
		 */
		public function get currentClip():MovieClip
		{
			return this.getChildAt(0) as MovieClip;
		}
	}
	
}