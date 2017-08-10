package XGameEngine.GameObject.GameObjectComponent.Anime
{
	import XGameEngine.BaseObject.BaseDisplayObject;
	import XGameEngine.Constant.Error.AbstractMethodError;
	
	import flash.display.Sprite;

	/**
	 *保存了一组动画 
	 * @author Administrator
	 * 
	 */	
	public class AbstractAnimeGroup extends BaseDisplayObject
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
			
			throw new AbstractMethodError();
		}
		
		
		/**
		 * 返回当前播放的动画片段
		 */
		public function get currentClip():AbstractAnimeClip
		{
			throw new AbstractMethodError();
		}
		
		
		/**
		 * 返回子动画总数
		 */
		public function get animeCount():int
		{
			throw new AbstractMethodError();
		}
		
		
		 /**
		  *停止正在播放的动画 
		  * 
		  */		
		 public function stopAnime():void
		{
			throw new AbstractMethodError();
		}
			
		
		protected function throwNoSuchAnimeError(name:String):void
		{
			throw new Error("动画组没有"+name+"该子动画");
			
		}		
		
		
		
		
	}
}