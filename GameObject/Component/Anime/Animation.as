package XGameEngine.GameObject.Component.Anime
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * MovieClip的装饰器类 
	 * @author o
	 */
	public class Animation extends Sprite 
	{
		//实际包装的影片剪辑
		private var clip:MovieClip;
		
		
		public function Animation(m:MovieClip,add:Boolean=true)
		{
			this.clip=m;
			
			//如果需要add 则添加到子级 否则保持一种引用关系 一般最外层的需要添加 否则不能渲染出来
			if(add)
			{
				addChild(clip);
			}
			
		}
		
		
		public function isLastFrame():Boolean
		{
			
				return this.clip.currentFrame==this.clip.totalFrames;
			
		}
		
		
		
		public function playAnime(labelName:String)
		{

			try
			{
				this.clip.gotoAndStop(labelName);
			}
			catch(e:ArgumentError)
			{
				throw new Error("the target label "+labelName+" doesn't exist in the movieclip")
			}
		}
		
		
		/**
		 * 返回当前播放的子剪辑
		 * 因为一般人物动画都是两层 需要用该方法获取到子影片剪辑
		 */
		public function get currentClip():Animation
		{
			if(clip.getChildAt(0) is MovieClip)
			{
				return new Animation(clip.getChildAt(0) as MovieClip,false);
			}
			else
			{
				throw new Error("the inner child is not a movieClip!");
			}
				

		}
		
		
		
		
		
		public function get currentFrame():int
		{		
				return clip.currentFrame;
		}
		
		
		public function stop()
		{
			clip.stop();	
		}
		
		
		public function play()
		{
			clip.play();	
		}
		
		
		
		public function get totalFrames()
		{
			return clip.totalFrames;
		}
	}
	
}