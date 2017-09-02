package XGameEngine.Manager
{
	import XGameEngine.Structure.Map;
	import XGameEngine.Util.GameUtil;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * ...
	 * 音频管理器
	 */
	public class SoundManager extends BaseManager
	{
		
		static private var _instance:SoundManager;
		private var map:Map=new Map();
		
		static public function getInstance():SoundManager
		{
				if (_instance == null)
				{
					_instance = new SoundManager();
				}
				return _instance;
		}
		
	
		
		/**
		 * 播放音乐 
		 * @param s 声音类
		 * @param loopTimes 循环次数 默认为无限循环
		 * @param volume 音量
		 * 
		 */		
		public function startPlaySound(s:Sound, loopTimes:Number = -1, volume:Number=1):SoundChannel
		{
			//9999次差不多算是无限次了 因为这个flash这个类本身没有提供无限次的写法 只能这么写了
			
			var c:SoundChannel=s.play(0, loopTimes==-1?9999:loopTimes);
			var transform:SoundTransform = c.soundTransform;
			transform.volume = volume;
			c.soundTransform = transform;
			
			
			return c;
		}
		
		
		/**
		 * 直接加载声音并播放
		 * @param name 名字
		 * @param loopTimes 循环次数 默认为无限循环
		 * @param volume 音量
		 * 
		 */		
		public function startPlaySoundByName(name:String, loopTimes:Number = -1, volume:Number=1):void
		{
			var sound:Sound=ResourceManager.getInstance().LoadSoundByName(name);
	
			var c:SoundChannel=startPlaySound(sound,loopTimes,volume);
			
			
			map.put(name,c);
			
		}
		
		/**
		 *停止播放声音 
		 * @param name
		 * 
		 */		
		public function stopPlaySoundByName(name:String):void
		{
			if(map.get(name)!=null)
			{
				var c:SoundChannel=map.get(name);
				c.stop();	
			}
		}
	}
	
}