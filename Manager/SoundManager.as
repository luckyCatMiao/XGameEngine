package XGameEngine.Manager
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import XGameEngine.Util.GameUtil;
	/**
	 * ...
	 * 音频管理器
	 */
	public class SoundManager extends BaseManager
	{
		
		static private var _instance:SoundManager;
		
		static public function getInstance():SoundManager
		{
				if (_instance == null)
				{
					_instance = new SoundManager();
				}
				return _instance;
		}
		
//以后都强制性用外部库的声音了 不然每次编译声音文件都要编译导致很慢	
//		/**
//		 * 加载库里的声音对象并播放
//		 * @param	className
//		 * @param	loopTimes 循环次数 -1为一直循环
//		 */
//		public function StartPlaySoundByName(className:String, loopTimes:Number = -1, volume:Number=1):void 
//		{
//			var s:Sound = GameUtil.LoadSoundByName(className);
//			
//			
//			StartPlaySound(s,loopTimes,volume);
//		}
//		
		
		/**
		 * 播放音乐 
		 * @param s 声音类
		 * @param loopTimes 循环次数 默认为无限循环
		 * @param volume 音量
		 * 
		 */		
		public function StartPlaySound(s:Sound, loopTimes:Number = -1, volume:Number=1):void 
		{
			//9999次差不多算是无限次了 因为这个flash这个类本身没有提供无限次的写法 只能这么写了
			
			var c:SoundChannel=s.play(0, loopTimes==-1?9999:loopTimes);
			var transform:SoundTransform = c.soundTransform;
			transform.volume = volume;
			c.soundTransform = transform;
		}
		
		
		/**
		 * 直接加载声音并播放
		 * @param name 名字
		 * @param loopTimes 循环次数 默认为无限循环
		 * @param volume 音量
		 * 
		 */		
		public function StartPlaySoundByName(name:String, loopTimes:Number = -1, volume:Number=1):void
		{
			var sound:Sound=ResourceManager.getInstance().LoadSoundByName(name);
			
			
			StartPlaySound(sound,loopTimes,volume);
		}
	}
	
}