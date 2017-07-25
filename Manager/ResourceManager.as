package XGameEngine.Manager
{
	import XGameEngine.GameEngine;
	import XGameEngine.GameObject.GameObjectComponent.Anime.Animation;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;

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
		
		
		
		/**
		 *加载声音文件 
		 * @param name
		 * @return 
		 * 
		 */		
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
			//优先从本swf里取 这样方便测试 可以先把要多次测试的剪辑先放在主swf里面调整 调整差不多后再放到资源swf里
			var cls1:Class
			try
			{
				cls1=flash.utils.getDefinitionByName(name) as Class;
			} 
			catch(error:Error) 
			{
				
			}
			
			
			var cls:Class=GameEngine.getInstance().dataDomain.getDefinition(name) as Class;
			
			
			return cls1==null?cls:cls1;
		}
		
		public  function LoadAnimationByName(name:String):XGameEngine.GameObject.GameObjectComponent.Anime.Animation
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