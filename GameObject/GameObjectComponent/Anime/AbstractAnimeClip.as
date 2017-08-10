package XGameEngine.GameObject.GameObjectComponent.Anime
{
	import flash.display.Sprite;
	
	/**
	 *单个动画 
	 * @author Administrator
	 * 
	 */	
	public class AbstractAnimeClip extends Sprite
	{
	
		
		
		/**
		 *是否是最后一帧 
		 * @return 
		 * 
		 */		
		public function isLastFrame():Boolean
		{
			
			return currentFrame==totalFrames;
			
		}
		
		
		/**
		 *当前帧数 
		 * @return 
		 * 
		 */		
		public function get currentFrame():int
		{		
			throw new Error("the anime has exist!the value can only set once!!");
		}
		
		/**
		 *停止播放 
		 * @return 
		 * 
		 */		
		public function stop()
		{
			throw new Error("the anime has exist!the value can only set once!!");
		}
		
		/**
		 * 开始播放
		 * @return 
		 * 
		 */
		public function play()
		{
			throw new Error("the anime has exist!the value can only set once!!");
		}
		
		/**
		 * 总帧数
		 */
		public function get totalFrames()
		{
			throw new Error("the anime has exist!the value can only set once!!");
		}
	}
}