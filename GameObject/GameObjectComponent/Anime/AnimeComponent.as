package XGameEngine.GameObject.GameObjectComponent.Anime
{
	import XGameEngine.GameObject.*;
	import XGameEngine.GameObject.GameObjectComponent.*;
	import XGameEngine.Collections.List;
	import XGameEngine.Util.*;
	
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	

	/**
	 * 
	 * 动画组件 可以处理以下类型
	 * ...
	 * @author o
	 */
	public class AnimeComponent extends BaseGameObjectComponent
	{
		
		
		/**
		 *所控制的动画组  即每个游戏对象只有一个动画组 所以所有子动画都要放在该动画下面 
		 */		
		private var _anime:AbstractAnimeGroup;
		
		
		
		public function AnimeComponent(o:BaseGameObject)
		{
			super(o);
		}
		
		
		
		public function set animeGroup(anime:AbstractAnimeGroup)
		{
			
			getCommonlyComponent().checkNull(anime);
			//设置过后就不能再设置
			if(_anime!=null)
			{
				throw new Error("the anime has exist!the value can only set once!!");
			}
			
			
			this._anime=anime;
			host.addChild(anime as DisplayObject);
		}
		
		
		
		
		public function get animeGroup():AbstractAnimeGroup
		{
			return _anime;
		}
		
		
		
		
		public function playAnime(labelName:String):void
		{
			animeGroup.playAnime(labelName);
		}
		
		
		/**
		 * 返回当前播放的子剪辑
		 * 因为一般人物动画都是两层 需要用该方法获取到子影片剪辑
		 */
		public function get currentClip():AbstractAnimeClip
		{
			
			return animeGroup.currentClip;
			
		}
		
		
//		/**
//		 *检查动画是否有指定的子动画
//		 * @param an
//		 * @param labels
//		 * @return 
//		 * 
//		 */		
//		public function checkAnimeLabel(an:MovieClipAnime,labels:Array)
//		{
//			//转换成名字
//			var arr:Array=an.clip.currentLabels;
//			var hasLabels:List=new List();
//			for each(var l:FrameLabel in arr)
//			{
//				hasLabels.add(l.name);
//			}
//			
//		
//			
//			for each(var s:String in labels)
//			{
//				if(!hasLabels.contains(s))
//				{
//					throw new Error("the target "+s+" anime don't exist!");
//				}
//			}
//			
//			
//		}
		
	
		
		
		public function stopAnime():void
		{
			animeGroup.stopAnime();
			
		}
	}
	
}