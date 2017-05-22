package XGameEngine.GameObject.Component
{
	import XGameEngine.Util.*;
	import XGameEngine.GameObject.*;
	import XGameEngine.GameObject.Component.*;
	/**
	 * ...
	 * @author o
	 */
	public class AnimeComponent extends BaseComponent
	{
		public function AnimeComponent(o:BaseGameObject)
		{
			super(o);
		}
		
		/**
		 * 根据名字反射加载动画片段
		 * @param	aname
		 */
		public function LoadAnimeByName(aname:String)
		{
			var anime:Animation = GameUtil.LoadAnimationByName(aname);
			anime.stop();
			host.getGameObjectComponent().addChildToBeforeHighestDepth(anime);
			return anime;
		}
		
	}
	
}