package XGameEngine.GameObject.GameObjectComponent.Anime
{
	import XGameEngine.Constant.AnimeLabel;
	import XGameEngine.Constant.Error.UnSupportMethodError;
	import XGameEngine.Util.GameUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 *由单张图片素材切图形成的动画组
	 * @author Administrator
	 * 
	 */	
	public class RPGImageAnimeGroup extends AbstractAnimeGroup
	{
		/**
		 *普通的4*4行走图  具有四个方向的行走动画
		 */		
		static public var TYPE_NORMAL4X4:int=1;
		
		
		/**
		 *图片 
		 */		
		private var b:DisplayObject;
		/**
		 *图片类型 
		 */		
		private var type:int;
		/**
		 *切图速度 几帧切一次 
		 */		
		private var playSpeed:int;
		/**
		 *单张动作的宽度
		 */		
		private var partWidth:Number;
		/**
		 *单张动作的高度
		 */		
		private var partHeight:Number;
		
		
		private var isAnimePlay:Boolean=false;
		private var currentPlayAnime:String;
		
		
		public function RPGImageAnimeGroup(b:DisplayObject,type:int,playSpeed:int=3)
		{
			
			this.b=b;
			this.type=type;
			this.playSpeed=playSpeed;
			
			addChild(b);
			
			
			
		}
		
		override protected function Init():void
		{
			
			
			
			//创建遮罩
			createMask();
			initWH();
			
			
			getFunComponent().addRecallFun("changePosition",playSpeed,changePosition,null,true);
		}
		
		
		
		
		
		
		
		private function changePosition():void
		{
			//不断变换图片位置 形成动画错觉 
			if(isAnimePlay)
			{
				b.x-=partWidth;
				if(b.x<=-partWidth*4)
				{
					b.x=0;
				}
			}
			
			
		}
		
		private function initWH():void
		{
			if(type==TYPE_NORMAL4X4)
			{
				partHeight=b.height/4;
				partWidth=b.width/4;
			
			}
			
			
		}
		
	
		
		private function createMask():void
		{
			
			if(type==TYPE_NORMAL4X4)
			{
				
				var mask:Bitmap=GameUtil.createSimpleBitmap(b.width/4,b.height/4);
				addChild(mask);
				
				b.mask=mask;
			}
			
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
			
			if(labelName==currentPlayAnime)
			{
				return;
			}
			
			
			currentPlayAnime=labelName;
			
			if(type==TYPE_NORMAL4X4)
			{
				isAnimePlay=true;
				//设置初始位置
				
				if(labelName==AnimeLabel.MOVE_DOWN)
				{
					b.y=0;
					b.x=0;
				}
				else if(labelName==AnimeLabel.MOVE_LEFT)
				{
					b.y=-partHeight*1;
					b.x=0;
				}
				else if(labelName==AnimeLabel.MOVE_RIGHT)
				{
					b.y=-partHeight*3;
					b.x=0;
				}
				else if(labelName==AnimeLabel.MOVE_UP)
				{
					b.y=-partHeight*2;
					b.x=0;
				}
				else
				{
					throwNoSuchAnimeError(labelName);
				}
			}
			
			
			
			
		}
		
		
		override public function stopAnime():void
		{
			isAnimePlay=false;
			currentPlayAnime=null;
			
			//设置到每个动画的第一个动作
			if(type==TYPE_NORMAL4X4)
			{
				b.x=0;
			}
			
			
		}
		
		
		
	}
}