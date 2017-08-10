package XGameEngine.GameObject.GameObjectComponent.Anime
{
	import flash.display.Sprite;

	/**
	 *保存了一组动画 
	 * @author Administrator
	 * 
	 */	
	public class AbstractAnimeGroup extends Sprite
	{
		public function AbstractAnimeGroup()
		{
		}
		
		/**
		 *根据名称播放动画 
		 * @param labelName
		 * 
		 */		
		public function playAnime(labelName:String):void
		{
			
		throw new Error("抽象方法");
		}
		
		
		/**
		 * 返回当前播放的动画片段
		 */
		public function get currentClip():AbstractAnimeClip
		{
			throw new Error("抽象方法");
		}
		
		
		/**
		 * 返回子动画总数
		 */
		public function get animeCount():int
		{
			throw new Error("抽象方法");
		}
	}
}