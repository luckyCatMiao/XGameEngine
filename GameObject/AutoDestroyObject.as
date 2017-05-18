package XGameEngine.GameObject
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import XGameEngine.GameObject.BaseGameObject;
	
	/**
	 * ...
	 * 轻量级的对象 不会加入到对象管理器中 适用于播放一次就消失的特效
	 */
	public class AutoDestroyObject extends MovieClip
	{
		public function AutoDestroyObject()
		{
				this.addEventListener(Event.ENTER_FRAME, loop,false,0,true);
		}
		
		public function loop(e:Event)
		{
			if (this.currentFrame == this.totalFrames)
			{
				this.removeEventListener(Event.ENTER_FRAME, loop);
				this.parent.removeChild(this);
			}
		}
		
		
		
	}
	
}