package XGameEngine.GameObject
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import XGameEngine.GameObject.BaseGameObject;
	
	/**
	 * ...
	 * 轻量级的对象 适用于播放一次就消失的特效(该对象默认禁用了所有组件的功能)
	 */
	public class AutoDestroyObject extends BaseGameObject
	{
		
		private var animation:Animation;
		
		public function AutoDestroyObject(animation:Animation)
		{
				this.animation = animation;
				addChild(animation);
		}
		
		
		override protected function loop() 
		{
			if (animation.currentFrame == animation.totalFrames)
			{
				destroy();
			}
		}
		
		
		
		
		
		
		
		
	}
	
}