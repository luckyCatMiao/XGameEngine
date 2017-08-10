package XGameEngine.GameObject.GameObjectComponent.Anime
{
	import XGameEngine.Constant.Error.UnSupportMethodError;
	
	import flash.display.Bitmap;

	public class RPGImageAnimeGroup extends AbstractAnimeGroup
	{
		/**
		 *普通的4*4行走图 
		 */		
		static public var TYPE_NORMAL4X4:int=1;
		
		
		
		private var b:Bitmap;
		private var type:int;
		
		
		
		public function RPGImageAnimeGroup(b:Bitmap,type:int)
		{
			this.b=b;
			this.type=type;
			
			
		}
		
		override public function get animeCount():int
		{

			if(type==TYPE_NORMAL4X4)
			{
				return 4;
			}
			
			return 0;
			
		}
		
		override public function get currentClip():AbstractAnimeClip
		{
			//不支持返回子剪辑 也是flash的锅 因为没有提供api创建一个movieclip然后改变每帧
			throw new UnSupportMethodError();
		}
		
		override public function playAnime(labelName:String):void
		{
			
		}
		
		
		
		
	}
}