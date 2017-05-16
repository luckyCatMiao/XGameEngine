package XGameEngine.Util
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import XGameEngine.GameObject.Animation;
	import XGameEngine.GameObject.BaseGameObject;
	/**
	 * ...
	 * @author o
	 */
	public class GameUtil 
	{
		/**
		 * Load the movieClip by name,if the target class don't exist,
		 * it will throw a error
		 * @param	name
		 * @return
		 */
		static public function LoadGameObjectByName(name:String):BaseGameObject
		{
			//if the name doesn't exist,throw a customize error
			var animeClass:Class =getClassByName(name);
			try
			{
				animeClass = getDefinitionByName(name) as Class;
			}
			catch (e:ReferenceError)
			{
				throw new Error("the target class which named " + name+" doesn't exist");
			}
			
			
			
			var anime:BaseGameObject = (new animeClass()) as BaseGameObject;
			if (anime == null)
			{
				throw new Error("case error!please set target class as baseGameObject")
			}
			
			return anime;
		}
		
		
		/**
		 * Load the movieClip by name,if the target class don't exist,
		 * it will throw a error
		 * @param	name
		 * @return
		 */
		static public function LoadAnimationByName(name:String):Animation
		{
			//if the name doesn't exist,throw a customize error
			var animeClass:Class =getClassByName(name);
			
			
			
			
			var anime:Animation = (new animeClass()) as Animation;
			if (anime == null)
			{
				throw new Error("case error!please set target class as Animation")
			}
			
			return anime;
		}
		
		
		
		static private function getClassByName(name:String):Class
		{
			var animeClass:Class;
			//if the name doesn't exist,throw a customize error
			try
			{
				animeClass = getDefinitionByName(name) as Class;
			}
			catch (e:ReferenceError)
			{
				throw new Error("the target class which named " + name+" doesn't exist");
			}
			
			return animeClass;
		}
	}
	
}