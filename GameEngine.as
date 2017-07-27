package XGameEngine
{
	import XGameEngine.Advanced.Debug.*;
	import XGameEngine.Advanced.Interface.LoopAble;
	import XGameEngine.Manager.*;
	import XGameEngine.Structure.*;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;

	/**
	 * ...
	 * a class that control the overall gameengine
	 */
	public class GameEngine 
	{
		static private var _instance:GameEngine;
		
		
		public function get dataDomain():ApplicationDomain
		{
			return _dataDomain;
		}

		static public function getInstance():GameEngine
		{
				if (_instance == null)
				{
					_instance = new GameEngine();
				}
				return _instance;
		}
		
		
		private var s:Stage;
		private var list:List = new List();
		private var _debug:Boolean = false;
		
		/**
		 * 游戏运行中能否改变debug状态 发行版游戏中一般设置为false
		 */
		public var canChangeDebug:Boolean=false;
		private var _dataDomain:ApplicationDomain;
		private var loadCompleteFun:Function;
		private var loadProgressFun:Function;
		
		
		
		
		/**
		 *游戏面板 
		 */		
		public var gamePlane:Sprite;		
		/**
		 *ui面板 层级高于游戏面板 
		 */		
		public var UIPlane:Sprite;
		/**
		 *debug面板 层级高于UI面板 
		 */		
		public var debugPlane:Sprite;
		
		
		/**
		 * this should be called when game inited,generally from the entry class
		 * 初始化游戏引擎 
		 * @param s 舞台
		 * @param dataPath 资源文件路径
		 * @param loadCompleteFun 加载资源完成的监听
		 * @param loadProgressFun 加载资源中的监听
		 * @return 
		 * 
		 */		
		public function Init(s:Stage,dataPath:String,loadCompleteFun:Function=null,loadProgressFun:Function=null)
		{
			
			this.s = s;
			s.addEventListener(Event.ENTER_FRAME, loop);
			
			
			initShowPlane();
			
			//初始化子模块
			InitManager();
			
			//加载资源
			startLoadResource(dataPath,loadCompleteFun,loadProgressFun);
			
		}
		
		
		/**
		 *初始化显示面板 
		 * 
		 */		
		private function initShowPlane():void
		{
			gamePlane=new Sprite();
			s.addChild(gamePlane);
			
			UIPlane=new Sprite();
			s.addChild(UIPlane);
			
			debugPlane=new Sprite();
			s.addChild(debugPlane);
			
		}		
		
		/**
		 * 
		 * 
		 */		
		private function startLoadResource(dataPath:String,loadCompleteFun:Function,loadProgressFun:Function):void
		{
			var loader:Loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadProgress);
			var request:URLRequest=new URLRequest(dataPath);
			loader.load(request);
			
			
			this.loadCompleteFun=loadCompleteFun;
			this.loadProgressFun=loadProgressFun;
		}
		
		protected function loadProgress(event:ProgressEvent):void
		{
			if(loadProgressFun!=null)
			{
				loadProgressFun(event);
			}
			
		}
		
		protected function loadComplete(event:Event):void
		{
			var loadedSWF=event.target;
			var domain:ApplicationDomain =loadedSWF.applicationDomain as ApplicationDomain;
			
			this._dataDomain=domain;
			
			if(loadCompleteFun!=null)
			{
				loadCompleteFun(event);
			}
		}		
		
		
	
		
		
		/**
		 * 初始化管理器
		 */
		private function InitManager()
		{
			DebugManager.getInstance();
			TimeManager.getInstance();
			HitManager.getInstance();
			
			//初始化输入管理器
			Input.Init(s);
			
		}
		
		public function getTimeManager():TimeManager
		{
			return TimeManager.getInstance();
		}
		
		public function getTagManager():TagManager
		{
			return TagManager.getInstance();
		}
		
		public function getGameObjectManager():GameObjectManager
		{
			return GameObjectManager.getInstance();
		}
		public function getLayerManager():LayerManager
		{
			return LayerManager.getInstance();
		}
		public function getHitManager():HitManager
		{
			return HitManager.getInstance();
		}
		public function getSoundManager():SoundManager
		{
			return SoundManager.getInstance();
		}
		public function getResourceManager():ResourceManager
		{
			return ResourceManager.getInstance();
		}
		
		private function loop(e:Event)
		{
			for (var i = 0; i < list.size; i++)
			{
				(list.get(i) as LoopAble).loop();
			}
			
			
		}
		
		public function addLoopAble(l:LoopAble)
		{
			list.add(l);
			
		}
		
		public function getStage():Stage 
		{
			return s;
		}
		
		public function get debug():Boolean 
		{
			return _debug;
		}
		
		public function set debug(value:Boolean):void 
		{
			if (canChangeDebug)
			{
				_debug = value;
			}
			
		}
		
	}
	
}