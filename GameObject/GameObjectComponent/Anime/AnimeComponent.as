package XGameEngine.GameObject.GameObjectComponent.Anime
{
	import XGameEngine.GameObject.*;
	import XGameEngine.GameObject.GameObjectComponent.*;
	import XGameEngine.Util.*;
	

	/**
	 * ...
	 * @author o
	 */
	public class AnimeComponent extends BaseComponent
	{
		/**
		 *所控制的动画 即每个游戏对象只有一个动画对象 所以所有子动画都要放在该动画下面 
		 */		
		private var _anime:Animation;
		
		
		
		public function AnimeComponent(o:BaseGameObject)
		{
			super(o);
		}
		
		
		
		public function set animeClip(anime:Animation)
		{
			
			getCommonlyComponent().checkNull(anime);
			if(_anime!=null)
			{
				throw new Error("the anime has exist!the value can only set once!!");
			}
			
			
			this._anime=anime;
			host.addChild(anime);
		}
		
		public function get animeClip()
		{
			return _anime;
		}
		
		
		
		public function isLastFrame():Boolean
		{
			
			return animeClip.isLastFrame();
			
		}
		
		
		
		public function playAnime(labelName:String)
		{
			
			animeClip.playAnime(labelName);
		}
		
		
		/**
		 * 返回当前播放的子剪辑
		 * 因为一般人物动画都是两层 需要用该方法获取到子影片剪辑
		 */
		public function get currentClip():Animation
		{
			return animeClip.currentClip;
		}
		
		
		
		
		
		public function get currentFrame():int
		{		
			return animeClip.currentFrame;
		}
		
		
		public function stop()
		{
			animeClip.stop();
		}
		
		
		public function play()
		{
			animeClip.play();
		}
		
		
		
		public function get totalFrames()
		{
			return animeClip.totalFrames;
		}
		
//		/**
//		 * 根据名字反射加载动画片段
//		 * @param	aname
//		 */
//		public function LoadAnimeByName(aname:String,setAsAnime:Boolean=false)
//		{
//			var anime:Animation = GameUtil.LoadAnimationByName(aname);
//			anime.stop();
//			host.getGameObjectComponent().addChildToBeforeHighestDepth(anime);
//			if(setAsAnime)
//			{
//				this._anime=anime;
//			}
//			return anime;
//		}
		
		
	}
	
}