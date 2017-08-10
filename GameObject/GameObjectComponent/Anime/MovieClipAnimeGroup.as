package XGameEngine.GameObject.GameObjectComponent.Anime
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * MovieClip的动画组(一个常见的两层的Movieclip)
	 * @author o
	 */
	public class MovieClipAnimeGroup extends AbstractAnimeGroup
	{
		
		//实际包装的影片剪辑
		private var _clip:MovieClip;
		

		
		public function MovieClipAnimeGroup(m:MovieClip)
		{
			this._clip=m;
			addChild(_clip);
			
			//粗略检查一下该movieclip是否是两层 即是否是动画组
			if(!(movieClip.getChildAt(0) is MovieClip))
			{
				throw new Error("不是动画组!");
			}
		}
		
		
		public function get movieClip():MovieClip
		{
			return _clip;
		}


		override public function playAnime(labelName:String):void
		{
			
			try
			{
				this.movieClip.gotoAndStop(labelName);
			}
			catch(e:ArgumentError)
			{
				throw new Error("the target label "+labelName+" doesn't exist in the movieclip")
			}
		}
		
		
		override public function get currentClip():AbstractAnimeClip
		{
			if(movieClip.getChildAt(0) is MovieClip)
			{
				return new MovieClipAnimeClip(movieClip.getChildAt(0) as MovieClip,false);
			}
			else
			{
				throw new Error("the inner child is not a movieClip!");
			}
		}
		
		
	
		override public function get animeCount():int
		{
			
			//查找标签数量来返回
			return 0;
		}
		
		
		
		
		
		
	
	}
	
}