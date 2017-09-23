package XGameEngine.Manager
{
	import XGameEngine.GameEngine;
	import XGameEngine.GameObject.GameObjectComponent.Anime.AbstractAnimeClip;
	import XGameEngine.GameObject.GameObjectComponent.Anime.MovieClipAnimeClip;
	import XGameEngine.GameObject.GameObjectComponent.Anime.MovieClipAnimeGroup;
	import XGameEngine.Structure.List;
	import XGameEngine.Structure.Map;
	import XGameEngine.UI.Base.BaseUI;
	
	import flash.display.Bitmap;
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
		private var textDatas:Map=new Map();
		private var imageDatas:Map=new Map();
		
		
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
		
		public function getClassByName(name:String):Class
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
		
		
		
		
		
		/**
		 * 根据名字加载一个displayobject的父类 还可以加载bitmapdata 
		 * @param name
		 * @param packBitmapdata 如果是bitmapdata，是否自动包装为bitmap返回
		 * @return 
		 * 
		 */		
		public function LoadDisPlayObjectByName(name:String,packBitmapdata:Boolean=false):*
		{
			var cls:Class=getClassByName(name);
			
			if((new cls() is BitmapData)&&packBitmapdata)
			{
				var data:BitmapData=new cls() as BitmapData ;
				var bitmap:Bitmap=new Bitmap(data);
				return bitmap;
			}
			else
			{
				var value:DisplayObject=new cls() as DisplayObject;
				if(value==null)
				{
					throw new Error("load DisplayObject "+name+" failed");
				}
				
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
		 *加载bitmap
		 * @param name
		 * @return 
		 * 
		 */		
		public function LoadBitmapByName(name:String): Bitmap
		{
			var cls:Class=getClassByName(name);
			
			var value:BitmapData=new cls() as BitmapData;
			if(value==null)
			{
				throw new Error("load BitmapData "+name+" failed");
			}
			
			
			
			return new Bitmap(value);
		}
		
		
		/**
		 *加载bitmapData
		 * @param name
		 * @return 
		 * 
		 */		
		public function LoadBitmapDataByName(name:String): BitmapData
		{
			var cls:Class=getClassByName(name);
			
			var value:BitmapData=new cls() as BitmapData;
			if(value==null)
			{
				throw new Error("load BitmapData "+name+" failed");
			}
			
			
			
			return value;
		}
		
		/**
		 *load the animeclip by target name,this function exactly load a movieclip and pack it into animeclip 
		 * @param name
		 * @return 
		 * 
		 */		
		public function LoadAnimeClipByName(name:String):AbstractAnimeClip
		{
			var cls:Class=getClassByName(name);
			
			var value:MovieClip=new cls() as MovieClip;
			
			if(value==null)
			{
				throw new Error("load Animation "+name+" failed");
			}
			
			var anim:MovieClipAnimeClip=new MovieClipAnimeClip(value);
			
			
			return anim;
		}
		
		/**
		 *add text data to cache  
		 * @param name
		 * @param data
		 * 
		 */		
		public function addTextData(name:String, data:*):void
		{
			this.textDatas.put(name,data);
			
		}
		
		/**
		 *add image data to cache 
		 * @param name
		 * @param data
		 * 
		 */		
		public function addImageData(name:String, data:*):void
		{
			this.imageDatas.put(name,data);
			
		}
		
		/**
		 *get image data from cache(it's not same as loadBitmapByName which was load from libray directly) 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getImageData(name:String):Bitmap
		{
			return this.imageDatas.get(name) as Bitmap;
			
		}
		
		/**
		 *get text data from cache 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getTextData(name:String):String
		{
			return this.textDatas.get(name) as String;
			
		}
	}
}