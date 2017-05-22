package XGameEngine.GameObject
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import XGameEngine.GameObject.BaseGameObject;
	
	/**
	 * ...
	 * 轻量级的对象 适用于播放一次就消失的特效
	 */
	public class AutoDestroyObject extends BaseGameObject
	{
		
		private var animation:Animation;
		
		/**
		 * 两者参数只要填一个就可以 都填了默认优先第一个
		 * @param	animation
		 * @param	animationName
		 */
		public function AutoDestroyObject(animation:Animation=null,animationName:String=null)
		{
			if (animation != null)
			{
				
				this.animation = animation;
				addChild(animation);
			}
			else if (animationName != null)
			{
				this.animation = this.getAnimeComponent().LoadAnimeByName(animationName);
			}
			else
			{
				throw new Error("need a animation!");
			}
			
			this.animation.play();
		}
		
		
		
		
		
		
		override protected function loop() 
		{
			if (animation.currentFrame == animation.totalFrames)
			{
				animation.stop();
				this.removeChild(animation);
				this.animation = null;
				destroy();
			}
		}
		
		
		
		
		
		
		
		
	}
	
}