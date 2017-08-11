package XGameEngine.GameObject
{
	import XGameEngine.GameObject.BaseGameObject;
	import XGameEngine.GameObject.GameObjectComponent.Anime.AbstractAnimeClip;
	import XGameEngine.GameObject.GameObjectComponent.Anime.MovieClipAnimeGroup;
	import XGameEngine.Manager.ResourceManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * 轻量级的对象 适用于播放一次就消失的特效
	 */
	public class AutoDestroyObject extends BaseGameObject
	{
		
		private var anime:AbstractAnimeClip;
		
		/**
		 * 两者参数只要填一个就可以 都填了默认优先第一个
		 * @param	animation
		 * @param	animationName
		 */
		public function AutoDestroyObject(animeClip:AbstractAnimeClip=null,animeClipName:String=null)
		{
			if (animeClip != null)
			{
				
				this.anime = animeClip;
				addChild(this.anime);
			}
			else if (animeClipName != null)
			{
				this.anime = ResourceManager.getInstance().LoadAnimeClipByName(animeClipName);
				addChild(this.anime);
			}
			else
			{
				throw new Error("need a animation!");
			}
			
			this.anime.play();
		}
		
		
		
		
		
		
		override protected function loop():void
		{
			if (anime.currentFrame == anime.totalFrames)
			{
				anime.stop();
				this.removeChild(anime);
				
				this.anime = null;
				destroy();
			}
		}
		
		
		
		
		
		
		
		
	}
	
}