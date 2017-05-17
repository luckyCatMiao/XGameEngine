package XGameEngine.GameObject
{
	import XGameEngine.Util.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import XGameEngine.GameObject.Component.*;
	
	/**
	 * ...
	 * the fundamental gameobject,provide a sets of useful features.
	 */
	public class BaseGameObject extends Sprite
	{
		
		protected var anime_com:AnimeComponent;
		protected var collide_com:CollideComponent;
		protected var physics_com:PhysicsComponent;
		

		public function BaseGameObject()
		{
			
			
			InitComponent();
			InitEvent();
		}
		
		
		
		private function InitComponent()
		{
			
			anime_com = new AnimeComponent(this);
			collide_com = new CollideComponent(this);
			physics_com = new PhysicsComponent(this);
			
		}

		
		private function InitEvent()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addTo, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, _loop, false, 0, true);
		}
		private function addTo(a:Event)
		{
			Init();
		}
		
		protected function _loop(e:Event)
		{
			if (physics_com.enable == true)
			{
				physics_com.calulate();
			}
			
			loop();
		}
		
		protected function Init()
		{
			
		}
		
		/**
		 * set the position
		 * @param	x
		 * @param	y
		 */
		public function setPosition(x:Number, y:Number)
		{
			this.x = x;
			this.y = y;
		}
		
		protected function loop()
		{
			
		}
		
		
		
		public function getAnimeComponent():AnimeComponent 
		{
			return anime_com;
		}
		
		
		

	}
	
}