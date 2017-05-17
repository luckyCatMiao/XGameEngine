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
		
		public function LoadAnimeByName(aname:String)
		{
			var anime:Animation = GameUtil.LoadAnimationByName(aname);
			host.addChild(anime);
			return anime;
		}
		
	}
	
}