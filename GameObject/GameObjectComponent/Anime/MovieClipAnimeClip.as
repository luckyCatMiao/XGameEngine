package XGameEngine.GameObject.GameObjectComponent.Anime
{
	import flash.display.MovieClip;

	/**
	 *包装movieclip的animeclip 
	 * @author Administrator
	 * 
	 */	
	public class MovieClipAnimeClip extends AbstractAnimeClip
	{
		private var clip:MovieClip;
		
		/**
		 * 
		 * @param m 需要包装的对象
		 * @param add 是否将包装对象添加到子级 这里是因为flash本身架构的一些问题
		 * 因为这个movieclip可能本身已经在另外一个movieclip里了
		 * 
		 */		
		public function MovieClipAnimeClip(m:MovieClip,add:Boolean=true)
		{
			
			this.clip=m;
			
			//如果需要add 则添加到子级 否则保持一种引用关系 一般最外层的需要添加 否则不能渲染出来
			if(add)
			{
				addChild(clip);
			}
		}
		
		
		
		override public function get currentFrame():int
		{
			return clip.currentFrame;
		}
		

		override public function play()
		{
			clip.play();
		}
		
		override public function stop()
		{
			clip.stop();
		}
		
		override public function get totalFrames()
		{
			return clip.totalFrames;
		}
		
		
		
	}
}