package XGameEngine.Manager
{
	import XGameEngine.GameEngine;
	import XGameEngine.GameObject.GameObjectComponent.Anime.MovieClipAnimeGroup;
	import XGameEngine.UI.Base.BaseUI;
	
	import flash.display.BitmapData;
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
				return cls1;
			} 
			catch(error:Error) 
			{
				
			}
			
			
			
			cls1=GameEngine.getInstance().dataDomain.getDefinition(name) as Class;
			return cls1;
		}
		
		public  function LoadAnimationByName(name:String):XGameEngine.GameObject.GameObjectComponent.Anime.MovieClipAnimeGroup
		{
			var cls:Class=getClassByName(name);
			
			var value:MovieClip=new cls() as MovieClip;
			
			if(value==null)
			{
				throw new Error("load Animation "+name+" failed");
			}
			
			var anim:MovieClipAnimeGroup=new MovieClipAnimeGroup(value);
			
			
			return anim;
		}
		
		
		
		public function LoadDisPlayObjectByName(name:String):DisplayObject
		{
			var cls:Class=getClassByName(name);
			
			var value:DisplayObject=new cls() as DisplayObject;
			if(value==null)
			{
				throw new Error("load DisplayObject "+name+" failed");
			}
			
			return value;
		}
		
		
		/**
		 *加载一个ui 因为fb里面并不能获取到flash里面创建的类的信息 所以不用字符串来创建类就会出错
		 * 虽然最后还是用flash编译 但是出错提示看的很不爽 还是用字符串来加载好了 
		 * @param name
		 * @return 
		 * 
		 */		
		public function LoadUIByName(name:String):BaseUI
		{
			var cls:Class=getClassByName(name);
			
			var value:BaseUI=new cls() as BaseUI;
			if(value==null)
			{
				throw new Error("load UI "+name+" failed");
			}
			
			return value;
		}
		
		
		/**
		 *加载bitmapdata 
		 * @param name
		 * @return 
		 * 
		 */		
		public function LoadBitmapDataByName(name:String):BitmapData
		{
			var cls:Class=getClassByName(name);
			
			var value:BitmapData=new cls() as BitmapData;
			if(value==null)
			{
				throw new Error("load BitmapData "+name+" failed");
			}
			
			return value;
		}
	}
}