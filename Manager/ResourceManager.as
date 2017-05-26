package XGameEngine.Manager
{
	import XGameEngine.GameEngine;
	import XGameEngine.GameObject.Animation;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.media.Sound;

	/**
	 * 管理外部资源的类
	 */
	public class ResourceManager extends BaseManager
	{
		
		static private var _instance:ResourceManager;
		
		
		static public function getInstance():ResourceManager
		{
			if (_instance == null)
			{
				_instance = new ResourceManager();
			}
			return _instance;
		}
		
		
		
		public function LoadSoundByName(name:String):Sound
		{
			var cls:Class=getClassByName(name);
			
			var value:Sound=new cls() as Sound;
			if(value==null)
			{
				throw new Error("load Sound "+name+" failed");
			}
			
			
			return value;
		}
		
		private function getClassByName(name:String):Class
		{
			var cls:Class=GameEngine.getInstance().dataDomain.getDefinition(name) as Class;
			
			
			return cls;
		}
		
		public  function LoadAnimationByName(name:String):XGameEngine.GameObject.Animation
		{
			var cls:Class=getClassByName(name);
			
			var value:MovieClip=new cls() as MovieClip;
			
			if(value==null)
			{
				throw new Error("load Animation "+name+" failed");
			}
			
			var anim:Animation=new Animation(value);
			
			
			return anim;
		}
		
		public  function LoadDisPlayObjectByName(name:String):DisplayObject
		{
			var cls:Class=getClassByName(name);
			
			var value:DisplayObject=new cls() as DisplayObject;
			if(value==null)
			{
				throw new Error("load DisplayObject "+name+" failed");
			}
			
			return value;
		}
	}
}